require 'term/ansicolor'
include Term::ANSIColor
class String
  include Term::ANSIColor
end
require 'formatador'
require 'terminal-table'

namespace :configure do

  desc "Spin up target instance"
  task :instance do
    on roles(:all) do |host|
      pipeline = eval(File.open('/var/lib/jenkins/pipeline/pipeline_descriptor.rb', 'r').read)
      current_stage = pipeline[:stages].find { |stage| stage[:name] == fetch(:stage) }

      if pipeline[:type] == :dynamic && !current_stage[:required]
        print "\n[Devellocus Pipeline]".bold.cyan, " Setting up target instance for stage ".bold.green, "#{current_stage}".bold.yellow, "\n\n"


    		client = Aws::EC2::Client.new(:access_key_id => pipeline[:aws_access_key_id],
    																	:secret_access_key => pipeline[:aws_secret_access_key],
    																	:region => pipeline[:aws_region])
        ec2 = Aws::EC2::Resource.new(client: client)

        # find the AMI based on name
        image = ec2.images.filter('name', pipeline[:aws_ami_name]).first

        if image
          puts "==> Using AMI ".bold.green + "#{image.id}".bold.yellow
        else
          raise "==> No image found matching ".bold.red + "#{pipeline[:aws_ami_name]}".bold.yellow
        end

        # find key pair
        key_pair = ec2.key_pairs[pipeline[:aws_keypair_name]]
        puts "==> Using keypair " + "#{key_pair.name}".bold.yellow + " with fingerprint " + "#{key_pair.fingerprint}".bold.yellow

        # find security group
        security_group = ec2.security_groups.find{|sg| sg.name == pipeline[:aws_security_group_name] }
        puts "==> Using security group ".bold.green + "#{security_group.name}".bold.yellow

        # create the instance and launch it
        puts "\n==> Launching machine ...".bold
        instance = ec2.instances.create(:image_id        => image.id,
                                        :instance_type   => current_stage[:instance_type],
                                        :count           => 1,
                                        :security_groups => security_group,
                                        :key_pair        => key_pair)
        application_name = fetch(:application)
        ec2.tags.create(instance, "#{application_name}-pipeline")
        ec2.tags.create(instance, 'Name', :value => "#{application_name}-#{current_stage[:name]}")

        # wait until instance is fully operational
        sleep 1 until instance.status != :pending
        formatador = Formatador.new
        puts "==> Launched instance with id ".bold.green + "#{instance.id}".bold.yellow
        formatador.display_line("Status: " + "#{instance.status}".yellow)
        formatador.display_line("Public DNS: " + "#{instance.dns_name}".yellow)
        formatador.display_line("Public ip: " + "#{instance.ip_address}".yellow)

        if instance.status != :running
          puts "==> Exiting because instance #{instance.id} isn't running".bold.red
          exit 1
        end

        # machine is ready, ssh to it and run a commmand to confirm all is well
        puts "==> You can SSH to the instance with ...".bold.green
        formatador.display_line("ssh -i #{ENV['HOME']}/.ssh/pipeline.pem #{pipeline[:aws_ssh_user]}@#{instance.ip_address}".bold.yellow)

        puts "==> Connecting to the box to confirm all is well".bold.green
        begin
          formatador.display_line("Connecting to instance #{instance.id} ...")
          Net::SSH.start(instance.ip_address,
                         pipeline[:aws_ssh_user],
                         :keys => ["#{ENV['HOME']}/.ssh/pipeline.pem"]) do |ssh|
            puts "==> Running 'uname -a' on the instance yields:".bold.green
            formatador.display_line(ssh.exec!("uname -a").yellow)
          end
        rescue SystemCallError, Timeout::Error => e
          # port 22 might not be available immediately after the instance finishes launching
          sleep 1
          retry
        end

        puts "==> Updating pipeline_descriptor.rb with dns ".bold.green + "#{instance.dns_name}".bold.yellow +
             " and instance_id ".bold.green + "#{instance.id}".bold.yellow
        current_stage[:dns] = instace.dns_name
        current_stage[:instance_id] = instance.id
        File.open('/var/lib/jenkins/pipeline/pipeline_descriptor.rb', 'w') do |f|
          f.write pipeline
        end

        stage_filename = "config/deploy/#{current_stage[:name]}.rb"
        print "==> Setting server dns to ".bold + "#{instance.dns_name}".bold.yellow + " in stage file ".bold, "#{stage_filename}".bold.yellow, "\n"
        updated_content = File.read(stage_filename).gsub(/(ec2-.+.com)/, instance.dns_name)
        File.open(stage_filename, 'w') do |f|
          f.write updated_content
        end

        puts "\n[Devellocus Pipeline]".bold.cyan + " Deploy instance ".green + "#{instance.dns_name}".bold.yellow + " configured successfully".green

      end
    end
  end

end

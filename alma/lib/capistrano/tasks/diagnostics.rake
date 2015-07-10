require 'term/ansicolor'
include Term::ANSIColor
class String
  include Term::ANSIColor
end
require 'formatador'
# class ::Formatador
#   attr_writer :indent

#   def indent(levels = 0, &block)
#     @indent += levels
#     yield
#   ensure
#     @indent -= 1
#   end
# end
require 'terminal-table'

namespace :diagnostics do

  class DiagnosticsHelpers
    def self.truncate(result, characters)
      truncated = result[0..characters] + ' ...'
      return trunctated
    end
  end

  desc "Check for interactive shell"
  task :query_interactive do
    on 'vagrant@127.0.0.1' do
      info capture("[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'")
    end
  end
  desc "Check for login shell"
  task :query_login do
    on 'vagrant@127.0.0.1' do
      info capture("shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'")
    end
  end

  desc "Get host info"
  task :'show-host' do
    on roles(:all) do |host|
      print "\n[Devellocus Pipeline]".bold.blue, "[DIAGNOSTICS]".red, " Host info is #{host.inspect}".bold, "\n"
    end
  end

  desc "Check root capabilities"
  task :'check-root' do
    on roles(:all) do |host|
      print "\n[Devellocus Pipeline]".bold.blue, "[DIAGNOSTICS]".red, " Checking root".bold, "\n"
      as :root do
        within "/etc/sudoers.d" do
          info test("[ -e deploy_permissions ]")
        end
      end
    end
  end

  desc "Timestamp deploy steps"
  task :timestamp do
    current_time = Time.now.strftime(" Current time is %Y-%m-%d %T")
    print "\n[Devellocus Pipeline]".bold.blue, "[DIAGNOSTICS]".red, current_time.bold, "\n"
  end

end
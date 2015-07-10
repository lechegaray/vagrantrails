namespace :test do
  Rake::TestTask.new("ci_test") do |t|
    t.libs << "test"
    t.test_files = Dir.glob("test/**/*_test.rb")
    t.verbose = true
    t.warning = false
  end
  desc "Run tests on CI server, sans development"
  task :ci do
    puts "Running db:test:prepare"
    Rake::Task["db:test:prepare"].clear_prerequisites
    puts "Running db:test:load"
    Rake::Task["db:test:load"].invoke
  end
end

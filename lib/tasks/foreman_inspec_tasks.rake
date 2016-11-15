require 'rake/testtask'

# Tasks
namespace :foreman_inspec do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanInspec'
  Rake::TestTask.new(:foreman_inspec) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_inspec do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_inspec) do |task|
        task.patterns = ["#{ForemanInspec::Engine.root}/app/**/*.rb",
                         "#{ForemanInspec::Engine.root}/lib/**/*.rb",
                         "#{ForemanInspec::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_inspec'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_inspec']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_inspec', 'foreman_inspec:rubocop']
end

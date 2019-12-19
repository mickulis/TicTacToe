require 'rake/testtask'
require 'rspec/core/rake_task'

task :default => %w[test spec]

desc "Minitest tests."
Rake::TestTask.new do |task|
	task.pattern = 'test/*_test.rb'
end

desc "Rspec tests."
RSpec::Core::RakeTask.new(:spec) do |t|
	t.pattern = "spec/*_spec.rb"
end
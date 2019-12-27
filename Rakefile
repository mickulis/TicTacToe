require 'rake/testtask'
require 'rspec/core/rake_task'

task :default => %w[spec test]

desc "Rspec tests."
RSpec::Core::RakeTask.new(:spec) do |t|
	t.pattern = "spec/*_spec.rb"
end

desc "Minitest tests."
Rake::TestTask.new do |task|
	task.pattern = 'test/*_test.rb'
end


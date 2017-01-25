require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :fmt do
  # This is a little hacky, but basically we're overriding hte exit status
  # by exiting with code 0 if it exits with anything else but 0. The point
  # of this is because I don't want Rake to throw an error if it finds
  # something.
  sh 'rubocop -a' do |ok, _output|
    exit(0) unless ok
  end
end

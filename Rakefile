# load basic gem tasks
require "bundler/gem_tasks"

# undef task :release
Rake::Task[:release].clear

# load task :test
require 'rake/testtask'
Rake::TestTask.new

# define task :default
task :default => [:clobber, :build, :clean]


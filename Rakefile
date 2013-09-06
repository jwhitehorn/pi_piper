require 'rubygems'
require 'rake'
require 'echoe'
require 'rake/testtask'

#rake manifest
#rake release

Echoe.new('pi_piper', '2.0.beta.1') do |p|
  p.description     = "Event driven Raspberry Pi GPIO library"
  p.url             = "http://github.com/jwhitehorn/pi_piper"
  p.author          = "Jason Whitehorn"
  p.email           = "jason.whitehorn@gmail.com"
  p.ignore_pattern  = ["examples/**/*", "spec/**/*"]
  p.dependencies    = ['ffi']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

Rake::TestTask.new do |t|
    t.pattern = 'spec/**/*_spec.rb'
end

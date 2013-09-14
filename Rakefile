require 'rubygems'
require 'rake'
require 'echoe'
require 'rake/testtask'

#rake manifest
#rake build_gemspec
#gem build pi_piper.gemspec
#gem push xxx.gem

Echoe.new('pi_piper', '2.0.beta.4') do |p|
  p.description     = "Event driven Raspberry Pi GPIO library"
  p.url             = "http://github.com/jwhitehorn/pi_piper"
  p.author          = "Jason Whitehorn"
  p.email           = "jason.whitehorn@gmail.com"
  p.ignore_pattern  = ["examples/**/*", "spec/**/*"]
  p.dependencies    = ['ffi', 'eventmachine 1.0.3']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

Rake::TestTask.new do |t|
    t.pattern = 'spec/**/*_spec.rb'
end

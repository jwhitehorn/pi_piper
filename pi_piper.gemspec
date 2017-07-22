# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pi_piper/version'

Gem::Specification.new do |s|
  s.name = 'pi_piper'
  s.version = PiPiper::VERSION

  s.required_rubygems_version = Gem::Requirement.new('>= 2.0.0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Jason Whitehorn']
  s.description = 'Event driven Raspberry Pi GPIO library'
  s.email = 'jason.whitehorn@gmail.com'
  s.extra_rdoc_files = ['README.md', 'lib/pi_piper/libbcm2835.so']
  s.files         = `git ls-files -z`.split("\x0")
  s.homepage = 'http://github.com/jwhitehorn/pi_piper'
  s.rdoc_options = ['--line-numbers', '--inline-source', '--title', 'Pi_piper', '--main', 'README.md']
  s.require_paths = ['lib']
  s.rubygems_version = '2.2.2'
  s.summary = 'Event driven Raspberry Pi GPIO library'
  s.licenses = ['BSD']

  s.specification_version = 4 if s.respond_to? :specification_version

  s.add_runtime_dependency 'ffi', '>= 0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'simplecov'
end

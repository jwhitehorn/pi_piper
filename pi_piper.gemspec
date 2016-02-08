# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pi_piper/version'

Gem::Specification.new do |s|
  s.name = "pi_piper"
  s.version = PiPiper::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Whitehorn"]
  s.date = "2013-09-14"
  s.description = "Event driven Raspberry Pi GPIO library"
  s.email = "jason.whitehorn@gmail.com"
  s.extra_rdoc_files = ["README.md", "lib/pi_piper.rb", "lib/pi_piper/bcm2835.rb", "lib/pi_piper/frequency.rb", "lib/pi_piper/i2c.rb", "lib/pi_piper/libbcm2835.so", "lib/pi_piper/pin.rb", "lib/pi_piper/platform.rb", "lib/pi_piper/spi.rb"]
  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = "http://github.com/jwhitehorn/pi_piper"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Pi_piper", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "pi_piper"
  s.rubygems_version = "2.0.0"
  s.summary = "Event driven Raspberry Pi GPIO library"

  if s.respond_to? :specification_version
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency(%q<ffi>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, ["= 1.0.9"])
    else
      s.add_dependency(%q<ffi>, [">= 0"])
      s.add_dependency(%q<eventmachine>, ["= 1.0.9"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0"])
    s.add_dependency(%q<eventmachine>, ["= 1.0.9"])
  end

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'simplecov'
end

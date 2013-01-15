# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pi_piper}
  s.version = "1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Whitehorn"]
  s.date = %q{2013-01-15}
  s.description = %q{Event driven Raspberry Pi GPIO library}
  s.email = %q{jason.whitehorn@gmail.com}
  s.extra_rdoc_files = ["README.md", "lib/pi_piper.rb", "lib/pi_piper/pin.rb"]
  s.files = ["Manifest", "README.md", "Rakefile", "lib/pi_piper.rb", "lib/pi_piper/pin.rb", "pi_piper.gemspec"]
  s.homepage = %q{http://github.com/jwhitehorn/pi_piper}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Pi_piper", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pi_piper}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Event driven Raspberry Pi GPIO library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<ffi>, [">= 0"])
    else
      s.add_dependency(%q<ffi>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0"])
  end
end

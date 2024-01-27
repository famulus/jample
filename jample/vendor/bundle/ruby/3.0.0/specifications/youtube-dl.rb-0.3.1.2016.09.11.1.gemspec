# -*- encoding: utf-8 -*-
# stub: youtube-dl.rb 0.3.1.2016.09.11.1 ruby lib

Gem::Specification.new do |s|
  s.name = "youtube-dl.rb".freeze
  s.version = "0.3.1.2016.09.11.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["sapslaj".freeze, "xNightMare".freeze]
  s.date = "2016-09-12"
  s.description = "in the spirit of pygments.rb and MiniMagick, youtube-dl.rb is a command line wrapper for the python script youtube-dl".freeze
  s.email = ["saps.laj@gmail.com".freeze]
  s.homepage = "https://github.com/layer8x/youtube-dl.rb".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "youtube-dl wrapper for Ruby".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<cocaine>.freeze, [">= 0.5.4"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 1.6"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.8.1"])
    s.add_development_dependency(%q<purdytest>.freeze, [">= 0"])
    s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
  else
    s.add_dependency(%q<cocaine>.freeze, [">= 0.5.4"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.8.1"])
    s.add_dependency(%q<purdytest>.freeze, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
  end
end

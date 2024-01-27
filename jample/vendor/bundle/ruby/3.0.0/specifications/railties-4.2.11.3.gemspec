# -*- encoding: utf-8 -*-
# stub: railties 4.2.11.3 ruby lib

Gem::Specification.new do |s|
  s.name = "railties".freeze
  s.version = "4.2.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2020-05-15"
  s.description = "Rails internals: application bootup, plugins, generators, and rake tasks.".freeze
  s.email = "david@loudthinking.com".freeze
  s.executables = ["rails".freeze]
  s.files = ["bin/rails".freeze]
  s.homepage = "http://www.rubyonrails.org".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--exclude".freeze, ".".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Tools for creating, working with, and running Rails applications.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, ["= 4.2.11.3"])
    s.add_runtime_dependency(%q<actionpack>.freeze, ["= 4.2.11.3"])
    s.add_runtime_dependency(%q<rake>.freeze, [">= 0.8.7"])
    s.add_runtime_dependency(%q<thor>.freeze, [">= 0.18.1", "< 2.0"])
    s.add_development_dependency(%q<actionview>.freeze, ["= 4.2.11.3"])
  else
    s.add_dependency(%q<activesupport>.freeze, ["= 4.2.11.3"])
    s.add_dependency(%q<actionpack>.freeze, ["= 4.2.11.3"])
    s.add_dependency(%q<rake>.freeze, [">= 0.8.7"])
    s.add_dependency(%q<thor>.freeze, [">= 0.18.1", "< 2.0"])
    s.add_dependency(%q<actionview>.freeze, ["= 4.2.11.3"])
  end
end

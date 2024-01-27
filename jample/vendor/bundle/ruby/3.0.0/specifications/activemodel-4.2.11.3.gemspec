# -*- encoding: utf-8 -*-
# stub: activemodel 4.2.11.3 ruby lib

Gem::Specification.new do |s|
  s.name = "activemodel".freeze
  s.version = "4.2.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2020-05-15"
  s.description = "A toolkit for building modeling frameworks like Active Record. Rich support for attributes, callbacks, validations, serialization, internationalization, and testing.".freeze
  s.email = "david@loudthinking.com".freeze
  s.homepage = "http://www.rubyonrails.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "A toolkit for building modeling frameworks (part of Rails).".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, ["= 4.2.11.3"])
    s.add_runtime_dependency(%q<builder>.freeze, ["~> 3.1"])
  else
    s.add_dependency(%q<activesupport>.freeze, ["= 4.2.11.3"])
    s.add_dependency(%q<builder>.freeze, ["~> 3.1"])
  end
end

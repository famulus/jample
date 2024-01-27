# -*- encoding: utf-8 -*-
# stub: moped 2.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "moped".freeze
  s.version = "2.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Durran Jordan".freeze, "Bernerd Schaefer".freeze]
  s.date = "2015-08-15"
  s.description = "A MongoDB driver for Ruby.".freeze
  s.email = ["durran@gmail.com".freeze]
  s.homepage = "http://mongoid.org/en/moped".freeze
  s.rubygems_version = "3.2.3".freeze
  s.summary = "A MongoDB driver for Ruby.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<bson>.freeze, ["~> 3.0"])
    s.add_runtime_dependency(%q<connection_pool>.freeze, ["~> 2.0"])
    s.add_runtime_dependency(%q<optionable>.freeze, ["~> 0.2.0"])
  else
    s.add_dependency(%q<bson>.freeze, ["~> 3.0"])
    s.add_dependency(%q<connection_pool>.freeze, ["~> 2.0"])
    s.add_dependency(%q<optionable>.freeze, ["~> 0.2.0"])
  end
end

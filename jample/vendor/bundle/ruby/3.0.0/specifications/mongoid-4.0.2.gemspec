# -*- encoding: utf-8 -*-
# stub: mongoid 4.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid".freeze
  s.version = "4.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Durran Jordan".freeze]
  s.date = "2015-02-19"
  s.description = "Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby.".freeze
  s.email = ["durran@gmail.com".freeze]
  s.homepage = "http://mongoid.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Elegant Persistance in Ruby for MongoDB.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activemodel>.freeze, ["~> 4.0"])
    s.add_runtime_dependency(%q<tzinfo>.freeze, [">= 0.3.37"])
    s.add_runtime_dependency(%q<moped>.freeze, ["~> 2.0.0"])
    s.add_runtime_dependency(%q<origin>.freeze, ["~> 2.1"])
  else
    s.add_dependency(%q<activemodel>.freeze, ["~> 4.0"])
    s.add_dependency(%q<tzinfo>.freeze, [">= 0.3.37"])
    s.add_dependency(%q<moped>.freeze, ["~> 2.0.0"])
    s.add_dependency(%q<origin>.freeze, ["~> 2.1"])
  end
end

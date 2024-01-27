# -*- encoding: utf-8 -*-
# stub: mp3info 0.8.5 ruby lib

Gem::Specification.new do |s|
  s.name = "mp3info".freeze
  s.version = "0.8.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Guillaume Pierronnet".freeze, "Ivan Kuchin".freeze]
  s.date = "2014-11-22"
  s.homepage = "http://github.com/toy/mp3info".freeze
  s.licenses = ["ruby".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Read low-level informations and manipulate tags on mp3 files.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ruby-mp3info>.freeze, [">= 0.8.5"])
  else
    s.add_dependency(%q<ruby-mp3info>.freeze, [">= 0.8.5"])
  end
end

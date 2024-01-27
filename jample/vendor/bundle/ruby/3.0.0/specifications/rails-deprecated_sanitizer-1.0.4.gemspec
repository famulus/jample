# -*- encoding: utf-8 -*-
# stub: rails-deprecated_sanitizer 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "rails-deprecated_sanitizer".freeze
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kasper Timm Hansen".freeze]
  s.date = "2021-02-15"
  s.email = ["kaspth@gmail.com".freeze]
  s.homepage = "https://github.com/rails/rails-deprecated_sanitizer".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Deprecated sanitizer API extracted from Action View.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 4.2.0.alpha"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 4.2.0.alpha"])
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end

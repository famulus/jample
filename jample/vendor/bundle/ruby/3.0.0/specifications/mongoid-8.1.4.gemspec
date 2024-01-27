# -*- encoding: utf-8 -*-
# stub: mongoid 8.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid".freeze
  s.version = "8.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://jira.mongodb.org/projects/MONGOID", "changelog_uri" => "https://github.com/mongodb/mongoid/releases", "documentation_uri" => "https://www.mongodb.com/docs/mongoid/", "homepage_uri" => "https://mongoid.org/", "source_code_uri" => "https://github.com/mongodb/mongoid" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["The MongoDB Ruby Team".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIEeDCCAuCgAwIBAgIBATANBgkqhkiG9w0BAQsFADBBMREwDwYDVQQDDAhkYngt\ncnVieTEXMBUGCgmSJomT8ixkARkWB21vbmdvZGIxEzARBgoJkiaJk/IsZAEZFgNj\nb20wHhcNMjMwMTMxMTE1NjM1WhcNMjQwMTMxMTE1NjM1WjBBMREwDwYDVQQDDAhk\nYngtcnVieTEXMBUGCgmSJomT8ixkARkWB21vbmdvZGIxEzARBgoJkiaJk/IsZAEZ\nFgNjb20wggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQC0/Veq9l47cTfX\ntQ+kHq2NOCwJuJGt1iXWQ/vH/yp7pZ/bLej7gPDl2CfIngAXRjM7r1FkR9ya7VAm\nIneBFcVU3HhpIXWi4ByXGjBOXFD1Dfbz4C4zedIWRk/hNzXa+rQY4KPwpOwG/hZg\nid+rSXWSbNlkyN97XfonweVh7JsIa9X/2JY9ADYjhCfEZF+b0+Wl7+jgwzLWb46I\n0WH0bZBIZ0BbKAwUXIgvq5mQf9PzukmMVYCwnkJ/P4wrHO22HuwnbMyvJuGjVwqi\nj1NRp/2vjmKBFWxIfhlSXEIiqAmeEVNXzhPvTVeyo+rma+7R3Bo+4WHkcnPpXJJZ\nJd63qXMvTB0GplEcMJPztWhrJOmcxIOVoQyigEPSQT8JpzFVXby4SGioizv2eT7l\nVYSiCHuc3yEDyq5M+98WGX2etbj6esYtzI3rDevpIAHPB6HQmtoJIA4dSl3gjFb+\nD+YQSuB2qYu021FI9zeY9sbZyWysEXBxhwrmTk+XUV0qz+OQZkMCAwEAAaN7MHkw\nCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFH4nnr4tYlatU57RbExW\njG86YM5nMB8GA1UdEQQYMBaBFGRieC1ydWJ5QG1vbmdvZGIuY29tMB8GA1UdEgQY\nMBaBFGRieC1ydWJ5QG1vbmdvZGIuY29tMA0GCSqGSIb3DQEBCwUAA4IBgQAVSlgM\nnFDWCCNLOCqG5/Lj4U62XoALkdCI+OZ30+WrA8qiRLSL9ZEziVK9AV7ylez+sriQ\nm8XKZKsCN5ON4+zXw1S+6Ftz/R4zDg7nTb9Wgw8ibzsoiP6e4pRW3Fls3ZdaG4pW\n+qMTbae9OiSrgI2bxNTII+v+1FcbQjOlMu8HPZ3ZfXnurXPgN5GxSyyclZI1QONO\nHbUoKHRirZu0F7JCvQQq4EkSuLWPplRJfYEeJIYm05zhhFeEyqea2B/TTlCtXa42\n84vxXsxGzumuO8F2Q9m6/p95sNhqCp0B/SkKXIrRGJ7FBzupoORNRXHviS2OC3ty\n4lwUzOlLTF/yO0wwYYfmtQOALQwKnW838vbYthMXvTjxB0EgVZ5PKto99WbjsXzy\nwkeAWhd5b+5JS0zgDL4SvGB8/W2IY+y0zELkojBMgJPyrpAWHL/WSsSBMuhyI2Pv\nxxaBVLklnJJ/qCCOZ3lG2MyVc/Nb0Mmq8ygWNsfwHmKKYuuWcviit0D0Tek=\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2023-11-22"
  s.description = "Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby.".freeze
  s.email = "dbx-ruby@mongodb.com".freeze
  s.homepage = "https://mongoid.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Elegant Persistence in Ruby for MongoDB.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 5.1", "< 7.2", "!= 7.0.0"])
    s.add_runtime_dependency(%q<mongo>.freeze, [">= 2.18.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 1.0.5", "< 2.0"])
    s.add_runtime_dependency(%q<ruby2_keywords>.freeze, ["~> 0.0.5"])
    s.add_development_dependency(%q<bson>.freeze, [">= 4.14.0", "< 5.0.0"])
  else
    s.add_dependency(%q<activemodel>.freeze, [">= 5.1", "< 7.2", "!= 7.0.0"])
    s.add_dependency(%q<mongo>.freeze, [">= 2.18.0", "< 3.0.0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 1.0.5", "< 2.0"])
    s.add_dependency(%q<ruby2_keywords>.freeze, ["~> 0.0.5"])
    s.add_dependency(%q<bson>.freeze, [">= 4.14.0", "< 5.0.0"])
  end
end

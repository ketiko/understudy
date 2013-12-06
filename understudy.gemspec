# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'understudy/version'

Gem::Specification.new do |spec|
  spec.name             = "understudy"
  spec.version          = Understudy::VERSION
  spec.authors          = ["Ryan Hansen"]
  spec.email            = ["ketiko@gmail.com"]
  spec.description      = %q{Automated system backups via rdiff-backup}
  spec.summary          = %q{Automated system backups via rdiff-backup}
  spec.homepage         = "http://github.com/ketiko/understudy"
  spec.license          = "MIT"

  spec.files            = `git ls-files`.split($/)
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  spec.extra_rdoc_files = [ "LICENSE.txt", "README.md" ]
  spec.rdoc_options     = [ "--charset=UTF-8" ]

  spec.add_dependency "activesupport"
  spec.add_dependency "thor"
  spec.add_dependency "safe_yaml"
  spec.add_dependency "rdiff-simple"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.0.0"
  spec.add_development_dependency "coveralls"
end

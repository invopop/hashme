# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hashme/version'

Gem::Specification.new do |spec|
  spec.name          = "hashme"
  spec.version       = Hashme::VERSION
  spec.authors       = ["Sam Lown"]
  spec.email         = ["me@samlown.com"]
  spec.description   = %q{Modeling with Hashes made easy.}
  spec.summary       = %q{Easily define simple models that can be easily serialized and de-serialized.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

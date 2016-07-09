# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evostream/version'

Gem::Specification.new do |spec|
  spec.name          = "evostream"
  spec.version       = Evostream::VERSION
  spec.authors       = ["Lucas Mundim"]
  spec.email         = ["lucas.mundim@corp.globo.com"]
  spec.description   = %q{Ruby wrapper for the Evostream API}
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/globocom/evostream"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "webmock", "~> 1.13"
  if RUBY_VERSION >= '2.0'
    spec.add_development_dependency "byebug", "~> 9.0"
  else
    spec.add_development_dependency "debugger", "~> 1.6"
  end
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/amf_socket/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chad Remesch"]
  gem.email         = ["chad@remesch.com"]
  gem.description   = %q{Ruby implementation of AMF Socket (https://github.com/chadrem/amf_socket)}
  gem.summary       = %q{AMF Socket is a bi-directional RPC system for Adobe Flash (Actionscript) programs.}
  gem.homepage      = "https://github.com/chadrem/observation"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "amf_socket"
  gem.require_paths = ["lib"]
  gem.version       = AmfSocket::VERSION

  gem.add_dependency('eventmachine', ['~> 1.0.0'])
  gem.add_dependency('RocketAMF', ['~> 0.2.1'])

  gem.add_development_dependency('rake', ['= 0.9.2.2'])
  gem.add_development_dependency('rspec', ['= 2.11.0'])
  gem.add_development_dependency('guard', ['= 1.3.2'])
  gem.add_development_dependency('guard-rspec', ['= 1.2.1'])
  gem.add_development_dependency('growl', ['= 1.0.3'])
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/amf_socket/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chad Remesch"]
  gem.email         = ["chad@remesch.com"]
  gem.description   = %q{Ruby implementation of AMF Socket (https://github.com/chadrem/amf_socket)}
  gem.summary       = %q{AMF Socket is a bi-directional RPC system for Adobe Flash (Actionscript) programs.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "amf_socket"
  gem.require_paths = ["lib"]
  gem.version       = AmfSocket::VERSION

  gem.add_dependency('eventmachine', ['>= 0.12.10'])
  gem.add_dependency('RocketAMF', ['>= 0.2.1'])
end

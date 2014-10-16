# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'navigation/version'

Gem::Specification.new do |gem|
  gem.name          = "navigation"
  gem.version       = Navigation::VERSION
  gem.authors       = ["Ryan Heath"]
  gem.email         = ["ryan@rpheath.com"]
  gem.description   = %q{Navigation helpers for building menus in Rails}
  gem.summary       = %q{Navigation helpers for building menus in Rails}
  gem.homepage      = "http://github.com/rpheath/navigation"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.require_paths = ["lib"]
end
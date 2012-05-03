# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omnifocus/pivotaltracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vesa Vänskä"]
  gem.email         = ["vesa@vesavanska.com"]
  gem.description   = %q{Plugin for omnifocus gem to provide Pivotal Tracker BTS synchronization.}
  gem.summary       = %q{Plugin for omnifocus gem to provide Pivotal Tracker BTS synchronization.}
  gem.homepage      = "https://github.com/vesan/omnifocus-pivotaltracker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omnifocus-pivotaltracker"
  gem.require_paths = ["lib"]
  gem.version       = OmniFocus::Pivotaltracker::VERSION

  gem.add_dependency "omnifocus", "~> 2.0.0"
  gem.add_dependency "nokogiri", "~> 1.5.2"
end

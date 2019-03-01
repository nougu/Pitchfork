# coding: utf-8

REQUIRE_PATHS = ["lib"]
REQUIRE_PATHS.each{|path|
  path = File.join(File.dirname(__FILE__), path)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
}
require 'spec'

Gem::Specification.new do |spec|
  spec.name          = Spec::NAME
  spec.version       = Spec::VERSION
  spec.author        = "PRO36 Developers"
  spec.email         = "fj-Pro-36-2014@dl.jp.fujitsu.com"
  spec.homepage      = "http://baler.soft.fujitsu.com/pro36/pitchfork"
  spec.summary       = %q{A lightweight interface for manipulating storage stack.}
  spec.description   = %q{A lightweight interface for manipulating storage stack composed as a block, file or object storage with various external packages.}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = REQUIRE_PATHS

  spec.add_development_dependency "bundler",         "~> 1.13"
  spec.add_development_dependency "rake",            "~> 11.3"
  spec.add_development_dependency "test-unit",       "~> 3.2"
  spec.add_development_dependency "sinatra-contrib", "~> 1.4"
  spec.add_development_dependency "ruby-debug-ide",  "~> 0.6"
  spec.add_development_dependency "debase",          "~> 0.2"
  spec.add_development_dependency "pry",             "~> 0.10"

  spec.add_runtime_dependency "thor",    "~> 0.19"
  spec.add_runtime_dependency "systemu", "~> 2.6"
  spec.add_runtime_dependency "sinatra", "~> 1.4"
end

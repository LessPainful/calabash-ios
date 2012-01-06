# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "calabash-cucumber/version"

Gem::Specification.new do |s|
  s.name        = "calabash-cucumber"
  s.version     = Calabash::Cucumber::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karl Krukow"]
  s.email       = ["karl@lesspainful.com"]
  s.homepage    = "http://www.lesspainful.com/calabash"
  s.summary     = %q{Client for calabash-ios-server for automated functional testing on iOS}
  s.description = %q{calabash-cucumber drives tests for native iOS apps. You must link your app with calabash-ios-server framework to execute tests.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency( "cucumber" )
  s.add_dependency( "rspec", [">=2.0"] )
  s.add_dependency( "json" )
  s.add_dependency( "net-http-persistent" )
end

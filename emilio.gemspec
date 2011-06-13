# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "emilio/version"

Gem::Specification.new do |s|
  s.name        = "emilio"
  s.version     = Emilio::VERSION
  s.authors     = ["Roger Campos"]
  s.email       = ["roger@itnig.net"]
  s.homepage    = ""
  s.summary     = %q{Parse incoming emails with IMAP}
  s.description = %q{Parse incoming emails with IMAP}

  s.rubyforge_project = "emilio"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '~> 3.0.0'
end

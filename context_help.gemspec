# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "context_help/version"

Gem::Specification.new do |s|
  s.name        = "context_help"
  s.version     = ContextHelp::VERSION
  s.authors     = ["Juan Pablo Marzetti"]
  s.email       = ["jmarzetti@sequre.com.ar"]
  s.homepage    = "http://sequre.com.ar"
  s.summary     = %q{A Rails context help facility to offer help about yor models and attributes}
  s.description = %q{ContextHelp is a gem that allows you to show inline or aside help about every input item found in a form tag, a model, its attributes and even custom help about other HTML tags}

  s.rubyforge_project = "context_help"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

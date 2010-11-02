# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "crontest"
  s.version = '0.1.0'
  s.default_executable = %q{crontest}
  s.executables = ["crontest"]
  
  s.authors = ["Ari Russo"]
  s.description = "ruby command line tool/library for testing cron jobs"
  s.summary = "Execute an (almost) immediate and transient cron job"
  s.email = ["ari.russo@gmail.com"]
  s.files = %w(bin/crontest lib/crontest.rb LICENSE README.org)
  s.homepage = %q{http://github.com/arirusso/crontest}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.specification_version = 3
  
  s.add_dependency("clap")
  s.add_development_dependency("clap")
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "crontest"
  s.version = '0.0.5'

  s.authors = ["Ari Russo"]
  s.description = "ruby library/command line tool for testing cron jobs"
  s.summary = "Execute an (almost) immediate and transient cron job"
  s.email = ["ari.russo@gmail.com"]
  s.files = Dir.glob("{lib}/**/*") + %w(crontest.rb crontest LICENSE README.org)
  s.homepage = %q{http://github.com/arirusso/crontest}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.specification_version = 3

  s.add_development_dependency("clap")
end

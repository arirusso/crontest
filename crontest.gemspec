# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "crontest"
  s.version = '0.0.1'

  s.authors = ["Ari Russo"]
  s.description = "command line tool for testing cron tasks"
  s.summary = "Run this to execute a command in your current user's cron environment."
  s.email = ["ari.russo@gmail.com"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = Dir.glob("{lib}/**/*") + %w(README.rdoc)
  s.homepage = %q{http://github.com/arirusso/crontest}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.specification_version = 3

  s.add_development_dependency("clap")
end

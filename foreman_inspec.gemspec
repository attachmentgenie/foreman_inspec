require File.expand_path('../lib/foreman_inspec/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_inspec'
  s.version     = ForemanInspec::VERSION
  s.date        = Time.now
  s.authors     = ['Bram Vogelaar']
  s.email       = ['bram@inuits.eu']
  s.homepage    = 'http://github.com/attachmentgenie/foreman_inspec'
  s.summary     = 'Summary of Foreman Inspec.'
  # also update locale/gemspec.rb
  s.description = 'Description of Foreman Inspec.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end

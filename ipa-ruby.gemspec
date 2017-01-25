lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ipa/version'
require 'date'

Gem::Specification.new do |s|
  s.name = 'ipa-ruby'
  s.authors = ['Matteo Cerutti']
  s.date = Date.today.to_s
  s.description = 'Ruby client library for FreeIPA JSON API'
  s.email = '<matteo.cerutti@hotmail.co.uk>'
  s.files = Dir.glob('{lib}/**/*') + %w(LICENSE README.md)
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/m4ce/ipa-ruby'
  s.license = 'Apache 2.0'
  s.summary = 'Ruby client library that allows to interact with the FreeIPA JSON API'
  s.version = IPA.version

  s.add_runtime_dependency 'json', '>= 1.7.0'
  s.add_runtime_dependency 'gssapi', '>= 1.1.2'
  s.add_runtime_dependency 'httpclient', '>= 2.4.0'
end

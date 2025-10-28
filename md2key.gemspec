# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'md2key/version'

Gem::Specification.new do |spec|
  spec.name          = 'md2key'
  spec.version       = Md2key::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']

  spec.summary       = 'Convert markdown to keynote'
  spec.description   = 'Convert markdown to keynote'
  spec.homepage      = 'https://github.com/k0kubun/md2key'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"

  # macOS system ruby is 2.6.10 as of darwin25
  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'thor', '>= 0.19'
  spec.add_dependency 'redcarpet', '>= 3.3'
  spec.add_dependency 'oga', '>= 1.2'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end

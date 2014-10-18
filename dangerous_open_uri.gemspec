# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dangerous_open_uri/version'

Gem::Specification.new do |spec|
  spec.name          = "dangerous_open_uri"
  spec.version       = DangerousOpenUri::VERSION
  spec.authors       = ["mgi166"]
  spec.email         = ["skskoari@gmail.com"]
  spec.summary       = %q{Force open dangerous uri.}
  spec.description   = %q{Conclusion, Be using this gem is STRONGLY **deprecated**. Because RFC3986 says userinfo in URI is dangerous. But if you want to open-uri such dangerous uri absolutely, it is preferable to use this gem.}
  spec.homepage      = "https://github.com/mgi166/dangerous_open_uri"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "coveralls"
end

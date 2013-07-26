# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex_cleanweb/version'

Gem::Specification.new do |gem|
  gem.name          = "yandex_cleanweb"
  gem.version       = YandexCleanweb::VERSION
  gem.authors       = ["Kir Shatrov"]
  gem.email         = ["shatrov@me.com"]
  gem.description   = %q{Ruby wrapper for Yandex.Cleanweb}
  gem.summary       = %q{Ruby wrapper for Yandex.Cleanweb spam detector}
  gem.homepage      = "https://github.com/evrone/yandex-cleanweb"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'nokogiri'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest", "~> 3.0"
  gem.add_development_dependency "minitest-spec-context"
  gem.add_development_dependency "fakeweb"
end

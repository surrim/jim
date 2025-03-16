# frozen_string_literal: true

require_relative 'lib/jim/version'

Gem::Specification.new do |spec|
  spec.name          = 'jim'
  spec.version       = Jim::VERSION
  spec.author        = 'surrim'
  spec.email         = 'root@surrim.org'
  spec.summary       = 'Image batch transformations and template-based output for Jekyll and Bridgetown'
  spec.description   = 'Superior image processing and responsive HTML5 outputs for' \
                       'Jekyll and Bridgetown, 100% flexible.' \
                       'Using a very efficient and persistent cache, user-defined' \
                       'filenames, templates, watermarks, additional CSS/HTML' \
                       'attributes, SVG forwarding/inlining, raw data and more.'
  spec.homepage      = 'https://surrim.org/'
  spec.license       = 'GPLv3'

  spec.files         = `/usr/bin/git ls-files -z`.split("\x0").select do |f|
    f.match(/^(components|lib|LICENSE|README|)/)
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 3.3'
  spec.add_runtime_dependency 'blake3-rb', '~> 1.5'
  spec.add_runtime_dependency 'mime-types', '~> 3.4'
  spec.add_runtime_dependency 'rmagick', '~> 5.2'
  spec.add_runtime_dependency 'zlib', '~> 3.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.66'
end

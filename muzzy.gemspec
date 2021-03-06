# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "muzzy/version"

Gem::Specification.new do |spec|
  spec.name          = "muzzy"
  spec.version       = Muzzy::VERSION
  spec.authors       = ["vimtaku"]
  spec.email         = ["vimtaku@gmail.com"]

  spec.summary       = %q{Super fuzzy mysql tsv importer}
  spec.description   = %q{muzzy is tsv importer mysql client}
  spec.homepage      = "https://github.com/vimtaku/muzzy"
  spec.license       = "MIT"
  spec.post_install_message = "Thanks for download muzzy! please run muzzy_setup command first."

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "vendor"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
end

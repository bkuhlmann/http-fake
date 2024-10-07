# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "http-fake"
  spec.version = "3.8.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/http-fake"
  spec.summary = "A HTTP fake implementation for test suites."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/http-fake/issues",
    "changelog_uri" => "https://alchemists.io/projects/http-fake/versions",
    "homepage_uri" => "https://alchemists.io/projects/http-fake",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "HTTP Fake",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/http-fake"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 3.3", "<= 3.4"
  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "mustermann", "~> 3.0"
  spec.add_dependency "refinements", "~> 12.9"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end

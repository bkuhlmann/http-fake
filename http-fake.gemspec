# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "http-fake"
  spec.version = "0.2.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/http-fake"
  spec.summary = "Provides a fake but equivalent implementation of the HTTP gem for test suites."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/http-fake/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/http-fake/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/http-fake",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "HTTP Fake",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/http-fake"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "http", "~> 5.0"
  spec.add_dependency "mustermann", "~> 3.0"
  spec.add_dependency "refinements", "~> 9.6"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end

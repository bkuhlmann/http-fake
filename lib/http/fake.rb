# frozen_string_literal: true

require "http"
require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "http" => "HTTP"
  loader.tag = "http-fake"
  loader.push_dir "#{__dir__}/.."
  loader.setup
end

module HTTP
  # Main namespace.
  module Fake
    def self.loader(registry = Zeitwerk::Registry) = registry.loader_for __FILE__
  end
end

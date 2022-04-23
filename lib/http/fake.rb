# frozen_string_literal: true

require "zeitwerk"
require "http"

Zeitwerk::Loader.new.then do |loader|
  loader.push_dir "#{__dir__}/.."
  loader.inflector.inflect "http" => "HTTP"
  loader.setup
end

module HTTP
  # Main namespace.
  module Fake
  end
end

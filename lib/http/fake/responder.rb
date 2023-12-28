# frozen_string_literal: true

require "mustermann"
require "refinements/string"

module HTTP
  module Fake
    # Handles an outgoing response.
    class Responder
      using Refinements::String

      attr_reader :headers

      def initialize verb, pattern, function
        @verb = verb
        @pattern = Mustermann.new pattern
        @function = function
        @headers = {}
      end

      def match?(verb, path) = !String(pattern.match(path)).blank? && verb == self.verb

      def call path, arguments = {}
        pattern.params(path)
               .then { |params| instance_exec(params, arguments, &function) }
               .then { |data| connect path, data }
      end

      def status(code = nil) = @status ||= code

      private

      attr_reader :verb, :pattern, :function

      def connect path, data
        Connector.new.call verb:,
                           uri: "https://example.com/#{path}",
                           headers:,
                           body: body(data),
                           status:
      end

      def body(data) = data == status ? "" : data
    end
  end
end

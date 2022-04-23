# frozen_string_literal: true

module HTTP
  module Fake
    # Handles an incoming request.
    class Requester
      include Chainable

      def initialize defaults = {}, builder: Builder.new
        @defaults = defaults
        @builder = builder
      end

      def request(verb, uri, arguments = {}) = builder.request verb, uri, defaults.merge(arguments)

      private

      attr_reader :defaults, :builder

      def branch(arguments) = self.class.new defaults.merge(arguments), builder:
    end
  end
end

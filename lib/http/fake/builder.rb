# frozen_string_literal: true

require "refinements/hash"
require "uri"

module HTTP
  module Fake
    # Builds the response for a request.
    class Builder
      using Refinements::Hash

      ALLOWED_VERBS = /\A(connect|delete|get|head|options|patch|post|put|trace)\z/

      attr_reader :requests

      # :reek:DuplicateMethodCall
      def initialize verbs: ALLOWED_VERBS, responder: Responder
        @verbs = verbs
        @responder = responder
        @requests ||= Hash.with_default Hash.with_default([])
        @responders = Hash.with_default []
      end

      def request verb, uri, arguments = {}
        responder = responders[verb].find { |fake| fake.match? verb, URI(uri).path }
        missing_route_error verb, uri unless responder
        requests[uri][verb] << arguments
        responder.call uri, arguments
      end

      def method_missing(verb, *arguments, &)
        respond_to_missing?(verb) ? add_responder(verb, *arguments, &) : super
      end

      private

      attr_reader :verbs, :responder, :responders

      def respond_to_missing?(verb, include_private = false) = verbs.match?(verb) || super

      def add_responder verb, pattern, &block
        responder.new(verb, pattern, block).then do |instance|
          responders[[verb, pattern]].append instance
        end
      end

      def missing_route_error verb, uri
        fail StandardError, "No route for #{verb.upcase} #{uri} in responders: #{responders}."
      end
    end
  end
end

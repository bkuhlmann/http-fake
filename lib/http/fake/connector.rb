# frozen_string_literal: true

module HTTP
  module Fake
    # Connects an HTTP request and response together.
    class Connector
      def initialize version: Connection::HTTP_1_1, request: Request, response: Response
        @version = version
        @request = request
        @response = response
      end

      def call **arguments
        response.new(
          **defaults,
          **arguments.slice(:headers, :version, :body, :status),
          request: build_request(arguments)
        )
      end

      private

      attr_reader :version, :request, :response

      def defaults = {headers: {}, version:, status: 200}

      def build_request(arguments) = request.new(**arguments.slice(:verb, :uri))
    end
  end
end

# frozen_string_literal: true

require "forwardable"

module HTTP
  module Fake
    # Provides the primary client for dealing with fake requests and responses.
    class Client
      include Chainable
      extend Forwardable

      delegate %i[requests] => :builder

      def initialize builder: Builder.new, requester: Requester, &block
        @builder = builder
        @requester = requester
        @builder.instance_eval(&block)
      end

      private

      attr_reader :builder, :requester

      def branch(arguments) = requester.new arguments, builder:
    end
  end
end

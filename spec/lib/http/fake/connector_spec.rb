# frozen_string_literal: true

require "spec_helper"

RSpec.describe HTTP::Fake::Connector do
  subject(:connector) { described_class.new }

  describe "#call" do
    let :custom_arguments do
      {
        verb: :post,
        uri: "https://example.com/test",
        headers: {accept: "text/plain"},
        version: "1.0",
        body: "OK",
        status: 201
      }
    end

    it "answers default response" do
      response = connector.call verb: :get, uri: "https://example.com/test", body: "OK"

      expect(response).to have_attributes(
        request: have_attributes(verb: :get, uri: HTTP::URI.parse("https://example.com/test")),
        headers: HTTP::Headers.new,
        version: "1.1",
        body: "OK",
        status: 200
      )
    end

    it "answers custom response" do
      response = connector.call(**custom_arguments)

      expect(response).to have_attributes(
        request: have_attributes(verb: :post, uri: HTTP::URI.parse("https://example.com/test")),
        headers: HTTP::Headers.new.tap { |headers| headers.set(:accept, "text/plain") },
        version: "1.0",
        body: "OK",
        status: 201
      )
    end
  end
end

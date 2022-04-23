# frozen_string_literal: true

require "spec_helper"

RSpec.describe HTTP::Fake::Requester do
  subject(:requester) { described_class.new builder: }

  let(:builder) { HTTP::Fake::Builder.new }

  describe "#request" do
    it "answers response with valid request" do
      builder.get("/products") { "test" }
      response = requester.request :get, "/products"

      expect(response.body).to eq("test")
    end

    it "fails without path defined" do
      expectation = proc { requester.request "get", "/products" }
      expect(&expectation).to raise_error(StandardError, /No route for GET/)
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe HTTP::Fake::Builder do
  subject(:builder) { described_class.new }

  shared_examples "a request" do |verb|
    it "answers array of matching responders without block" do
      responders = builder.public_send(verb, "/test").map(&:inspect)
      expect(responders).to contain_exactly(%r(pattern.+/test.+function=nil))
    end

    it "answers array of matching responders with block" do
      responders = builder.public_send(verb, "/test") { "test" }
                          .map(&:inspect)

      expect(responders).to contain_exactly(%r(pattern.+/test.+function.+builder_spec))
    end
  end

  describe "#connect" do
    it_behaves_like "a request", :connect
  end

  describe "#delete" do
    it_behaves_like "a request", :delete
  end

  describe "#get" do
    it_behaves_like "a request", :get
  end

  describe "#head" do
    it_behaves_like "a request", :head
  end

  describe "#options" do
    it_behaves_like "a request", :options
  end

  describe "#patch" do
    it_behaves_like "a request", :patch
  end

  describe "#post" do
    it_behaves_like "a request", :post
  end

  describe "#purge" do
    it_behaves_like "a request", :purge
  end

  describe "#put" do
    it_behaves_like "a request", :put
  end

  describe "#trace" do
    it_behaves_like "a request", :trace
  end

  describe "#method_missing" do
    it "fails invalid verb" do
      expectation = proc { builder.bogus("/products") { "test" } }
      expect(&expectation).to raise_error(NoMethodError, /undefined.+bogus/)
    end
  end

  describe "#request" do
    it "answers HTTP response when responders exist" do
      builder.get("/products") { "test" }
      expect(builder.request(:get, "/products")).to be_a(HTTP::Response)
    end

    it "fails without any responders" do
      expectation = proc { builder.request "get", "/products" }

      expect(&expectation).to raise_error(
        StandardError,
        %(No route for GET /products in responders: {"get" => []}.)
      )
    end
  end

  describe "requests" do
    it "answers empty hash with nothing registered" do
      expect(builder.requests).to eq({})
    end

    it "answers request with no options when registered" do
      builder.get("/products") { "test" }
      builder.request :get, "/products"

      expect(builder.requests).to eq("/products" => {get: [{}]})
    end

    it "answers request with options when registered" do
      builder.get("/products") { "test" }
      builder.request :get, "/products", format: :json

      expect(builder.requests).to eq("/products" => {get: [{format: :json}]})
    end
  end
end

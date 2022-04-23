# frozen_string_literal: true

require "spec_helper"

RSpec.describe HTTP::Fake::Client do
  subject :client do
    described_class.new do
      connect("/") { status 200 }

      head("/") { status 200 }
      options("/") { status 204 }

      get "/customers" do
        headers["Content-Type"] = "application/json"
        status 200

        <<~JSON
          {
            "customers": [
              {"name": "Jill Smith"}
            ]
          }
        JSON
      end

      post "/customers" do
        headers["Content-Type"] = "application/json"
        status 201
        {}
      end

      put "/customers/1" do
        headers["Content-Type"] = "application/json"
        status 200
      end

      patch "/customers/1" do
        headers["Content-Type"] = "application/json"
        status 200
      end

      delete("/customers/1") { status 204 }
      trace("/") { status 200 }
    end
  end

  describe "#requests" do
    it "answers unique verb (defined earlier), common path, and no arguments" do
      client.get "https://example.com/customers"

      expect(client.requests).to match(
        "https://example.com/customers" => {
          get: array_including(kind_of(HTTP::Options))
        }
      )
    end

    it "answers unique verb (defined later), common path, and no arguments" do
      client.post "https://example.com/customers"

      expect(client.requests).to match(
        "https://example.com/customers" => {
          post: array_including(kind_of(HTTP::Options))
        }
      )
    end

    it "answers unique verb with arguments" do
      client.get "https://example.com/customers?sort=asc"

      expect(client.requests).to match(
        "https://example.com/customers?sort=asc" => {
          get: array_including(kind_of(HTTP::Options))
        }
      )
    end
  end

  describe "#head" do
    it "answers empty body" do
      response = client.head "/"
      expect(response.body).to eq("")
    end

    it "answers OK status" do
      response = client.head "/"
      expect(response.status.code).to eq(200)
    end
  end

  describe "#get" do
    it "answers headers" do
      response = client.get "https://example.com/customers"
      expect(response.headers).to eq({"Content-Type" => "application/json"})
    end

    it "answers parsed response" do
      response = client.get "https://example.com/customers"
      expect(response.parse).to eq({"customers" => [{"name" => "Jill Smith"}]})
    end

    it "answers OK status" do
      response = client.get "https://example.com/customers"
      expect(response.status.code).to eq(200)
    end
  end

  describe "#post" do
    it "answers headers" do
      response = client.post "https://example.com/customers"
      expect(response.headers).to eq({"Content-Type" => "application/json"})
    end

    it "answers parsed response" do
      response = client.post "https://example.com/customers"
      expect(response.parse).to eq({})
    end

    it "answers created status" do
      response = client.post "https://example.com/customers"
      expect(response.status.code).to eq(201)
    end
  end
end

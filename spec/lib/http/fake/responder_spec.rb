# frozen_string_literal: true

require "spec_helper"

RSpec.describe HTTP::Fake::Responder do
  subject(:responder) { described_class.new :get, pattern, function }

  let(:pattern) { "/projects/1/actions" }
  let(:function) { proc { "" } }

  describe "#headers" do
    context "with single header" do
      let(:function) { proc { headers["Content-Type"] = "application/json" } }

      it "answers multiple headers" do
        responder.call :get, "/projects/1/actions"
        expect(responder.headers).to eq("Content-Type" => "application/json")
      end
    end

    context "with multiple headers" do
      let :function do
        proc do
          headers["Content-Type"] = "application/json"
          headers["Server"] = "Test"
        end
      end

      it "answers multiple headers" do
        responder.call :get, "/projects/1/actions"
        expect(responder.headers).to eq("Content-Type" => "application/json", "Server" => "Test")
      end
    end

    it "answers empty hash by default" do
      expect(responder.headers).to eq({})
    end
  end

  describe "#match?" do
    it "answers match for full path" do
      expect(responder.match?(:get, pattern)).to be(true)
    end

    it "answers nil for invalid verb" do
      expect(responder.match?(:post, pattern)).to be(false)
    end

    it "answers nil for full path without slash prefix" do
      expect(responder.match?(:get, "projects/1/actions")).to be(false)
    end

    it "answers nil for partial path" do
      expect(responder.match?(:get, "/projects/1")).to be(false)
    end
  end

  describe "#call" do
    context "with JSON" do
      let :function do
        proc do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            {
              "project_id": 1,
              "actions": []
            }
          JSON
        end
      end

      it "answers HTTP response with URI only" do
        response = responder.call :get, "/projects/1/actions"

        expect(response.to_a).to eq(
          [
            200,
            {"Content-Type" => "application/json"},
            "{\n  \"project_id\": 1,\n  \"actions\": []\n}\n"
          ]
        )
      end
    end

    context "with XML" do
      let :function do
        proc do
          headers["Content-Type"] = "application/xml"
          status 200

          <<~XML
            <project>
              <id>1</id>
              <actions></actions>
            <project>
          XML
        end
      end

      it "answers HTTP response with URI only" do
        response = responder.call :get, "/projects/1/actions"

        expect(response.to_a).to eq(
          [
            200,
            {"Content-Type" => "application/xml"},
            "<project>\n  <id>1</id>\n  <actions></actions>\n<project>\n"
          ]
        )
      end
    end

    context "with text" do
      let :function do
        proc do
          headers["Content-Type"] = "application/xml"
          status 200

          "Using project 1 with no actions."
        end
      end

      it "answers HTTP response with URI only" do
        response = responder.call :get, "/projects/1/actions"

        expect(response.to_a).to eq(
          [
            200,
            {"Content-Type" => "application/xml"},
            "Using project 1 with no actions."
          ]
        )
      end
    end

    context "with status only" do
      let(:function) { proc { status 200 } }

      it "answers successful but empty response" do
        response = responder.call :get, "/projects/1/actions"
        expect(response.to_a).to eq([200, {}, ""])
      end
    end

    context "with unknown content type" do
      let :function do
        proc do
          status 200
          {}
        end
      end

      it "answers string response" do
        response = responder.call :get, "/projects/1/actions"
        expect(response.to_a).to eq([200, {}, "{}"])
      end
    end

    context "with empty function" do
      let(:function) { proc { "" } }

      it "answers invalid response" do
        response = responder.call :get, "/projects/1/actions"
        expect(response.to_a).to eq([0, {}, ""])
      end
    end
  end

  describe "#status" do
    it "answers custom status when set" do
      responder.status 418
      expect(responder.status).to eq(418)
    end

    it "answers nil by default" do
      expect(responder.status).to be(nil)
    end
  end
end

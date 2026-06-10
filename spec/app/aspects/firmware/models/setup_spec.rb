# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Models::Setup, :db do
  subject(:model) { described_class.new }

  describe ".welcome" do
    it "answers welcome record" do
      expect(described_class.welcome).to eq(
        described_class[
          image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
          message: "Welcome to Terminus!"
        ]
      )
    end
  end

  describe "#initialize" do
    it "answers default attributes" do
      expect(model.to_h).to eq(image_url: nil, message: "MAC Address not registered.")
    end

    it "is frozen" do
      expect(model.frozen?).to be(true)
    end
  end

  describe "#to_json" do
    it "answers JSON" do
      payload = JSON model.to_json, symbolize_names: true

      expect(payload).to eq(image_url: nil, message: "MAC Address not registered.")
    end
  end
end

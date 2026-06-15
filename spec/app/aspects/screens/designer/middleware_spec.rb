# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Designer::Middleware do
  subject(:middleware) { described_class.new application, pattern: %r(/preview/(?<name>.+)) }

  let(:application) { proc { [200, {}, []] } }

  describe "#call" do
    let :environment do
      Rack::MockRequest.env_for(path, method: :get)
                       .tap { it["rack.session.options"] = {skip: false} }
    end

    let(:path) { +"/preview/test" }

    it "answers event stream when path matches" do
      expect(middleware.call(environment)).to match(
        array_including(
          200,
          {
            "Cache-Control" => "no-cache",
            "Connection" => "keep-alive",
            "Content-Encoding" => "identity",
            "Content-Type" => "text/event-stream",
            "X-Accel-Buffering" => "no"
          },
          instance_of(Terminus::Aspects::Screens::Designer::EventStream)
        )
      )
    end

    it "passes name to event stream" do
      event_stream = class_spy Terminus::Aspects::Screens::Designer::EventStream

      middleware = described_class.new(
        application,
        pattern: %r(/preview/(?<name>.+)),
        event_stream:
      )

      middleware.call environment

      expect(event_stream).to have_received(:new).with("test")
    end

    it "updates session options to be skipped" do
      middleware.call environment
      expect(environment.dig("rack.session.options", :skip)).to be(true)
    end

    it "answers original response when path doesn't match" do
      path.replace "/bogus"
      expect(middleware.call(environment)).to eq([200, {}, []])
    end

    it "answers original response when verb doesn't match" do
      path.replace "/test/1/example"
      expect(middleware.call(environment)).to eq([200, {}, []])
    end
  end
end

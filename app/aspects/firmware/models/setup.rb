# frozen_string_literal: true

module Terminus
  module Aspects
    module Firmware
      module Models
        # Models data for API setup responses.
        Setup = Struct.new :image_url, :message do
          def self.welcome
            new image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
                message: "Welcome to Terminus!"
          end

          def initialize(**)
            super
            self[:message] ||= "MAC Address not registered."
            freeze
          end

          def to_json(*) = to_h.to_json(*)
        end
      end
    end
  end
end

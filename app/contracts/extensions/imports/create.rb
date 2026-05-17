# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      module Imports
        # The contract for an extension import.
        class Create < Contract
          params do
            required(:extension).filled(:hash) do
              required(:attachment).filled Schemas::Attachment
            end
          end

          rule extension: :attachment do
            next if value[:tempfile].size <= 512_000

            key.failure "must be less than 500 KB"
          end
        end
      end
    end
  end
end

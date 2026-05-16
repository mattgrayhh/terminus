# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      module Importers
        module Local
          module Creators
            # Creates exchange.
            class Exchange
              include Deps[:logger, repository: "repositories.extension_exchange"]

              def initialize(schema: Schemas::Exchange, error_joiner: Errors::ResultJoiner, **)
                @schema = schema
                @error_joiner = error_joiner
                super(**)
              end

              def call attributes
                schema.call(attributes)
                      .to_monad
                      .alt_map { error_joiner.call "Exchange", it }
                      .fmap { create it.to_h }
              end

              private

              attr_reader :schema, :error_joiner

              def create(attributes) = repository.create(attributes).tap { log it, attributes }

              def log exchange, attributes
                tags = [{extension_id: attributes[:extension_id], exchange_id: exchange.id}]
                logger.debug(tags:) { "Imported extension exchange." }
              end
            end
          end
        end
      end
    end
  end
end

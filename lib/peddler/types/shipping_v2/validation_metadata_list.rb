# frozen_string_literal: true

require "peddler/types/shipping_v2/validation_metadata"

module Peddler
  module Types
    module ShippingV2
      # A list of ValidationMetadata
      class ValidationMetadataList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ValidationMetadata.parse(item) })
          end
        end
      end
    end
  end
end

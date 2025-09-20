# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/item_level_fields"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of item level fields.
      class ItemLevelFieldsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemLevelFields.parse(item) })
          end
        end
      end
    end
  end
end

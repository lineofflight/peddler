# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemProductTypeChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String]
        attribute(:asin, String, from: "Asin")

        # @return [String]
        attribute(:current_product_type, String, from: "CurrentProductType")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String]
        attribute(:previous_product_type, String, from: "PreviousProductType")
      end
    end
  end
end

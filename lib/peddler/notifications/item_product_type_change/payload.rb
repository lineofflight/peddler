# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemProductTypeChange
      # Notification payload data
      Payload = Structure.new do
        attribute(:asin, String, null: false, from: "Asin")

        attribute(:current_product_type, String, null: false, from: "CurrentProductType")

        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        attribute(:previous_product_type, String, null: false, from: "PreviousProductType")
      end
    end
  end
end

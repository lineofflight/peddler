# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module BrandedItemContentChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String]
        attribute(:asin, String, from: "Asin")

        # @return [Array<String>] The array of item attributes which changed. Possible values include bullet_point,
        #   item_name, product_description, and image-related attributes shown in the examples. NOTE: the attributes
        #   that contain the word 'image' all mean the same thing right now, which is that one or more images changed on
        #   the product detail page. In a future release we may update them to mean that individual image attribute
        #   changed, but for now if any image changes all the image attributes will be present in the notification.
        #   Attribute names, descriptions, and requirements are available in the Product Type Definitions API.
        attribute(:attributes_changed, [String], from: "AttributesChanged")

        # @return [String]
        attribute(:brand_name, String, from: "BrandName")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end

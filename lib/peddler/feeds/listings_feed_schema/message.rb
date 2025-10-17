# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedSchema
      # Message containing an individual listings data submission.
      Message = Structure.new do
        # @return [Integer] Identifier for the message that is unique within this feed submission. Response messages are
        #   correlated to this identifier.
        attribute(:message_id, Integer, from: "messageId")

        # @return [String] Type of operation to perform for the listings data submission in this message. "UPDATE"
        #   indicates the full set of item attributes are provided and any existing attributes data will be replaced
        #   with the provided attributes. "PARTIAL_UPDATE" indicates only the provided item attributes will be updated
        #   with the provided attribute data. "PATCH" indicates the provided JSON Patch operations will be used to
        #   update the applicable attributes. "DELETE" indicates the listings item will be deleted. "PARTIAL_UPDATE" is
        #   equivalent to using "PATCH" with the "replace" op.
        attribute(:operation_type, String, from: "operationType")

        # @return [String] Selling Partner SKU (stock keeping unit) identifier for the listing. SKU uniquely identifies
        #   a listing for a Selling Partner.
        attribute(:sku, String)

        # @return [Hash] Attributes data for the listings data submission.
        attribute?(:attributes, Hash)

        # @return [Array<Patch>] Attributes data in the form of JSON Patch operations to update or delete.
        attribute?(:patches, [Patch])

        # @return [String] Amazon product type of the listings data submission in this message.
        attribute?(:product_type, String, from: "productType")

        # @return [String] Name of the requirements type for the listings data submission in this message. "LISTING"
        #   indicates requirements inclusive of product facts and sales terms. "LISTING_PRODUCT_ONLY" indicates
        #   requirements inclusive of product facts only. "LISTING_OFFER_ONLY" indicates requirements inclusive of sales
        #   terms only.
        attribute?(:requirements, String)
      end
    end
  end
end

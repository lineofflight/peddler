# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The details of the container label.
      ContainerLabel = Structure.new do
        # @return [String] The container (pallet) tracking identifier from the shipping carrier.
        attribute(:container_tracking_number, String, from: "containerTrackingNumber")

        # @return [String] The container label content encoded into a Base64 string.
        attribute(:content, String)

        # @return [String] The format of the container label.
        attribute(:format, String)
      end
    end
  end
end

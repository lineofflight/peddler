# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Indicates the carrier details and their contact informations
      CarrierDetails = Structure.new do
        # @return [String] Code that identifies the carrier for the shipment. The Standard Carrier Alpha Code (SCAC) is
        # a unique two to four letter code used to identify a carrier. Carrier SCAC codes are assigned and maintained by
        # the NMFTA (National Motor Freight Association).
        attribute?(:code, String)

        # @return [String] The field is used to represent the carrier Email id.
        attribute?(:email, String)

        # @return [String] The field is used to represent the carrier used for performing the shipment.
        attribute?(:name, String)

        # @return [String] The field is used to represent the Carrier contact number.
        attribute?(:phone, String)

        # @return [String] The field is also known as PRO number is a unique number assigned by the carrier. It is used
        # to identify and track the shipment that goes out for delivery. This field is mandatory for US, CA, MX shipment
        # confirmations.
        attribute?(:shipment_reference_number, String, from: "shipmentReferenceNumber")
      end
    end
  end
end

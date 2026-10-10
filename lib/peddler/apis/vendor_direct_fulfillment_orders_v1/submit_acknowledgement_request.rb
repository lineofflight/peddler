# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # The request schema for the submitAcknowledgement operation.
      SubmitAcknowledgementRequest = Structure.new do
        # A list of one or more purchase orders.
        attribute?(:order_acknowledgements, [OrderAcknowledgementItem], from: "orderAcknowledgements")
      end
    end
  end
end

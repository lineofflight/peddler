# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorOrdersV1
      # The request schema for the submitAcknowledgment operation.
      SubmitAcknowledgementRequest = Structure.new do
        # An array of order acknowledgements to be submitted.
        attribute?(:acknowledgements, [OrderAcknowledgement])
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/error"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] List of errors.
        attribute(:errors, [Error])
      end
    end
  end
end

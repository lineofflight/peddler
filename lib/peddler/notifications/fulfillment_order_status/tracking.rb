# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # Tracking information for a package.
      Tracking = Structure.new do
        # @return [Hash] Amazon tracking information for a package.
        attribute?(:amazon, Hash)

        # @return [Hash] Carrier tracking information for a package.
        attribute?(:carrier, Hash)
      end
    end
  end
end

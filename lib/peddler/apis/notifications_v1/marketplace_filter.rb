# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # An event filter to customize your subscription to send notifications for only the specified `marketplaceId`s.
      MarketplaceFilter = Structure.new do
        # @return [Array<String>]
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end

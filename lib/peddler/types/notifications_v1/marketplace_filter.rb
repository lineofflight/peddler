# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module NotificationsV1
      # An event filter to customize your subscription to send notifications for only the specified `marketplaceId`s.
      MarketplaceFilter = Structure.new do
        # @return [Array]
        attribute(:marketplace_ids, Array, from: "marketplaceIds")
      end
    end
  end
end

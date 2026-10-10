# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # An event filter you can use to customize your subscription to send notifications for specific `marketplaceId`s.
      MarketplaceFilter = Structure.new do
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end

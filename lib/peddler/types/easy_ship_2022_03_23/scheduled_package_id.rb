# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module EasyShip20220323
      # Identifies the scheduled package to be updated.
      ScheduledPackageId = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [String]
        attribute(:package_id, String, from: "packageId")
      end
    end
  end
end

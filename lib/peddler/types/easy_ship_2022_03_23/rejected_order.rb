# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/error"

module Peddler
  module Types
    module EasyShip20220323
      # A order which we couldn't schedule on your behalf. It contains its id, and information on the error.
      RejectedOrder = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [Error]
        attribute(:error, Error)
      end
    end
  end
end

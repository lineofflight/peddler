# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # A order which we couldn't schedule on your behalf. It contains its id, and information on the error.
      RejectedOrder = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, null: false, from: "amazonOrderId")

        # @return [Error]
        attribute?(:error, Error)
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The account related data.
      Account = Structure.new do
        # @return [String]
        attribute(:account_id, String, null: false, from: "accountId")
      end
    end
  end
end

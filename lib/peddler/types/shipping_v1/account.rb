# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The account related data.
      Account = Structure.new do
        # @return [String]
        attribute(:account_id, String, from: "accountId")
      end
    end
  end
end

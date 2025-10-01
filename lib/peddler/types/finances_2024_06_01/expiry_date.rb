# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240601
      # The expiration date of the card used for payment. If the payment method is not `card`, the expiration date is
      # `null`.
      ExpiryDate = Structure.new do
        # @return [String] The month the card expires expressed as a number from `1` to `12`.
        attribute?(:month, String)

        # @return [String] Year
        attribute?(:year, String)
      end
    end
  end
end

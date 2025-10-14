# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerCoupon
      # Contains details about an asin.
      ASINDetails = Structure.new do
        # @return [String] The asin of the product.
        attribute(:asin, String)
      end
    end
  end
end

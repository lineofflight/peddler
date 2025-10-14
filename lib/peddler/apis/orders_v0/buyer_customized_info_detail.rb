# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Buyer information for custom orders from the Amazon Custom program.
      BuyerCustomizedInfoDetail = Structure.new do
        # @return [String] The location of a ZIP file containing Amazon Custom data.
        attribute?(:customized_url, String, from: "CustomizedURL")
      end
    end
  end
end

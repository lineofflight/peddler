# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The label specification info.
      LabelSpecification = Structure.new do
        # @return [String] The format of the label. Enum of PNG only for now.
        attribute(:label_format, String, from: "labelFormat")

        # @return [String] The label stock size specification in length and height. Enum of 4x6 only for now.
        attribute(:label_stock_size, String, from: "labelStockSize")
      end
    end
  end
end

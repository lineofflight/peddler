# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorInvoicesV1
      # The aggregate weight of this item being invoiced. This information will be available for items sold by weight.
      TotalWeight = Structure.new do
        # @return [String]
        attribute(:amount, String, null: false)

        # @return [String] The unit of measure for items sold by weight.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")
      end
    end
  end
end

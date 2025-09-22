# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorInvoicesV1
      # The aggregate weight of this item being invoiced. This information will be available for items sold by weight.
      TotalWeight = Structure.new do
        # @return [String] The unit of measure for items sold by weight.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String]
        attribute(:amount, String)
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The regulated information collected during purchase and used to verify the order.
      RegulatedInformation = Structure.new do
        # @return [Array<RegulatedInformationField>] A list of regulated information fields as collected from the
        #   regulatory form.
        attribute(:fields, [RegulatedInformationField], null: false, from: "Fields")
      end
    end
  end
end

# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Invoices20240619
      # The definition of the attribute option.
      AttributeOption = Structure.new do
        # @return [String] The description of the attribute value.
        attribute(:description, String)

        # @return [String] The possible values for the attribute option.
        attribute(:value, String)
      end
    end
  end
end

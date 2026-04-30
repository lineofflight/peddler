# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # An additional attribute associated with a tax registration.
      TaxRegistrationAttribute = Structure.new do
        # @return [String] The name of the tax registration attribute.
        #
        # **Possible values**: `TAX_OFFICE`
        attribute?(:key, String)

        # @return [String] The value of the tax registration attribute.
        attribute?(:value, String)
      end
    end
  end
end

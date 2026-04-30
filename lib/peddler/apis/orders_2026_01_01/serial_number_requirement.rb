# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Whether serial numbers must be provided for this line item.
      SerialNumberRequirement = Structure.new do
        # @return [String] The requirement type for this request.
        #
        # **Possible values**: `REQUIRED`
        attribute?(:requirement_type, String, from: "requirementType")
      end
    end
  end
end

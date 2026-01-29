# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about any personalization, customization, or special modifications applied to this order item.
      ItemCustomization = Structure.new do
        # @return [String] The URL of the customized data for custom orders from the Amazon Custom program.
        attribute?(:customized_url, String, from: "customizedUrl")
      end
    end
  end
end

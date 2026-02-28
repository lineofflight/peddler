# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # An alternative identifier that provides a different way to reference the same order.
      Alias = Structure.new do
        # @return [String] The alternative identifier value that can be used to reference this order.
        attribute(:alias_id, String, null: false, from: "aliasId")

        # @return [String] The kind of alternative identifier this represents.
        #
        # **Possible values**: `SELLER_ORDER_ID`
        attribute(:alias_type, String, null: false, from: "aliasType")
      end
    end
  end
end

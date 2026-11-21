# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Carrier Related Info
      Carrier = Structure.new do
        attribute(:id, String, null: false)

        attribute(:name, String, null: false)
      end
    end
  end
end

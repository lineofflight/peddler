# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Details related to any dangerous goods/items that are being shipped.
      DangerousGoodsDetails = Structure.new do
        # @return [String] The specific packaging group of the item being shipped.
        attribute?(:packing_group, String, from: "packingGroup")

        # @return [String] The specific packing instruction of the item being shipped.
        attribute?(:packing_instruction, String, from: "packingInstruction")

        # @return [String] The specific regulatory class of the item being shipped.
        attribute?(:transportation_regulatory_class, String, from: "transportationRegulatoryClass")

        # @return [String] The specific UNID of the item being shipped.
        attribute?(:united_nations_regulatory_id, String, from: "unitedNationsRegulatoryId")
      end
    end
  end
end

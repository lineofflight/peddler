# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Details related to any dangerous goods/items that are being shipped.
      DangerousGoodsDetails = Structure.new do
        # @return [String] The specific packaging group of the item being shipped. Known values: `I`, `II`, `III`.
        attribute?(:packing_group, String, from: "packingGroup")

        # @return [String] The specific packing instruction of the item being shipped. Known values: `PI965_SECTION_IA`,
        #   `PI965_SECTION_IB`, `PI965_SECTION_II`, `PI966_SECTION_I`, `PI966_SECTION_II`, `PI967_SECTION_I`,
        #   `PI967_SECTION_II`, `PI968_SECTION_IA`, `PI968_SECTION_IB`, `PI969_SECTION_I`, `PI969_SECTION_II`,
        #   `PI970_SECTION_I`, `PI970_SECTION_II`.
        attribute?(:packing_instruction, String, from: "packingInstruction")

        # @return [String] The specific regulatory class of the item being shipped.
        attribute?(:transportation_regulatory_class, String, from: "transportationRegulatoryClass")

        # @return [String] The specific UNID of the item being shipped.
        attribute?(:united_nations_regulatory_id, String, from: "unitedNationsRegulatoryId")
      end
    end
  end
end

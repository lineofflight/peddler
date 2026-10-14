# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Details related to any dangerous goods or items that are shipped.
      DangerousGoodsDetails = Structure.new do
        # @return [String] The specific packaging group of the item being shipped. Known values: `I`, `II`, `III`.
        attribute?(:packing_group, String, from: "PackingGroup")

        # @return [String] The specific packing instruction of the item being shipped. Known values: `PI965_SECTION_IA`,
        #   `PI965_SECTION_IB`, `PI965_SECTION_II`, `PI966_SECTION_I`, `PI966_SECTION_II`, `PI967_SECTION_I`,
        #   `PI967_SECTION_II`, `PI968_SECTION_IA`, `PI968_SECTION_IB`, `PI969_SECTION_I`, `PI969_SECTION_II`,
        #   `PI970_SECTION_I`, `PI970_SECTION_II`.
        attribute?(:packing_instruction, String, from: "PackingInstruction")

        # @return [String] The specific regulatory class of the shipped item.
        attribute?(:transportation_regulatory_class, String, from: "TransportationRegulatoryClass")

        # @return [String] The specific UNID of the item being shipped.
        attribute?(:united_nations_regulatory_id, String, from: "UnitedNationsRegulatoryId")
      end
    end
  end
end

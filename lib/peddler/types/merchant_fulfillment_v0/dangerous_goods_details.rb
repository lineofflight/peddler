# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Details related to any dangerous goods or items that are shipped.
      DangerousGoodsDetails = Structure.new do
        # @return [String] The specific UNID of the item being shipped.
        attribute?(:united_nations_regulatory_id, String, from: "UnitedNationsRegulatoryId")

        # @return [String] The specific regulatory class of the shipped item.
        attribute?(:transportation_regulatory_class, String, from: "TransportationRegulatoryClass")

        # @return [String] The specific packaging group of the item being shipped.
        attribute?(:packing_group, String, from: "PackingGroup")

        # @return [String] The specific packing instruction of the item being shipped.
        attribute?(:packing_instruction, String, from: "PackingInstruction")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Details related to any dangerous goods or items that are shipped.
      DangerousGoodsDetails = Structure.new do
        # The specific packaging group of the item being shipped.
        attribute?(:packing_group, String, from: "PackingGroup")

        # The specific packing instruction of the item being shipped.
        attribute?(:packing_instruction, String, from: "PackingInstruction")

        # The specific regulatory class of the shipped item.
        attribute?(:transportation_regulatory_class, String, from: "TransportationRegulatoryClass")

        # The specific UNID of the item being shipped.
        attribute?(:united_nations_regulatory_id, String, from: "UnitedNationsRegulatoryId")
      end
    end
  end
end

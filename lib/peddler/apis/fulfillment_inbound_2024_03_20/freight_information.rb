# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Freight information describes the SKUs that are in transit. Freight carrier options and quotes will only be
      # returned if the freight information is provided.
      FreightInformation = Structure.new do
        # @return [Money]
        attribute?(:declared_value, Money, from: "declaredValue")

        # @return [String] Freight class.
        #
        # Possible values: `NONE`, `FC_50`, `FC_55`, `FC_60`, `FC_65`, `FC_70`, `FC_77_5`, `FC_85`, `FC_92_5`, `FC_100`,
        # `FC_110`, `FC_125`, `FC_150`, `FC_175`, `FC_200`, `FC_250`, `FC_300`, `FC_400`, `FC_500`.
        attribute?(:freight_class, String, from: "freightClass")
      end
    end
  end
end

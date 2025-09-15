# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/operational_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # The delivery channel of a supply source.
      DeliveryChannel = Structure.new do
        # @return [:boolean]
        attribute(:is_supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end

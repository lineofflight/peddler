# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/operational_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # Includes configuration and timezone of a supply source.
      SupplySourceConfiguration = Structure.new do
        # @return [OperationalConfiguration]
        attribute(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [String] Please see RFC 6557, should be a canonical time zone ID as listed here:
        # https://www.joda.org/joda-time/timezones.html.
        attribute(:timezone, String)
      end
    end
  end
end

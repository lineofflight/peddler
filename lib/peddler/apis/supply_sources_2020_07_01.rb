# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Supply Sources
    #
    # Manage configurations and capabilities of seller supply sources.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/supply-sources-api-model/supplySources_2020-07-01.json
    module SupplySources20200701
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "supply_sources_2020_07_01.archive_supply_source" => -> { ErrorList },
        "supply_sources_2020_07_01.create_supply_source" => -> { CreateSupplySourceResponse },
        "supply_sources_2020_07_01.get_supply_source" => -> { SupplySource },
        "supply_sources_2020_07_01.get_supply_sources" => -> { GetSupplySourcesResponse },
        "supply_sources_2020_07_01.update_supply_source" => -> { ErrorList },
        "supply_sources_2020_07_01.update_supply_source_status" => -> { ErrorList },
      }.freeze
    end
  end
end

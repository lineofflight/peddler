# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The paginated list of supply sources.
      GetSupplySourcesResponse = Structure.new do
        # @return [String] If present, use this pagination token to retrieve the next page of supply sources.
        attribute?(:next_page_token, String, from: "nextPageToken")

        # @return [Array<Object>]
        attribute?(:supply_sources, Array, from: "supplySources")
      end
    end
  end
end

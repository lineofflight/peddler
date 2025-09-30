# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The paginated list of supply sources.
      GetSupplySourcesResponse = Structure.new do
        # @return [Array<Object>]
        attribute?(:supply_sources, Array, from: "supplySources")

        # @return [String] If present, use this pagination token to retrieve the next page of supply sources.
        attribute?(:next_page_token, String, from: "nextPageToken")
      end
    end
  end
end

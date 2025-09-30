# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/collection_forms_history_record"

module Peddler
  module Types
    module ShippingV2
      # The Response for the GetCollectionFormHistoryResponse operation.
      GetCollectionFormHistoryResponse = Structure.new do
        # @return [Array<CollectionFormsHistoryRecord>]
        attribute?(:collection_forms_history_record_list, [CollectionFormsHistoryRecord], from: "collectionFormsHistoryRecordList")

        # @return [String] Last Refereshed Date of collection
        attribute?(:last_refreshed_date, String, from: "lastRefreshedDate")
      end
    end
  end
end

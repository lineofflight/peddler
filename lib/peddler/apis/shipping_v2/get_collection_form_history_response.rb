# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The Response for the GetCollectionFormHistoryResponse operation.
      GetCollectionFormHistoryResponse = Structure.new do
        attribute?(:collection_forms_history_record_list, [CollectionFormsHistoryRecord], from: "collectionFormsHistoryRecordList")

        # Last Refereshed Date of collection
        attribute?(:last_refreshed_date, String, from: "lastRefreshedDate")
      end
    end
  end
end

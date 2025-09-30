# frozen_string_literal: true

require "peddler/types/shipping_v2/collection_forms_history_record"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of CollectionFormsHistoryRecord
      class CollectionFormsHistoryRecordList < Array
        class << self
          def parse(array)
            new(array.map { |item| CollectionFormsHistoryRecord.parse(item) })
          end
        end
      end
    end
  end
end

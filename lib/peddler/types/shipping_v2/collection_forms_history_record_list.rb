# frozen_string_literal: true

require "peddler/types/shipping_v2/collection_forms_history_record"

module Peddler
  module Types
    module ShippingV2
      # A list of CollectionFormsHistoryRecord
      class CollectionFormsHistoryRecordList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| CollectionFormsHistoryRecord.parse(item) })
          end
        end
      end
    end
  end
end

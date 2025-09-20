# frozen_string_literal: true

require "peddler/types/services_v1/fulfillment_document"

module Peddler
  module Types
    module ServicesV1
      # List of documents captured during service appointment fulfillment.
      class FulfillmentDocuments < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FulfillmentDocument.parse(item) })
          end
        end
      end
    end
  end
end

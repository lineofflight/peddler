# frozen_string_literal: true

require "peddler/types/services_v1/fulfillment_document"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ServicesV1
      # List of documents captured during service appointment fulfillment.
      class FulfillmentDocuments < Array
        class << self
          def parse(array)
            new(array.map { |item| FulfillmentDocument.parse(item) })
          end
        end
      end
    end
  end
end

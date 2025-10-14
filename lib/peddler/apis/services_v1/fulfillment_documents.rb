# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ServicesV1
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

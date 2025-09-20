# frozen_string_literal: true

require "peddler/types/shipping_v2/supported_document_specification"

module Peddler
  module Types
    module ShippingV2
      # A list of the document specifications supported for a shipment service offering.
      class SupportedDocumentSpecificationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SupportedDocumentSpecification.parse(item) })
          end
        end
      end
    end
  end
end

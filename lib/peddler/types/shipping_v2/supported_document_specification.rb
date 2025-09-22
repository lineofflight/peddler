# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/document_size"
require "peddler/types/shipping_v2/print_option"

module Peddler
  module Types
    module ShippingV2
      # Document specification that is supported for a service offering.
      SupportedDocumentSpecification = Structure.new do
        # @return [String]
        attribute(:format, String)

        # @return [DocumentSize]
        attribute(:size, DocumentSize)

        # @return [Array<PrintOption>]
        attribute(:print_options, [PrintOption], from: "printOptions")
      end
    end
  end
end

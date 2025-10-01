# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/print_option"
require "peddler/types/shipping_v2/document_size"

module Peddler
  module Types
    module ShippingV2
      # Document specification that is supported for a service offering.
      SupportedDocumentSpecification = Structure.new do
        # @return [String]
        attribute(:format, String)

        # @return [Array<PrintOption>]
        attribute(:print_options, [PrintOption], from: "printOptions")

        # @return [DocumentSize]
        attribute(:size, DocumentSize)
      end
    end
  end
end

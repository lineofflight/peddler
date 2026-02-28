# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Document specification that is supported for a service offering.
      SupportedDocumentSpecification = Structure.new do
        # @return [String]
        attribute(:format, String, null: false)

        # @return [Array<PrintOption>]
        attribute(:print_options, [PrintOption], null: false, from: "printOptions")

        # @return [DocumentSize]
        attribute(:size, DocumentSize, null: false)
      end
    end
  end
end

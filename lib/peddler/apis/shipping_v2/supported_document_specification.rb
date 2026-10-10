# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Document specification that is supported for a service offering.
      SupportedDocumentSpecification = Structure.new do
        attribute(:format, String, null: false)

        attribute(:print_options, [PrintOption], null: false, from: "printOptions")

        attribute(:size, DocumentSize, null: false)
      end
    end
  end
end

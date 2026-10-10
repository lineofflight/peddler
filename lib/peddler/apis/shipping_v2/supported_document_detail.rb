# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The supported document types for a service offering.
      SupportedDocumentDetail = Structure.new do
        # When true, the supported document type is required.
        attribute(:mandatory, :boolean, null: false, from: "isMandatory")

        attribute(:name, String, null: false)
      end
    end
  end
end

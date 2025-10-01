# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The supported document types for a service offering.
      SupportedDocumentDetail = Structure.new do
        # @return [:boolean] When true, the supported document type is required.
        attribute(:mandatory, :boolean, from: "isMandatory")

        # @return [String]
        attribute(:name, String)
      end
    end
  end
end

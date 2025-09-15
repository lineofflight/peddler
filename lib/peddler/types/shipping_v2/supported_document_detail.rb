# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The supported document types for a service offering.
      SupportedDocumentDetail = Structure.new do
        # @return [String]
        attribute(:name, String)

        # @return [:boolean] When true, the supported document type is required.
        attribute(:is_mandatory, :boolean, from: "isMandatory")
      end
    end
  end
end

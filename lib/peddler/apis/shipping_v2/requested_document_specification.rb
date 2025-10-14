# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The document specifications requested. For calls to the purchaseShipment operation, the shipment purchase fails
      # if the specified document specifications are not among those returned in the response to the getRates operation.
      RequestedDocumentSpecification = Structure.new do
        # @return [String]
        attribute(:format, String)

        # @return [:boolean]
        attribute(:need_file_joining, :boolean, from: "needFileJoining")

        # @return [Array<DocumentType>] A list of the document types requested.
        attribute(:requested_document_types, Array, from: "requestedDocumentTypes")

        # @return [DocumentSize]
        attribute(:size, DocumentSize)

        # @return [Integer]
        attribute?(:dpi, Integer)

        # @return [String]
        attribute?(:page_layout, String, from: "pageLayout")

        # @return [RequestedLabelCustomization]
        attribute?(:requested_label_customization, RequestedLabelCustomization, from: "requestedLabelCustomization")
      end
    end
  end
end

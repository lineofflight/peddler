# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The format options available for a label.
      PrintOption = Structure.new do
        # @return [Array<SupportedDocumentDetail>] A list of the supported documented details.
        attribute(:supported_document_details, [SupportedDocumentDetail], from: "supportedDocumentDetails")

        # @return [Array<NeedFileJoining>] A list of the supported needFileJoining boolean values for a document.
        attribute(:supported_file_joining_options, Array, from: "supportedFileJoiningOptions")

        # @return [Array<PageLayout>] A list of the supported page layout options for a document.
        attribute(:supported_page_layouts, Array, from: "supportedPageLayouts")

        # @return [Array<Dpi>] A list of the supported DPI options for a document.
        attribute?(:supported_dp_is, Array, from: "supportedDPIs")
      end
    end
  end
end

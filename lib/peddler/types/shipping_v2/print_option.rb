# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/supported_document_detail"

module Peddler
  module Types
    module ShippingV2
      # The format options available for a label.
      PrintOption = Structure.new do
        # @return [Array<Dpi>] A list of the supported DPI options for a document.
        attribute?(:supported_dp_is, Array, from: "supportedDPIs")

        # @return [Array<PageLayout>] A list of the supported page layout options for a document.
        attribute(:supported_page_layouts, Array, from: "supportedPageLayouts")

        # @return [Array<NeedFileJoining>] A list of the supported needFileJoining boolean values for a document.
        attribute(:supported_file_joining_options, Array, from: "supportedFileJoiningOptions")

        # @return [Array<SupportedDocumentDetail>] A list of the supported documented details.
        attribute(:supported_document_details, [SupportedDocumentDetail], from: "supportedDocumentDetails")
      end
    end
  end
end

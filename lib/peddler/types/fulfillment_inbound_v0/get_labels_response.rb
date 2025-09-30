# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/label_download_url"
require "peddler/types/fulfillment_inbound_v0/error"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getLabels operation.
      GetLabelsResponse = Structure.new do
        # @return [LabelDownloadURL] The payload for the getLabels operation.
        attribute?(:payload, LabelDownloadURL)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end

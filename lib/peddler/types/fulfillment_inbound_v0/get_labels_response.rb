# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/error"
require "peddler/types/fulfillment_inbound_v0/label_download_url"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getLabels operation.
      GetLabelsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [LabelDownloadURL] The payload for the getLabels operation.
        attribute?(:payload, LabelDownloadURL)
      end
    end
  end
end

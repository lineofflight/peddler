# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
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

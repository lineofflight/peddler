# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Download URL for a label
      LabelDownloadURL = Structure.new do
        # @return [String] URL to download the label for the package. Note: The URL will only be valid for 15 seconds
        attribute(:download_url, String, from: "DownloadURL")
      end
    end
  end
end

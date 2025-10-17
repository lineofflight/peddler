# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Resource to download the requested document.
      DocumentDownload = Structure.new do
        # @return [String] The type of download. Possible values: `URL`.
        attribute(:download_type, String, from: "downloadType")

        # @return [String] Uniform resource identifier to identify where the document is located.
        attribute(:uri, String)

        # @return [Time] The URI's expiration time. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        #   `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute?(:expiration, Time)
      end
    end
  end
end

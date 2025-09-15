# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Resource to download the requested document.
      DocumentDownload = Structure.new do
        # @return [String] The type of download. Possible values: `URL`.
        attribute(:download_type, String, from: "downloadType")

        # @return [String] The URI's expiration time. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, String)

        # @return [String] Uniform resource identifier to identify where the document is located.
        attribute(:uri, String)
      end
    end
  end
end

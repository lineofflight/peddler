# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Shipment labels.
      ShipmentLabels = Structure.new do
        # @return [String] The URL to download shipment labels. The URL is active for 600 seconds from generation.
        attribute(:label_download_url, String, from: "labelDownloadURL")

        # @return [String] Status of label generation.
        attribute(:label_status, String, from: "labelStatus")
      end
    end
  end
end

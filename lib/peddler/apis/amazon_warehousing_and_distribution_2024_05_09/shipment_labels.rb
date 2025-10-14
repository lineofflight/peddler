# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Shipment labels.
      ShipmentLabels = Structure.new do
        # @return [String] Status of label generation.
        attribute(:label_status, String, from: "labelStatus")

        # @return [String] The URL to download shipment labels. The URL is active for 600 seconds from generation.
        attribute?(:label_download_url, String, from: "labelDownloadURL")
      end
    end
  end
end

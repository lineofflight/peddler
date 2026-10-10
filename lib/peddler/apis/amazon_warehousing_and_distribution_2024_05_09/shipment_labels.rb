# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Shipment labels.
      ShipmentLabels = Structure.new do
        # Status of label generation.
        attribute(:label_status, String, null: false, from: "labelStatus")

        # The URL to download shipment labels. The URL is active for 600 seconds from generation.
        attribute?(:label_download_url, String, from: "labelDownloadURL")
      end
    end
  end
end

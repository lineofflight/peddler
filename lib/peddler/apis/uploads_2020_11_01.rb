# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Uploads
    #
    # The Uploads API lets you upload files that you can programmatically access using other Selling Partner APIs, such
    # as the A+ Content API and the Messaging API.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/uploads-api-model/uploads_2020-11-01.json
    module Uploads20201101
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "uploads_2020_11_01.create_upload_destination_for_resource" => -> { CreateUploadDestinationResponse },
      }.freeze
    end
  end
end

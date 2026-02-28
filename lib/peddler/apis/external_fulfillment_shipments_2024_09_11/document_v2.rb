# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # An [S3-Presigned URL](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html) you can
      # use to retrieve file contents.
      DocumentV2 = Structure.new do
        # @return [String] A presigned URL to fetch the ship label file using an HTTP GET request. To determine file
        #   type, use the `contentType` header of the file response. The file retrieved will be in one of the following
        #   supported formats:
        #
        # - **ZPL**: `x.application/zpl` - **PDF**: `application/pdf` - **PNG**: `image/png` - **Plain Text**:
        #   `text/plain`
        attribute(:url, String, null: false)
      end
    end
  end
end

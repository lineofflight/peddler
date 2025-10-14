# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # Represents a file that was uploaded to a destination that was created by the Uploads API
      # [`createUploadDestinationForResource`](https://developer-docs.amazon.com/sp-api/reference/createuploaddestinationforresource)
      # operation.
      Attachment = Structure.new do
        # @return [String] The name of the file, including the extension. This is the file name that will appear in the
        # message. This does not need to match the file name of the file that you uploaded.
        attribute(:file_name, String, from: "fileName")

        # @return [String] The identifier for the upload destination. To retrieve this value, call the Uploads API
        # [`createUploadDestinationForResource`](https://developer-docs.amazon.com/sp-api/reference/createuploaddestinationforresource)
        # operation.
        attribute(:upload_destination_id, String, from: "uploadDestinationId")
      end
    end
  end
end

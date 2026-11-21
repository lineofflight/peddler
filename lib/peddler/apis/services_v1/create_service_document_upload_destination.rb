# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # The response schema for the `createServiceDocumentUploadDestination` operation.
      CreateServiceDocumentUploadDestination = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, ServiceDocumentUploadDestination)
      end
    end
  end
end

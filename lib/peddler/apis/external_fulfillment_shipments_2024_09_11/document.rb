# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A document, described by its file type and data.
      Document = Structure.new do
        # Base 64 encoded file contents.
        attribute?(:content, String)

        # The type of the file.
        attribute?(:format, String)
      end
    end
  end
end

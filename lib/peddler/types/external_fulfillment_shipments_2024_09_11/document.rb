# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A document, described by its file type and data.
      Document = Structure.new do
        # @return [String] Base 64 encoded file contents.
        attribute?(:content, String)

        # @return [String] The type of the file.
        attribute?(:format, String)
      end
    end
  end
end

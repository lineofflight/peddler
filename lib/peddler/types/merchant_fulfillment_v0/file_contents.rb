# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The document data and checksum.
      FileContents = Structure.new do
        # @return [String] Data for printing labels encoded into a Base64, GZip-compressed string.
        attribute(:contents, String, from: "Contents")

        # @return [String]
        attribute(:file_type, String, from: "FileType")

        # @return [String] An MD5 hash to validate the PDF document data, in the form of a Base64 string.
        attribute(:checksum, String, from: "Checksum")
      end
    end
  end
end

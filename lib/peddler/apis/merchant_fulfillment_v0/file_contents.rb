# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The document data and checksum.
      FileContents = Structure.new do
        # @return [String] An MD5 hash to validate the PDF document data, in the form of a Base64 string.
        attribute(:checksum, String, null: false, from: "Checksum")

        # @return [String] Data for printing labels encoded into a Base64, GZip-compressed string.
        attribute(:contents, String, null: false, from: "Contents")

        # @return [String]
        attribute(:file_type, String, null: false, from: "FileType")
      end
    end
  end
end

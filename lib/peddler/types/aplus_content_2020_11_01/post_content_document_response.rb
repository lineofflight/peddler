# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      PostContentDocumentResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:warnings, [Error])

        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")
      end
    end
  end
end

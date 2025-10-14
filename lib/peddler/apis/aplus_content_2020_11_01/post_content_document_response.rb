# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      PostContentDocumentResponse = Structure.new do
        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")

        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end

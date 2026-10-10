# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      PostContentDocumentResponse = Structure.new do
        attribute(:content_reference_key, String, null: false, from: "contentReferenceKey")

        attribute?(:warnings, [Error])
      end
    end
  end
end

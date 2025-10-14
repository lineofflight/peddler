# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      PostContentDocumentRequest = Structure.new do
        # @return [ContentDocument]
        attribute(:content_document, ContentDocument, from: "contentDocument")
      end
    end
  end
end

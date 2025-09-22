# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/content_document"

module Peddler
  module Types
    module AplusContent20201101
      PostContentDocumentRequest = Structure.new do
        # @return [ContentDocument]
        attribute(:content_document, ContentDocument, from: "contentDocument")
      end
    end
  end
end

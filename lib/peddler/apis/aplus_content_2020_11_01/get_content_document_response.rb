# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      GetContentDocumentResponse = Structure.new do
        # @return [ContentRecord]
        attribute(:content_record, ContentRecord, from: "contentRecord")

        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end

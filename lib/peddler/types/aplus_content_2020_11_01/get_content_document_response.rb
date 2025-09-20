# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/error"
require "peddler/types/aplus_content_2020_11_01/content_record"

module Peddler
  module Types
    module AplusContent20201101
      GetContentDocumentResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:warnings, [Error])

        # @return [ContentRecord]
        attribute(:content_record, ContentRecord, from: "contentRecord")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/content_record"
require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      GetContentDocumentResponse = Structure.new do
        # @return [ContentRecord]
        attribute(:content_record, ContentRecord, from: "contentRecord")

        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end

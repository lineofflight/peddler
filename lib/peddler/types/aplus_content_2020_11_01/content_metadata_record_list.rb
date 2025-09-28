# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/content_metadata_record"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
      # A list of A+ Content metadata records.
      class ContentMetadataRecordList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ContentMetadataRecord.parse(item) }) : new
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/publish_record"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
      # A list of A+ Content publishing records.
      class PublishRecordList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| PublishRecord.parse(item) }) : new
          end
        end
      end
    end
  end
end

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
            new(array.map { |item| PublishRecord.parse(item) })
          end
        end
      end
    end
  end
end

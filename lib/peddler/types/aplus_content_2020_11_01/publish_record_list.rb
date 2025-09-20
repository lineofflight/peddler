# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/publish_record"

module Peddler
  module Types
    module AplusContent20201101
      # A list of A+ Content publishing records.
      class PublishRecordList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PublishRecord.parse(item) })
          end
        end
      end
    end
  end
end

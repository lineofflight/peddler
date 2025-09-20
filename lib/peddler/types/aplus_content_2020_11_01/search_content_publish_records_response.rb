# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/publish_record"

module Peddler
  module Types
    module AplusContent20201101
      SearchContentPublishRecordsResponse = Structure.new do
        # @return [Array<PublishRecord>]
        attribute(:publish_record_list, [PublishRecord], from: "publishRecordList")
      end
    end
  end
end

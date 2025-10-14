# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      SearchContentPublishRecordsResponse = Structure.new do
        # @return [Array<PublishRecord>]
        attribute(:publish_record_list, [PublishRecord], from: "publishRecordList")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      SearchContentPublishRecordsResponse = Structure.new do
        attribute(:publish_record_list, [PublishRecord], null: false, from: "publishRecordList")
      end
    end
  end
end

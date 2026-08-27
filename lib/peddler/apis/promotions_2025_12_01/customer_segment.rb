# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The customer segment. When `segmentType` is `BRAND`, `segmentId` contains the segment / audience ID and
      # `segmentDetails.brandSegmentDetails` must be provided. When `segmentType` is `PROGRAM`, `segmentId` contains the
      # program name (for example, `PRIME_EXCLUSIVE`, `MOM`, `STUDENT`).
      CustomerSegment = Structure.new do
        # @return [String] The segment identifier. For `BRAND`: the segment / audience ID. For `PROGRAM`: the program
        #   name (for example, `PRIME_EXCLUSIVE`, `MOM`, `STUDENT` etc).
        attribute(:segment_id, String, null: false, from: "segmentId")

        # @return [String] Top-level segment type.
        attribute(:segment_type, String, null: false, from: "segmentType")

        # @return [CustomerSegmentDetails] Additional segment-specific details. Required for `BRAND` segments type.
        attribute?(:segment_details, CustomerSegmentDetails, from: "segmentDetails")
      end
    end
  end
end

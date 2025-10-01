# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Information about the seller of the service job.
      Seller = Structure.new do
        # @return [String] The identifier of the seller of the service job.
        attribute?(:seller_id, String, from: "sellerId")
      end
    end
  end
end

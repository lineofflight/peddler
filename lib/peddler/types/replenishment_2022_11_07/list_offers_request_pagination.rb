# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # Use these parameters to paginate through the response.
      ListOffersRequestPagination = Structure.new do
        # @return [Integer] The maximum number of results to return in the response.
        attribute(:limit, Integer)

        # @return [Integer] The offset from which to retrieve the number of results specified by the `limit` value. The
        # first result is at offset 0.
        attribute(:offset, Integer)
      end
    end
  end
end

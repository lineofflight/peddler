# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains tokens to fetch from a certain page.
      Pagination = Structure.new do
        # @return [String] When present, pass this string token in the next request to return the next response page.
        attribute(:next_token, String, from: "nextToken")
      end
    end
  end
end

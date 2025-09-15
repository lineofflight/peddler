# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module DataKiosk20231115
      # The response for the `createQuery` operation.
      CreateQueryResponse = Structure.new do
        # @return [String] The identifier for the query. This identifier is unique only in combination with a selling
        # partner account ID.
        attribute(:query_id, String, from: "queryId")
      end
    end
  end
end

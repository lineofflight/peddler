# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DataKiosk20231115
      # The response for the `createQuery` operation.
      CreateQueryResponse = Structure.new do
        # @return [String] The identifier for the query. This identifier is unique only in combination with a selling
        #   partner account ID.
        attribute(:query_id, String, null: false, from: "queryId")
      end
    end
  end
end

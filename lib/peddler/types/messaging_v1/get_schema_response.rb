# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/messaging_v1/error"
require "peddler/types/messaging_v1/schema"

module Peddler
  module Types
    module MessagingV1
      # The `GET` request schema response.
      GetSchemaResponse = Structure.new do
        # @return [Hash] The links response that is associated with the object.
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [Schema]
        attribute?(:payload, Schema)
      end
    end
  end
end

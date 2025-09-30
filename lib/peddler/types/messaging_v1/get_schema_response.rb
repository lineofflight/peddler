# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/messaging_v1/schema"
require "peddler/types/messaging_v1/error"

module Peddler
  module Types
    module MessagingV1
      # The `GET` request schema response.
      GetSchemaResponse = Structure.new do
        # @return [Hash] The links response that is associated with the object.
        attribute?(:_links, Hash)

        # @return [Schema]
        attribute?(:payload, Schema)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end

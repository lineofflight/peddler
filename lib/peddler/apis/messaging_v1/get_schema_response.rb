# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # The `GET` request schema response.
      GetSchemaResponse = Structure.new do
        # The links response that is associated with the object.
        attribute?(:_links, Hash)

        attribute?(:errors, [Error])

        attribute?(:payload, Hash)
      end
    end
  end
end

# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # Individual JSON Patch operation for an HTTP PATCH request.
      PatchOperation = Structure.new do
        # @return [String] Type of JSON Patch operation. Supported JSON Patch operations include `add`, `replace`,
        # `merge` and `delete`. Refer to <https://tools.ietf.org/html/rfc6902>.
        attribute(:op, String)

        # @return [String] JSON Pointer path of the element to patch. Refer to [JavaScript Object Notation (JSON)
        # Patch](https://tools.ietf.org/html/rfc6902) for more information.
        attribute(:path, String)

        # @return [Array<Object>] JSON value to `add`, `replace`, `merge` or `delete`.
        attribute(:value, Array)
      end
    end
  end
end

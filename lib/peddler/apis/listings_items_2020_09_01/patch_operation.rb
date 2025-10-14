# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20200901
      # Individual JSON Patch operation for an HTTP PATCH request.
      PatchOperation = Structure.new do
        # @return [String] Type of JSON Patch operation. Supported JSON Patch operations include add, replace, and
        # delete. See <https://tools.ietf.org/html/rfc6902>.
        attribute(:op, String)

        # @return [String] JSON Pointer path of the element to patch. See <https://tools.ietf.org/html/rfc6902>.
        attribute(:path, String)

        # @return [Array<Object>] JSON value to add, replace, or delete.
        attribute?(:value, Array)
      end
    end
  end
end

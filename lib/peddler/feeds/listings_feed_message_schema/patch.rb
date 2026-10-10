# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedMessageSchema
      # Individual JSON Patch operation.
      Patch = Structure.new do
        # Type of JSON Patch operation. Supported JSON Patch operations include add, replace, merge, and delete. See
        # https://tools.ietf.org/html/rfc6902.
        attribute(:op, String, null: false)

        # JSON Pointer path of the attribute to patch. See https://tools.ietf.org/html/rfc6902.
        attribute(:path, String, null: false)

        # JSON value to add, replace, or delete.
        attribute?(:value, Array)
      end
    end
  end
end

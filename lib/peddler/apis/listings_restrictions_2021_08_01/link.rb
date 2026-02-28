# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsRestrictions20210801
      # A link to resources related to a listing restriction.
      Link = Structure.new do
        # @return [URI] The URI of the related resource.
        attribute(:resource, URI, null: false)

        # @return [String] The HTTP verb used to interact with the related resource.
        attribute(:verb, String, null: false)

        # @return [String] The title of the related resource.
        attribute?(:title, String)

        # @return [String] The media type of the related resource.
        attribute?(:type, String)
      end
    end
  end
end

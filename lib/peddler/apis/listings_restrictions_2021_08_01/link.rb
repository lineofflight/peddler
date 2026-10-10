# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "uri"

module Peddler
  module APIs
    module ListingsRestrictions20210801
      # A link to resources related to a listing restriction.
      Link = Structure.new do
        # The URI of the related resource.
        attribute(:resource, URI, null: false)

        # The HTTP verb used to interact with the related resource.
        attribute(:verb, String, null: false)

        # The title of the related resource.
        attribute?(:title, String)

        # The media type of the related resource.
        attribute?(:type, String)
      end
    end
  end
end

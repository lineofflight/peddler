# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ListingsRestrictions20210801
      # A link to resources related to a listing restriction.
      Link = Structure.new do
        # @return [String] The URI of the related resource.
        attribute(:resource, String)

        # @return [String] The HTTP verb used to interact with the related resource.
        attribute(:verb, String)

        # @return [String] The title of the related resource.
        attribute?(:title, String)

        # @return [String] The media type of the related resource.
        attribute?(:type, String)
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content document. This is the enhanced content that is published to product detail pages.
      ContentDocument = Structure.new do
        # @return [Array<ContentModule>]
        attribute(:content_module_list, [ContentModule], null: false, from: "contentModuleList")

        # @return [String]
        attribute(:content_type, String, null: false, from: "contentType")

        # @return [String]
        attribute(:locale, String, null: false)

        # @return [String] The A+ Content document name.
        attribute(:name, String, null: false)

        # @return [String]
        attribute?(:content_sub_type, String, from: "contentSubType")
      end
    end
  end
end

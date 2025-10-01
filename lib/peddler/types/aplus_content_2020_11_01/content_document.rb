# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/content_module"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content document. This is the enhanced content that is published to product detail pages.
      ContentDocument = Structure.new do
        # @return [Array<ContentModule>]
        attribute(:content_module_list, [ContentModule], from: "contentModuleList")

        # @return [String]
        attribute(:content_type, String, from: "contentType")

        # @return [String]
        attribute(:locale, String)

        # @return [String] The A+ Content document name.
        attribute(:name, String)

        # @return [String]
        attribute?(:content_sub_type, String, from: "contentSubType")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The response for the `getItemBrowseNode` operation.
      BrowseNodeResponse = Structure.new do
        # @return [String] A browse node id is the unique identifier of a given browse node. A browse node is a location
        #   in a browse tree that is used for navigation, product classification, and website content.
        attribute(:browse_node_id, String, null: false, from: "browseNodeId")

        # @return [String] The display name of the browse node as visible on the Amazon retail website.
        attribute(:display_name, String, null: false, from: "displayName")
      end
    end
  end
end

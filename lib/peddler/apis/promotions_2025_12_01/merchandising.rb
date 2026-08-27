# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The merchandising configuration for displaying promotions on the retail website.
      Merchandising = Structure.new do
        # @return [String] Whether the promotion badge and details are displayed on the product detail pages and search
        #   results on the retail website.
        attribute?(:display_on_website, String, from: "displayOnWebsite")
      end
    end
  end
end

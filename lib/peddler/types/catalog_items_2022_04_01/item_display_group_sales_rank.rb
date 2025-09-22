# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # Sales rank of an Amazon catalog item, grouped by website display group.
      ItemDisplayGroupSalesRank = Structure.new do
        # @return [String] Name of the website display group that is associated with the sales rank
        attribute(:website_display_group, String, from: "websiteDisplayGroup")

        # @return [String] Name of the sales rank.
        attribute(:title, String)

        # @return [String] Corresponding Amazon retail website URL for the sales rank.
        attribute(:link, String)

        # @return [Integer] Sales rank.
        attribute(:rank, Integer)
      end
    end
  end
end

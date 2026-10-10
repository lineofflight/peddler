# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Sales rank of an Amazon catalog item, grouped by website display group.
      ItemDisplayGroupSalesRank = Structure.new do
        # Sales rank.
        attribute(:rank, Integer, null: false)

        # Name of the sales rank.
        attribute(:title, String, null: false)

        # Name of the website display group that is associated with the sales rank
        attribute(:website_display_group, String, null: false, from: "websiteDisplayGroup")

        # Corresponding Amazon retail website URL for the sales rank.
        attribute?(:link, String)
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Sales rank of an Amazon catalog item.
      ItemSalesRank = Structure.new do
        # @return [Integer] Sales rank value.
        attribute(:rank, Integer)

        # @return [String] Title, or name, of the sales rank.
        attribute(:title, String)

        # @return [String] Corresponding Amazon retail website link, or URL, for the sales rank.
        attribute?(:link, String)
      end
    end
  end
end

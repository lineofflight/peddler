# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchTerms
      # Contains search term analytics by department name and search term.
      DetailsByDepartmentAndSearchTerm = Structure.new do
        # @return [Float] The fraction of clicks that the product received compared to the total clicks for the
        #   searchTerm within the departmentName for the specified reportPeriod. Multiply the value by 100 to represent
        #   as a percentage.
        attribute(:click_share, Float, null: false, from: "clickShare")

        # @return [Integer] The relative ranking of the clickedAsin based on clickShare.
        attribute(:click_share_rank, Integer, null: false, from: "clickShareRank")

        # @return [String] The Amazon Standard Identification Number of a product that the customer clicked on after
        #   using the searchTerm within a departmentName.
        attribute(:clicked_asin, String, null: false, from: "clickedAsin")

        # @return [Float] The fraction of conversions that the product achieved in comparison to the total conversions
        #   that resulted from the departmentName and searchTerm in the respective reportPeriod. For example, if overall
        #   conversions for searchTerm=batteries was 98, and the conversions for clickedAsin were 13, conversionShare
        #   would be 13/98=0.1327. Multiply by 100 to express as a percentage.
        attribute(:conversion_share, Float, null: false, from: "conversionShare")

        # @return [String] The name of the Amazon search department the searchTerm was searched within. For example,
        #   customers may search across all of Amazon.com or within the Beauty department within Amazon.com.
        attribute(:department_name, String, null: false, from: "departmentName")

        # @return [Integer] The relative ranking of the searchTerm within a departmentName based on frequency of
        #   searches for the specified reportPeriod.
        attribute(:search_frequency_rank, Integer, null: false, from: "searchFrequencyRank")

        # @return [String] The term the customer used when searching for products.
        attribute(:search_term, String, null: false, from: "searchTerm")
      end
    end
  end
end

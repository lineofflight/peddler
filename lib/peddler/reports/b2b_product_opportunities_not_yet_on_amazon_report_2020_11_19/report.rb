# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module B2BProductOpportunitiesNotYetOnAmazonReport20201119
      # Provides B2B product recommendations based on predicted incremental units sold, unmet buyer demand, and other
      # factors for products not yet listed on Amazon. The recommendations are personalized to the seller based on past
      # sales activity.
      Report = Structure.new do
        # @return [Array<Object>] A list of B2B product opportunity recommendation objects.
        attribute(:recommendations, Array)
      end
    end
  end
end

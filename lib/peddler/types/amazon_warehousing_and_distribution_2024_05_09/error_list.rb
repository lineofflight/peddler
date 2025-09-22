# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/error"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # This exception is thrown when client inputs are invalid.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of errors describing the failures.
        attribute(:errors, [Error])
      end
    end
  end
end

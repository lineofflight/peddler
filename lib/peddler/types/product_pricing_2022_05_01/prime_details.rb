# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # Amazon Prime details.
      PrimeDetails = Structure.new do
        # @return [String] Indicates whether the offer is an Amazon Prime offer.
        attribute(:eligibility, String)
      end
    end
  end
end

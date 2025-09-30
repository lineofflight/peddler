# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of proof URLs for a claim. Basic URL validation will happen for each URLs present in the list
      class ClaimProofURLs < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end

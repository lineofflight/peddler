# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Promotion Performance report contains data to help vendors optimize their promotions and adjust their
    # advertising strategies. Currently three promotion types are supported: Best Deal, Lightning Deal, and Price
    # Discount. This report supports start dates up to two years before the current date.
    module Promotion
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class EasyShip20220323
      # A list of package update details.
      class UpdatePackageDetailsList < Array
        class << self
          def parse(array)
            new(array.map { |item| UpdatePackageDetails.parse(item) })
          end
        end
      end
    end
  end
end

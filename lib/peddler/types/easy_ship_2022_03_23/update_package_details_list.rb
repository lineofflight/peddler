# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/update_package_details"

module Peddler
  module Types
    module EasyShip20220323
      # A list of package update details.
      class UpdatePackageDetailsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| UpdatePackageDetails.parse(item) })
          end
        end
      end
    end
  end
end

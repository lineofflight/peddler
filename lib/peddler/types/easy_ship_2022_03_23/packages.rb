# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/package"

module Peddler
  module Types
    module EasyShip20220323
      # A list of packages.
      Packages = Structure.new do
        # @return [Array<Package>] A list of packages.
        attribute(:packages, [Package])
      end
    end
  end
end

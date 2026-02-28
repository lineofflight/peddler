# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # A list of packages.
      Packages = Structure.new do
        # @return [Array<Package>] A list of packages.
        attribute(:packages, [Package], null: false)
      end
    end
  end
end

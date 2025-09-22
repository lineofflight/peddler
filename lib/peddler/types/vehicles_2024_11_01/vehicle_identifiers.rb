# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Vehicles20241101
      # Combination of vehicle standard and id that can uniquely identify a vehicle from Amazon's catalog.
      VehicleIdentifiers = Structure.new do
        # @return [String] Vehicle standard used to uniquely identify a vehicle.
        attribute(:standard, String)

        # @return [String] Id that can uniquely identify a vehicle based the vehicle identification standard.
        attribute(:value, String)
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Vehicles20241101
      # Combination of vehicle standard and id that can uniquely identify a vehicle from Amazon's catalog.
      VehicleIdentifiers = Structure.new do
        # @return [String] Vehicle standard used to uniquely identify a vehicle.
        attribute(:standard, String, null: false)

        # @return [String] Id that can uniquely identify a vehicle based the vehicle identification standard.
        attribute(:value, String, null: false)
      end
    end
  end
end

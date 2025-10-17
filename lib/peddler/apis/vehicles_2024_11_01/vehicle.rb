# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Vehicles20241101
      # Combinations of attributes and unique identifier that represents a vehicle in vehicle list.
      Vehicle = Structure.new do
        # @return [Array<VehicleIdentifiers>] Identifiers that can be used to identify the vehicle uniquely
        attribute(:identifiers, [VehicleIdentifiers])

        # @return [String] Vehicle Brand.
        attribute(:make, String)

        # @return [String] Specific model of a vehicle.
        attribute(:model, String)

        # @return [String] Body style of vehicle (example: Hatchback, Cabriolet).
        attribute?(:body_style, String, from: "bodyStyle")

        # @return [String] Drive type of vehicle(example: Rear wheel drive).
        attribute?(:drive_type, String, from: "driveType")

        # @return [String] Energy Source for the vehicle(example: Petrol)
        attribute?(:energy, String)

        # @return [Array<EngineOutput>] Engine output of vehicle.
        attribute?(:engine_output, [EngineOutput], from: "engineOutput")

        # @return [String] The date on which the vehicle was last updated, in ISO-8601 date/time format.
        attribute?(:last_processed_date, String, from: "lastProcessedDate")

        # @return [MonthAndYear] Vehicle manufacturing start date.
        attribute?(:manufacturing_start_date, MonthAndYear, from: "manufacturingStartDate")

        # @return [MonthAndYear] Vehicle manufacturing stop date. If it is empty, then the vehicle is still being
        #   manufactured.
        attribute?(:manufacturing_stop_date, MonthAndYear, from: "manufacturingStopDate")

        # @return [String] Denotes if the vehicle is active or deleted from Amazon's catalog.
        attribute?(:status, String)

        # @return [String] Name of the vehicle variant.
        attribute?(:variant_name, String, from: "variantName")
      end
    end
  end
end

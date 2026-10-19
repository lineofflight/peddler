# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Vehicles20241101
      # Combinations of attributes and unique identifier that represents a vehicle in vehicle list.
      Vehicle = Structure.new do
        # Identifiers that can be used to identify the vehicle uniquely
        attribute(:identifiers, [VehicleIdentifiers], null: false)

        # Vehicle Brand.
        attribute(:make, String, null: false)

        # Specific model of a vehicle.
        attribute(:model, String, null: false)

        # Body style of vehicle (example: Hatchback, Cabriolet).
        attribute?(:body_style, String, from: "bodyStyle")

        # Drive type of vehicle(example: Rear wheel drive).
        attribute?(:drive_type, String, from: "driveType")

        # Energy Source for the vehicle(example: Petrol)
        attribute?(:energy, String)

        # Engine output of vehicle.
        attribute?(:engine_output, [EngineOutput], from: "engineOutput")

        # The date on which the vehicle was last updated, in ISO-8601 date/time format.
        attribute?(:last_processed_date, String, from: "lastProcessedDate")

        # Vehicle manufacturing start date.
        attribute?(:manufacturing_start_date, MonthAndYear, from: "manufacturingStartDate")

        # Vehicle manufacturing stop date. If it is empty, then the vehicle is still being manufactured.
        attribute?(:manufacturing_stop_date, MonthAndYear, from: "manufacturingStopDate")

        # Denotes if the vehicle is active or deleted from Amazon's catalog. Known values: `ACTIVE`, `DELETED`.
        attribute?(:status, String)

        # Name of the vehicle variant.
        attribute?(:variant_name, String, from: "variantName")
      end
    end
  end
end

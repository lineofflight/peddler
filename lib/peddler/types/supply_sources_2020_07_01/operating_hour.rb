# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The operating hour schema
      OperatingHour = Structure.new do
        # @return [String] The opening time, ISO 8601 formatted timestamp without date, HH:mm.
        attribute(:start_time, String, from: "startTime")

        # @return [String] The closing time, ISO 8601 formatted timestamp without date, HH:mm.
        attribute(:end_time, String, from: "endTime")
      end
    end
  end
end

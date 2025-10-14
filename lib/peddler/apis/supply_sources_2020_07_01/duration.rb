# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The duration of time.
      Duration = Structure.new do
        # @return [String]
        attribute?(:time_unit, String, from: "timeUnit")

        # @return [Integer]
        attribute?(:value, Integer)
      end
    end
  end
end

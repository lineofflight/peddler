# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The duration of time.
      Duration = Structure.new do
        # @return [Integer]
        attribute?(:value, Integer)

        # @return [String]
        attribute?(:time_unit, String, from: "timeUnit")
      end
    end
  end
end

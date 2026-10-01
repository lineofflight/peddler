# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # The inputs used to calculate a promise date.
      PromiseCalculationInputs = Structure.new do
        # @return [TransitTimeInput] The transit time used to calculate the promise date.
        attribute?(:transit_time, TransitTimeInput, from: "transitTime")
      end
    end
  end
end

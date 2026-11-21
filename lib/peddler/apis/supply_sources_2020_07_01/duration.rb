# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The duration of time.
      Duration = Structure.new do
        # Known values: `Hours`, `Minutes`, `Days`.
        attribute?(:time_unit, String, from: "timeUnit")

        attribute?(:value, Integer)
      end
    end
  end
end

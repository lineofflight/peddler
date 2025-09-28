# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/operating_hour"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module SupplySources20200701
      # A list of Operating Hours.
      class OperatingHours < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| OperatingHour.parse(item) }) : new
          end
        end
      end
    end
  end
end

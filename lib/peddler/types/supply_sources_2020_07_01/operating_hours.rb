# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/operating_hour"

module Peddler
  module Types
    module SupplySources20200701
      # A list of Operating Hours.
      class OperatingHours < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OperatingHour.parse(item) })
          end
        end
      end
    end
  end
end

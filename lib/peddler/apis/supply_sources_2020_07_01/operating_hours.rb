# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class SupplySources20200701
      # A list of Operating Hours.
      class OperatingHours < Array
        class << self
          def parse(array)
            new(array.map { |item| OperatingHour.parse(item) })
          end
        end
      end
    end
  end
end

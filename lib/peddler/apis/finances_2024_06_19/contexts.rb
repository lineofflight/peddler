# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Finances20240619
      # List of additional Information about the item.
      class Contexts < Array
        class << self
          def parse(array)
            new(array.map { |item| Context.parse(item) })
          end
        end
      end
    end
  end
end

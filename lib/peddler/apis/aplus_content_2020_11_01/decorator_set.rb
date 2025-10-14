# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A set of content decorators.
      class DecoratorSet < Array
        class << self
          def parse(array)
            new(array.map { |item| Decorator.parse(item) })
          end
        end
      end
    end
  end
end

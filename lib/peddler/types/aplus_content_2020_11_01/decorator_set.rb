# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/decorator"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
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

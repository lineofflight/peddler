# frozen_string_literal: true

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # String list
      class StringList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end

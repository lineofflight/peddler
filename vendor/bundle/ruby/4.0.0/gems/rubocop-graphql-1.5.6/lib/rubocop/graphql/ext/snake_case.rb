# frozen_string_literal: true

module RuboCop
  module GraphQL
    module Ext
      module SnakeCase
        SNAKE_CASE = /^[\da-z_]+[!?=]?$/

        refine Symbol do
          def snake_case?
            match?(SNAKE_CASE)
          end
        end
      end
    end
  end
end

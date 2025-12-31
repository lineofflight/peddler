# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Detects missing max_complexity configuration in schema files
      #
      # @example
      #   # good
      #
      #   class AppSchema < BaseSchema
      #     max_complexity 42
      #   end
      #
      class MaxComplexitySchema < Base
        # @!method max_complexity(node)
        def_node_matcher :max_complexity, <<~PATTERN
          `(send nil? :max_complexity ...)
        PATTERN

        MSG = "max_complexity should be configured for schema."

        def on_class(node)
          return if ::RuboCop::GraphQL::Class.new(node).nested? || max_complexity(node)

          add_offense(node)
        end
      end
    end
  end
end

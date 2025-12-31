# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Detects missing max_depth configuration in schema files
      #
      # @example
      #   # good
      #
      #   class AppSchema < BaseSchema
      #     max_depth 42
      #   end
      #
      class MaxDepthSchema < Base
        # @!method max_depth(node)
        def_node_matcher :max_depth, <<~PATTERN
          `(send nil? :max_depth ...)
        PATTERN

        MSG = "max_depth should be configured for schema."

        def on_class(node)
          return if ::RuboCop::GraphQL::Class.new(node).nested? || max_depth(node)

          add_offense(node)
        end
      end
    end
  end
end

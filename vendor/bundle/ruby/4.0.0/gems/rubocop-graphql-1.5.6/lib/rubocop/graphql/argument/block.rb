# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Argument
      class Block
        extend RuboCop::NodePattern::Macros
        include DescriptionMethod

        # @!method argument_block(node)
        def_node_matcher :argument_block, <<~PATTERN
          (block
            (send nil? :argument ...)
            (args ...)
            {(begin $...)|$...}
          )
        PATTERN

        def initialize(argument_node)
          @nodes = argument_block(argument_node) || []
        end

        def description
          find_description_method(@nodes)
        end
      end
    end
  end
end

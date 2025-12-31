# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Argument
      class Kwargs
        extend RuboCop::NodePattern::Macros

        # @!method argument_kwargs(node)
        def_node_matcher :argument_kwargs, <<~PATTERN
          (send nil? :argument
            ...
            (hash
              $...
            )
          )
        PATTERN

        # @!method description_kwarg?(node)
        def_node_matcher :description_kwarg?, <<~PATTERN
          (pair (sym :description) ...)
        PATTERN

        # @!method loads_kwarg?(node)
        def_node_matcher :loads_kwarg?, <<~PATTERN
          (pair (sym :loads) ...)
        PATTERN

        # @!method as_kwarg?(node)
        def_node_matcher :as_kwarg?, <<~PATTERN
          (pair (sym :as) ...)
        PATTERN

        # @!method camelize_kwarg?(node)
        def_node_matcher :camelize_kwarg?, <<~PATTERN
          (pair (sym :camelize) ...)
        PATTERN

        def initialize(argument_node)
          @nodes = argument_kwargs(argument_node) || []
        end

        def description
          @nodes.find { |kwarg| description_kwarg?(kwarg) }
        end

        def camelize
          @nodes.find { |kwarg| camelize_kwarg?(kwarg) }
        end

        def loads
          @nodes.find { |kwarg| loads_kwarg?(kwarg) }
        end

        def as
          @nodes.find { |kwarg| as_kwarg?(kwarg) }
        end
      end
    end
  end
end

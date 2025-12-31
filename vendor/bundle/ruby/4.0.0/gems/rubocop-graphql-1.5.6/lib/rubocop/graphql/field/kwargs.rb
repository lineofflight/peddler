# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Field
      class Kwargs
        extend RuboCop::NodePattern::Macros

        # @!method field_kwargs(node)
        def_node_matcher :field_kwargs, <<~PATTERN
          (send nil? :field
            ...
            (hash
              $...
            )
          )
        PATTERN

        # @!method resolver_kwarg?(node)
        def_node_matcher :resolver_kwarg?, <<~PATTERN
          (pair (sym :resolver) ...)
        PATTERN

        # @!method method_kwarg?(node)
        def_node_matcher :method_kwarg?, <<~PATTERN
          (pair (sym :method) ...)
        PATTERN

        # @!method alias_kwarg(node)
        def_node_matcher :alias_kwarg, <<~PATTERN
          (pair (sym :alias) (sym $ _))
        PATTERN

        # @!method hash_key_kwarg?(node)
        def_node_matcher :hash_key_kwarg?, <<~PATTERN
          (pair (sym :hash_key) ...)
        PATTERN

        # @!method description_kwarg?(node)
        def_node_matcher :description_kwarg?, <<~PATTERN
          (pair (sym :description) ...)
        PATTERN

        # @!method resolver_method_option(node)
        def_node_matcher :resolver_method_option, <<~PATTERN
          (pair (sym :resolver_method) (sym $...))
        PATTERN

        # @!method camelize_kwarg?(node)
        def_node_matcher :camelize_kwarg?, <<~PATTERN
          (pair (sym :camelize) ...)
        PATTERN

        def initialize(field_node)
          @nodes = field_kwargs(field_node) || []
        end

        def resolver
          @nodes.find { |kwarg| resolver_kwarg?(kwarg) }
        end

        def method
          @nodes.find { |kwarg| method_kwarg?(kwarg) }
        end

        def alias
          @alias ||= @nodes.map { |kwarg| alias_kwarg(kwarg) }.compact.first
        end

        def camelize
          @nodes.find { |kwarg| camelize_kwarg?(kwarg) }
        end

        def hash_key
          @nodes.find { |kwarg| hash_key_kwarg?(kwarg) }
        end

        def description
          @nodes.find { |kwarg| description_kwarg?(kwarg) }
        end

        def resolver_method_name
          @resolver_method_name ||=
            @nodes.flat_map { |kwarg| resolver_method_option(kwarg) }.compact.first
        end
      end
    end
  end
end

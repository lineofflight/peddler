# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks if a type (object, input, interface, scalar, union,
      #  mutation, subscription, and resolver) has a description.
      #
      # @example
      #   # good
      #
      #   class Types::UserType < Types::BaseObject
      #     description "Represents application user"
      #     # ...
      #   end
      #
      #   # bad
      #
      #   class Types::UserType < Types::BaseObject
      #     # ...
      #   end
      #
      class ObjectDescription < Base
        include RuboCop::GraphQL::NodePattern
        include RuboCop::GraphQL::DescriptionMethod

        MSG = "Missing type description"

        # @!method interface?(node)
        def_node_matcher :interface?, <<~PATTERN
          (send nil? :include (const ...))
        PATTERN

        def on_class(node)
          return if child_nodes(node).find { |child_node| has_description?(child_node) }

          add_offense(node.identifier)
        end

        def on_module(node)
          return if child_nodes(node).none? { |child_node| interface?(child_node) }

          if child_nodes(node).none? { |child_node| has_description?(child_node) }
            add_offense(node.identifier)
          end
        end

        private

        def has_description?(node)
          description_method_call?(node)
        end

        def child_nodes(node)
          if node.body.instance_of? RuboCop::AST::Node
            node.body.child_nodes
          else
            node.child_nodes
          end
        end
      end
    end
  end
end

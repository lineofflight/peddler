# frozen_string_literal: true

module RuboCop
  module GraphQL
    module NodePattern
      extend RuboCop::NodePattern::Macros

      # @!method field_definition?(node)
      def_node_matcher :field_definition?, <<~PATTERN
        (send nil? :field (:sym _) ...)
      PATTERN

      # @!method field_definition_with_body?(node)
      def_node_matcher :field_definition_with_body?, <<~PATTERN
        (block
          (send nil? :field (:sym _) ...)
          ...
        )
      PATTERN

      # @!method argument?(node)
      def_node_matcher :argument?, <<~PATTERN
        (send nil? :argument (:sym _) ...)
      PATTERN

      def field?(node)
        field_definition?(node) || field_definition_with_body?(node)
      end
    end
  end
end

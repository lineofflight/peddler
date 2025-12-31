# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Argument
      extend RuboCop::NodePattern::Macros

      # @!method argument_description(node)
      def_node_matcher :argument_description, <<~PATTERN
        (send nil? :argument _ _ (:str $_) ...)
      PATTERN

      # @!method argument_name(node)
      def_node_matcher :argument_name, <<~PATTERN
        (send nil? :argument (:sym $_) ...)
      PATTERN

      # @!method argument_as(node)
      def_node_matcher :argument_as, <<~PATTERN
        (pair (sym :as) (sym $_))
      PATTERN

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def name
        @name ||= argument_name(@node)
      end

      def as
        @as ||= argument_as(kwargs.as)
      end

      def description
        @description ||= argument_description(@node) || kwargs.description || block.description
      end

      def kwargs
        @kwargs ||= Argument::Kwargs.new(@node)
      end

      def block
        @block ||= Argument::Block.new(@node.parent)
      end
    end
  end
end

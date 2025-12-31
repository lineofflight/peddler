# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Class
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def nested?
        node.each_ancestor(:class).any?
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module GraphQL
    module Sorbet
      extend RuboCop::NodePattern::Macros

      # @!method sorbet_signature(node)
      def_node_matcher(:sorbet_signature, <<~PATTERN)
        (block (send nil? :sig) (args) ...)
      PATTERN

      def has_sorbet_signature?(node)
        !!sorbet_signature_for(node)
      end

      def sorbet_signature_for(node)
        sibling = node.left_sibling
        sibling if sibling && sorbet_signature(sibling)
      end
    end
  end
end

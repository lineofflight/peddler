# frozen_string_literal: true

module RuboCop
  module GraphQL
    # Matches a variety of description formats commonly seen in Rails applications
    #
    #   description 'blah'
    #
    #   description "blah"
    #
    #   description <<~EOT
    #      blah
    #      bloop
    #   EOT
    #
    #   description <<-EOT.squish
    #      blah
    #      bloop
    #   EOT
    module DescriptionMethod
      extend RuboCop::NodePattern::Macros

      DESCRIPTION_STRING = "{str|dstr|const|send}"

      # @!method description_method_call?(node)
      def_node_matcher :description_method_call?, <<~PATTERN
        (send nil? :description #{DESCRIPTION_STRING})
      PATTERN

      # @!method description_with_block_arg?(node)
      def_node_matcher :description_with_block_arg?, <<~PATTERN
        (send (lvar _) {:description= :description} #{DESCRIPTION_STRING})
      PATTERN

      def find_description_method(nodes)
        nodes.find { |kwarg| description_method_call?(kwarg) || description_with_block_arg?(kwarg) }
      end
    end
  end
end

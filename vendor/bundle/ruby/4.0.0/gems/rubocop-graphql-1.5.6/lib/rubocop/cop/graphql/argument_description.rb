# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks if each field has a description.
      #
      # @example
      #   # good
      #
      #   class BanUser < BaseMutation
      #     argument :uuid, ID, required: true, description: "UUID of the user to ban"
      #   end
      #
      #   # bad
      #
      #   class BanUser < BaseMutation
      #     argument :uuid, ID, required: true
      #   end
      #
      class ArgumentDescription < Base
        include RuboCop::GraphQL::NodePattern

        MSG = "Missing argument description"
        RESTRICT_ON_SEND = %i[argument].freeze

        def on_send(node)
          return unless argument?(node)

          argument = RuboCop::GraphQL::Argument.new(node)

          add_offense(node) unless argument.description
        end
      end
    end
  end
end

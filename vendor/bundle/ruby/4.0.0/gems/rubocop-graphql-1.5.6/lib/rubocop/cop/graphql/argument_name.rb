# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks whether field names are snake_case.
      #
      # @example
      #   # good
      #
      #   class BanUser < BaseMutation
      #     argument :user_id, ID, required: true
      #   end
      #
      #   # bad
      #
      #   class BanUser < BaseMutation
      #     argument :userId, ID, required: true
      #   end
      #
      class ArgumentName < Base
        include RuboCop::GraphQL::NodePattern
        RESTRICT_ON_SEND = %i[argument].freeze

        using RuboCop::GraphQL::Ext::SnakeCase

        MSG = "Use snake_case for argument names"

        def on_send(node)
          return unless argument?(node)

          argument = RuboCop::GraphQL::Argument.new(node)
          return if argument.name.snake_case?

          add_offense(node)
        end
      end
    end
  end
end

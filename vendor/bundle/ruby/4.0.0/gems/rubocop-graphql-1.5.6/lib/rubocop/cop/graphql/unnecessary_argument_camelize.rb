# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks if each argument has an unnecessary camelize.
      #
      # @example
      #   # good
      #
      #   class UserType < BaseType
      #     field :name, String, "Name of the user", null: true do
      #       argument :filter, String, required: false
      #     end
      #   end
      #
      #   # good
      #
      #   class UserType < BaseType
      #     argument :filter, String, required: false
      #   end
      #
      #   # good
      #
      #   class UserType < BaseType
      #     argument :email_filter, String, required: false, camelize: true
      #   end
      #
      #  # bad
      #
      #   class UserType < BaseType
      #     argument :filter, String, required: false, camelize: false
      #   end
      #
      #  # bad
      #
      #   class UserType < BaseType
      #     field :name, String, "Name of the user", null: true do
      #       argument :filter, String, required: false, camelize: false
      #     end
      #   end
      #
      class UnnecessaryArgumentCamelize < Base
        include RuboCop::GraphQL::NodePattern

        MSG = "Unnecessary argument camelize"
        RESTRICT_ON_SEND = %i[argument].freeze

        def on_send(node)
          return unless argument?(node)

          argument = RuboCop::GraphQL::Argument.new(node)

          if argument.name.to_s.split("_").length < 2 && !argument.kwargs.camelize.nil?
            add_offense(node)
          end
        end
      end
    end
  end
end

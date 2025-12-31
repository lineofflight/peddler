# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks if each field has an unnecessary camelize.
      #
      # @example
      #   # good
      #
      #   class UserType < BaseType
      #     field :name, String, "Name of the user", null: true
      #   end
      #
      #   # bad
      #
      #   class UserType < BaseType
      #     field :name, "Name of the user", String, null: true, camelize: true
      #   end
      #
      class UnnecessaryFieldCamelize < Base
        include RuboCop::GraphQL::NodePattern

        MSG = "Unnecessary field camelize"
        RESTRICT_ON_SEND = %i[field].freeze

        def on_send(node)
          return unless field_definition?(node)

          field = RuboCop::GraphQL::Field.new(node)

          add_offense(node) if field.name.to_s.split("_").length < 2 && !field.kwargs.camelize.nil?
        end
      end
    end
  end
end

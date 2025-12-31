# frozen_string_literal: true

require_relative "../../../refinements/underscore_string"

using UnderscoreString unless String.method_defined?(:underscore)

module RuboCop
  module Cop
    module GraphQL
      #  This cop checks whether field names are snake_case.
      #
      # @example
      #   # good
      #
      #   class UserType < BaseType
      #     field :first_name, String, null: true
      #   end
      #
      #   # bad
      #
      #   class UserType < BaseType
      #     field :firstName, String, null: true
      #   end
      #
      class FieldName < Base
        extend AutoCorrector
        include RuboCop::GraphQL::NodePattern

        using RuboCop::GraphQL::Ext::SnakeCase

        MSG = "Use snake_case for field names"
        RESTRICT_ON_SEND = %i[field].freeze

        def on_send(node)
          return unless field_definition?(node)

          field = RuboCop::GraphQL::Field.new(node)
          return if field.name.snake_case?

          add_offense(node) do |corrector|
            rename_field_name(corrector, field, node)
          end
        end

        private

        def rename_field_name(corrector, field, node)
          name_field = field.name.to_s
          new_line = node.source.sub(name_field, name_field.underscore)
          corrector.replace(node, new_line)
        end
      end
    end
  end
end

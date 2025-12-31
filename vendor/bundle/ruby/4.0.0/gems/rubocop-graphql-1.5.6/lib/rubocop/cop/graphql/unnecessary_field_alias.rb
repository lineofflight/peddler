# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop prevents defining an unnecessary alias, method, or resolver_method.
      #
      # @example
      #   # good
      #
      #   field :name, String, "Name of the user", null: true, alias: :real_name
      #   field :name, String, "Name of the user", null: true, method: :real_name
      #   field :name, String, "Name of the user", null: true, resolver_method: :real_name
      #   field :name, String, "Name of the user", null: true, hash_key: :real_name
      #
      #   # bad
      #
      #   field :name, "Name of the user" String, null: true, alias: :name
      #   field :name, String, "Name of the user", null: true, method: :name
      #   field :name, String, "Name of the user", null: true, resolver_method: :name
      #   field :name, String, "Name of the user", null: true, hash_key: :name
      #
      class UnnecessaryFieldAlias < Base
        extend AutoCorrector
        include RuboCop::GraphQL::NodePattern

        MSG = "Unnecessary :%<kwarg>s configured"
        RESTRICT_ON_SEND = %i[field].freeze

        def on_send(node)
          return unless field_definition?(node)

          field = RuboCop::GraphQL::Field.new(node)

          if (unnecessary_kwarg = validate_kwargs(field))
            message = format(self.class::MSG, kwarg: unnecessary_kwarg)
            add_offense(node, message: message) do |corrector|
              kwarg_node = node.last_argument.pairs.find do |pair|
                pair.key.value == unnecessary_kwarg.to_sym
              end
              corrector.remove_preceding(kwarg_node, 2)
              corrector.remove(kwarg_node)
            end
          end
        end

        private

        def validate_kwargs(field) # rubocop:disable Metrics/CyclomaticComplexity
          case field.name
          when field.kwargs.alias then "alias"
          when field.kwargs.method&.value&.value then "method"
          when field.kwargs.resolver_method_name then "resolver_method"
          when field.kwargs.hash_key&.value&.value then "hash_key"
          end
        end
      end
    end
  end
end

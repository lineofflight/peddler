# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop prevents defining unnecessary resolver methods in cases
      #  when :method option can be used
      #
      # @example
      #   # good
      #
      #   class Types::UserType < Types::BaseObject
      #     field :phone, String, null: true, method: :home_phone
      #   end
      #
      #   # bad
      #
      #   class Types::UserType < Types::BaseObject
      #     field :phone, String, null: true
      #
      #     def phone
      #       object.home_phone
      #     end
      #   end
      #
      class FieldMethod < Base
        extend AutoCorrector
        include RuboCop::GraphQL::NodePattern
        include RuboCop::Cop::RangeHelp

        # @!method method_to_use(node)
        def_node_matcher :method_to_use, <<~PATTERN
          (def
            _
            (args)
            (send
              (send nil? :object) $_
            )
          )
        PATTERN

        MSG = "Use method: :%<method_name>s"
        RESTRICT_ON_SEND = %i[field].freeze

        def on_send(node)
          return unless field_definition?(node)

          field = RuboCop::GraphQL::Field.new(node)
          method_definition = suggest_method_name_for(field)

          suggested_method_name = method_to_use(method_definition)

          return if suggested_method_name.nil?
          return if RuboCop::GraphQL::Field::CONFLICT_FIELD_NAMES.include?(suggested_method_name)
          return if method_kwarg_set?(field)

          add_offense(node, message: message(suggested_method_name)) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        def message(method_name)
          format(MSG, method_name: method_name)
        end

        def autocorrect(corrector, node)
          field = RuboCop::GraphQL::Field.new(node)
          method_definition = suggest_method_name_for(field)
          suggested_method_name = method_to_use(method_definition)

          corrector.insert_after(node, ", method: :#{suggested_method_name}")

          range = range_with_surrounding_space(
            range: method_definition.source_range, side: :left
          )
          corrector.remove(range)
        end

        def suggest_method_name_for(field)
          method_name = field.resolver_method_name
          field.schema_member.find_method_definition(method_name)
        end

        def method_kwarg_set?(field)
          field.kwargs.method != nil
        end
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      #  This cop prevents defining unnecessary resolver methods in cases
      #  when :hash_key option can be used
      #
      # @example
      #   # good
      #
      #   class Types::UserType < Types::BaseObject
      #     field :phone, String, null: true, hash_key: :home_phone
      #   end
      #
      #   # bad
      #
      #   class Types::UserType < Types::BaseObject
      #     field :phone, String, null: true
      #
      #     def phone
      #       object[:home_phone]
      #     end
      #   end
      #
      class FieldHashKey < Base
        extend AutoCorrector
        include RuboCop::GraphQL::NodePattern
        include RuboCop::Cop::RangeHelp

        # @!method hash_key_to_use(node)
        def_node_matcher :hash_key_to_use, <<~PATTERN
          (def
            _
            (args)
            (send
              (send nil? :object) :[]
              ({sym str} $_)
            )
          )
        PATTERN

        MSG = "Use hash_key: %<hash_key>p"
        RESTRICT_ON_SEND = %i[field].freeze

        def on_send(node)
          return unless field_definition?(node)

          field = RuboCop::GraphQL::Field.new(node)
          method_definition = resolver_method_definition_for(field)

          suggested_hash_key_name = hash_key_to_use(method_definition)

          return if suggested_hash_key_name.nil?
          return if conflict?(suggested_hash_key_name)

          add_offense(node, message: message(suggested_hash_key_name)) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        def conflict?(suggested_hash_key_name)
          RuboCop::GraphQL::Field::CONFLICT_FIELD_NAMES.include?(suggested_hash_key_name.to_sym)
        end

        def message(hash_key)
          format(MSG, hash_key: hash_key)
        end

        def autocorrect(corrector, node)
          field = RuboCop::GraphQL::Field.new(node)
          method_definition = resolver_method_definition_for(field)
          suggested_hash_key_name = hash_key_to_use(method_definition)

          corrector.insert_after(
            node, ", hash_key: #{suggested_hash_key_name.inspect}"
          )

          range = range_with_surrounding_space(
            range: method_definition.source_range, side: :left
          )

          corrector.remove(range)
        end

        def resolver_method_definition_for(field)
          method_name = field.resolver_method_name
          field.schema_member.find_method_definition(method_name)
        end
      end
    end
  end
end

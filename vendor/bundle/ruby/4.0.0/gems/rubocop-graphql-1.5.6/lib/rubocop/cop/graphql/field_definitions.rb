# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Checks consistency of field definitions
      #
      # EnforcedStyle supports two modes:
      #
      # `group_definitions` : all field definitions should be grouped together.
      #
      # `define_resolver_after_definition` : if resolver method exists it should
      # be defined right after the field definition.
      #
      # @example EnforcedStyle: group_definitions (default)
      #   # good
      #
      #   class UserType < BaseType
      #     field :first_name, String, null: true
      #     field :last_name, String, null: true
      #
      #     def first_name
      #       object.contact_data.first_name
      #     end
      #
      #     def last_name
      #       object.contact_data.last_name
      #     end
      #   end
      #
      # @example EnforcedStyle: define_resolver_after_definition
      #   # good
      #
      #   class UserType < BaseType
      #     field :first_name, String, null: true
      #
      #     def first_name
      #       object.contact_data.first_name
      #     end
      #
      #     field :last_name, String, null: true
      #
      #     def last_name
      #       object.contact_data.last_name
      #     end
      #   end
      class FieldDefinitions < Base # rubocop:disable Metrics/ClassLength
        extend AutoCorrector
        include ConfigurableEnforcedStyle
        include CommentsHelp
        include RuboCop::GraphQL::NodePattern
        include RuboCop::Cop::RangeHelp
        include RuboCop::GraphQL::Sorbet
        include RuboCop::GraphQL::Heredoc

        RESTRICT_ON_SEND = %i[field].freeze

        # @!method field_kwargs(node)
        def_node_matcher :field_kwargs, <<~PATTERN
          (send nil? :field
            ...
            (hash
              $...
            )
          )
        PATTERN

        def on_send(node)
          return if !field?(node) || style != :define_resolver_after_definition

          node = node.parent if field_definition_with_body?(node.parent)
          field = RuboCop::GraphQL::Field.new(node)
          check_resolver_is_defined_after_definition(field)
        end

        def on_class(node)
          return if style != :group_definitions

          schema_member = RuboCop::GraphQL::SchemaMember.new(node)

          if (body = schema_member.body)
            check_grouped_field_declarations(body)
          end
        end

        def on_module(node)
          return if style != :group_definitions

          schema_member = RuboCop::GraphQL::SchemaMember.new(node)

          if (body = schema_member.body)
            check_grouped_field_declarations(body)
          end
        end

        private

        GROUP_DEFS_MSG = "Group all field definitions together."

        def check_grouped_field_declarations(body)
          fields = body.select { |node| field?(node) }

          first_field = fields.first

          fields.each_with_index do |node, idx|
            next if node.sibling_index == first_field.sibling_index + idx

            add_offense(node, message: GROUP_DEFS_MSG) do |corrector|
              group_field_declarations(corrector, node)
            end
          end
        end

        def group_field_declarations(corrector, node)
          field = RuboCop::GraphQL::Field.new(node)
          first_field = field.schema_member.body.find do |node|
            field_definition?(node) || field_definition_with_body?(node)
          end

          insert_new_resolver(corrector, first_field, node)

          remove_old_resolver(corrector, node)
        end

        RESOLVER_AFTER_FIELD_MSG = "Define resolver method after field definition."
        RESOLVER_AFTER_LAST_FIELD_MSG = "Define resolver method after last field definition " \
          "sharing resolver method."

        def check_resolver_is_defined_after_definition(field)
          multiple_definitions = multiple_definitions(field)
          return if field.node != multiple_definitions.last

          return if field_has_no_resolver_method(field)

          method_definition = field.schema_member.find_method_definition(field.resolver_method_name)
          return unless method_definition

          fields_with_same_resolver = fields_with_same_resolver(field, method_definition)
          return unless field.name == fields_with_same_resolver.last.name

          return if resolver_defined_after_definition?(field, method_definition)

          add_offense(field.node,
                      message: offense_message(
                        fields_with_same_resolver.one? && multiple_definitions.size == 1
                      )) do |corrector|
            place_resolver_after_field_definition(corrector, field.node)
          end
        end

        def field_has_no_resolver_method(field)
          field.kwargs.resolver || field.kwargs.method || field.kwargs.hash_key
        end

        def multiple_definitions(field)
          field.schema_member.body.select { |node| field?(node) && field_name(node) == field.name }
        end

        def field_name(node)
          RuboCop::GraphQL::Field.new(node).name
        end

        def offense_message(single_field_using_resolver)
          single_field_using_resolver ? RESOLVER_AFTER_FIELD_MSG : RESOLVER_AFTER_LAST_FIELD_MSG
        end

        def resolver_defined_after_definition?(field, method_definition)
          field_sibling_index =
            if field_definition_with_body?(field.parent)
              field.parent.sibling_index
            else
              field.sibling_index
            end

          field_to_resolver_offset = method_definition.sibling_index - field_sibling_index

          case field_to_resolver_offset
          when 1 # resolver is immediately after field definition
            return true
          when 2 # there is a node between the field definition and its resolver
            return true if has_sorbet_signature?(method_definition)
          end

          false
        end

        def fields_with_same_resolver(field, resolver)
          fields = field.schema_member.body
                        .select { |node| field?(node) }
                        .map { |node| RuboCop::GraphQL::Field.new(node) }

          [].tap do |fields_with_same_resolver|
            fields.each do |field|
              return [field] if field.name == resolver.method_name
              next if field.kwargs.resolver_method_name != resolver.method_name

              fields_with_same_resolver << field
            end
          end
        end

        def place_resolver_after_field_definition(corrector, node)
          field = RuboCop::GraphQL::Field.new(node)

          resolver_method_name = field.resolver_method_name
          resolver_definition = field.schema_member.find_method_definition(resolver_method_name)

          field_definition = field_definition_with_body?(node.parent) ? node.parent : node

          insert_new_resolver(corrector, field_definition, resolver_definition)

          remove_old_resolver(corrector, resolver_definition)
        end

        def insert_new_resolver(corrector, field_definition, resolver_definition)
          resolver_definition_range = source_range_with_comment(resolver_definition)
          source_to_insert =
            "\n#{signature_to_insert(resolver_definition)}\n" \
              "#{indent(resolver_definition)}#{resolver_definition_range.source.strip}\n"

          field_definition_range = range_including_heredoc(field_definition)
          corrector.insert_after(field_definition_range, source_to_insert)
        end

        def remove_old_resolver(corrector, resolver_definition)
          resolver_definition_range = source_range_with_comment(resolver_definition)
          range_to_remove = range_with_surrounding_space(
            range: resolver_definition_range, side: :left
          )
          corrector.remove(range_to_remove)

          resolver_signature = sorbet_signature_for(resolver_definition)

          return unless resolver_signature

          resolver_signature_range = source_range_with_comment(resolver_signature)
          range_to_remove = range_with_surrounding_space(
            range: resolver_signature_range, side: :left
          )
          corrector.remove(range_to_remove)
        end

        def signature_to_insert(node)
          signature = sorbet_signature_for(node)

          return unless signature

          range = source_range_with_comment(signature)
          "\n#{indent(signature)}#{range.source.strip}"
        end

        def indent(node)
          " " * node.location.column
        end
      end
    end
  end
end

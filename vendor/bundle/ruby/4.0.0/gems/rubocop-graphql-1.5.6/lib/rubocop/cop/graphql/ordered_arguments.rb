# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Arguments should be alphabetically sorted within groups.
      #
      # @example
      #   # good
      #
      #   class UpdateProfile < BaseMutation
      #     argument :email, String, required: false
      #     argument :name, String, required: false
      #   end
      #
      #   # good
      #
      #   class UpdateProfile < BaseMutation
      #     argument :uuid, ID, required: true
      #
      #     argument :email, String, required: false
      #     argument :name, String, required: false
      #   end
      #
      #   # good
      #
      #   class UserType < BaseType
      #     field :posts, PostType do
      #       argument :created_after, ISO8601DateTime, required: false
      #       argument :created_before, ISO8601DateTime, required: false
      #     end
      #   end
      #
      #   # bad
      #
      #   class UpdateProfile < BaseMutation
      #     argument :uuid, ID, required: true
      #     argument :name, String, required: false
      #     argument :email, String, required: false
      #   end
      #
      #   # bad
      #
      #   class UserType < BaseType
      #     field :posts, PostType do
      #       argument :created_before, ISO8601DateTime, required: false
      #       argument :created_after, ISO8601DateTime, required: false
      #     end
      #   end
      #
      class OrderedArguments < Base
        extend AutoCorrector

        include RuboCop::GraphQL::SwapRange
        include RuboCop::GraphQL::CompareOrder

        MSG = "Arguments should be sorted in an alphabetical order within their section. " \
              "Field `%<current>s` should appear before `%<previous>s`."

        def on_class(node)
          # Do a single pass over descendants to get argument declarations
          # with and without a block.
          argument_declarations = argument_declaration(node).map do |declaration|
            if argument_declaration_with_block?(declaration)
              declaration.parent
            else
              declaration
            end
          end

          argument_declarations.each_cons(2) do |previous, current|
            next unless consecutive_lines(previous, current)
            next if correct_order?(argument_name(previous), argument_name(current))

            register_offense(previous, current)
          end
        end

        private

        def argument_declaration_with_block?(node)
          node.parent&.block_type? && node.parent.send_node == node
        end

        def register_offense(previous, current)
          message = format(
            self.class::MSG,
            previous: argument_name(previous),
            current: argument_name(current)
          )

          add_offense(current, message: message) do |corrector|
            swap_range(corrector, current, previous)
          end
        end

        def argument_name(node)
          argument = node.block_type? ? node.children.first.first_argument : node.first_argument

          argument.value.to_s
        end

        def consecutive_lines(previous, current)
          previous.source_range.last_line == current.source_range.first_line - 1
        end

        # @!method argument_declaration(node)
        def_node_search :argument_declaration, <<~PATTERN
          (send nil? :argument (:sym _) ...)
        PATTERN
      end
    end
  end
end

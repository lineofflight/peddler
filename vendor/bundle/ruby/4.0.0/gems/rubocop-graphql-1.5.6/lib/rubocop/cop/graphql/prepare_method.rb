# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GraphQL
      # Checks that GraphQL Argument definitions prepare arguments use String or constants
      # instead of `prepare: CONST_REF`
      # This allows better Sorbet typing.
      #
      # Preference is given to an input object declaring a `def prepare(...); end` method
      #
      # @example
      #   # bad
      #   PREPARE = ->(input, context) { ... }
      #
      #   argument :input, prepare: PREPARE
      #
      #   # good
      #   def input_prepare(input); ...; end
      #
      #   argument :input, prepare: :input_prepare
      #
      class PrepareMethod < RuboCop::Cop::Base
        extend AutoCorrector
        GENERAL_MSG = "Avoid using prepare lambdas, use prepare: :method_name or "\
          "prepare: \"method_name\" instead."
        STRING_MSG = "Avoid using prepare lambdas, use prepare: \"method_name\" instead."
        PREFER_STRING_MSG = "Avoid using prepare symbols, use prepare: \"%s\" instead."
        SYMBOL_MSG = "Avoid using prepare lambdas, use prepare: :method_name instead."
        PREFER_SYMBOL_MSG = "Avoid using prepare string, use prepare: :%s instead."

        ARGUMENT_METHODS = Set[:argument, :public_argument].freeze

        # @!method graphql_argument_with_prepare_block?(node)
        def_node_matcher :graphql_argument_with_prepare_block?, <<~PATTERN
          (send nil? ARGUMENT_METHODS ... (hash ... (pair (sym :prepare) $({ const | block } ...) )))
        PATTERN

        # @!method prepare_method_string_name?(node)
        def_node_matcher :prepare_method_string_name?, <<~PATTERN
          (send nil? ARGUMENT_METHODS ... (hash ... (pair (sym :prepare) $(str ...) )))
        PATTERN

        # @!method prepare_method_symbol_name?(node)
        def_node_matcher :prepare_method_symbol_name?, <<~PATTERN
          (send nil? ARGUMENT_METHODS ... (hash ... (pair (sym :prepare) $(sym ...) )))
        PATTERN

        def on_send(node)
          type = cop_config["EnforcedStyle"]

          message = case type
                    when "symbol"
                      SYMBOL_MSG
                    when "string"
                      STRING_MSG
                    else
                      GENERAL_MSG
                    end
          graphql_argument_with_prepare_block?(node) do |prepare_definition|
            add_offense(prepare_definition, message: message)
          end

          if type == "symbol"
            prepare_method_string_name?(node) do |prepare_definition|
              method_name = prepare_definition.value
              add_offense(prepare_definition,
                          message: format(PREFER_SYMBOL_MSG, method_name)) do |corrector|
                autocorrect(corrector, node, "\"#{method_name}\"", ":#{method_name}")
              end
            end
          elsif type == "string"
            prepare_method_symbol_name?(node) do |prepare_definition|
              method_name = prepare_definition.value
              add_offense(prepare_definition,
                          message: format(PREFER_STRING_MSG, method_name)) do |corrector|
                autocorrect(corrector, node, ":#{method_name}", "\"#{method_name}\"")
              end
            end
          end
        end

        private

        def autocorrect(corrector, node, original_method_name, new_method_name)
          new_source = node.source.sub("prepare: #{original_method_name}",
                                       "prepare: #{new_method_name}")
          corrector.replace(node, new_source)
        end
      end
    end
  end
end

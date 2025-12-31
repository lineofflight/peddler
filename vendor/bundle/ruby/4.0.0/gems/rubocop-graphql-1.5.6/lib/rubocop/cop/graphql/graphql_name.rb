# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Checks consistency of graphql_name usage
      #
      # EnforcedStyle supports two modes:
      #
      # `only_override` : types and mutations should have graphql_name configured only if it's
      #  different from the default name
      #
      # `required` : all types and mutations should have graphql_name configured
      #
      # @example EnforcedStyle: only_override (default)
      #   # good
      #
      #   class UserType < BaseType
      #     graphql_name 'Viewer'
      #   end
      #
      #   # bad
      #
      #   class UserType < BaseType
      #     graphql_name 'User'
      #   end
      #
      # @example EnforcedStyle: required
      #   # good
      #
      #   class UserType < BaseType
      #     graphql_name 'User'
      #   end
      #
      #   # bad
      #
      #   class UserType < BaseType
      #   end
      #
      class GraphqlName < Base
        include ConfigurableEnforcedStyle

        # @!method graphql_name(node)
        def_node_matcher :graphql_name, <<~PATTERN
          `(send nil? :graphql_name (str $_))
        PATTERN

        # @!method class_name(node)
        def_node_matcher :class_name, <<~PATTERN
          (class (const _ $_) ...)
        PATTERN

        MISSING_NAME = "graphql_name should be configured."
        UNNEEDED_OVERRIDE = "graphql_name should be specified only for overrides."

        def on_class(node)
          specified_name = graphql_name(node)

          case style
          when :required
            add_offense(node, message: MISSING_NAME) if specified_name.nil?
          when :only_override
            default_graphql_name = class_name(node).to_s.sub(/Type\Z/, "")
            add_offense(node, message: UNNEEDED_OVERRIDE) if specified_name == default_graphql_name
          end
        end
      end
    end
  end
end

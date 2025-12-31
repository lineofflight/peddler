# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      # Arguments should either be listed explicitly or **rest should be in the resolve signature
      # (and similar methods, such as #authorized?).
      #
      # @example
      #   # good
      #
      #   class SomeResolver < Resolvers::Base
      #     argument :arg1, String, required: true
      #     argument :user_id, String, required: true, loads: Types::UserType
      #     argument :post_id, String, loads: Types::PostType, as: :article
      #     argument :comment_ids, String, loads: Types::CommentType
      #
      #     def authorized?(arg1:, user:, article:, comments:); end
      #     def resolve(arg1:, user:, article:, comments:); end
      #   end
      #
      #   # good
      #
      #   class SomeResolver < Resolvers::Base
      #     argument :arg1, String, required: true
      #     argument :user_id, String, required: true, loads: Types::UserType
      #     argument :comment_ids, String, loads: Types::CommentType
      #
      #     def resolve(arg1:, **rest); end
      #   end
      #
      #   # good
      #
      #   class SomeResolver < Resolvers::Base
      #     type SomeType, null: false
      #
      #     argument :arg1, String, required: true
      #     argument :arg2, String, required: true
      #
      #     def resolve(args); end
      #   end
      #
      #   # bad
      #
      #   class SomeResolver < Resolvers::Base
      #     type SomeType, null: false
      #
      #     argument :arg1, String, required: true
      #     argument :arg2, String, required: true
      #
      #     def authorized?; end
      #     def resolve(arg1:); end
      #   end
      #
      #   # bad
      #
      #   class SomeResolver < Resolvers::Base
      #     type SomeType, null: false
      #
      #     argument :arg1, String, required: true
      #     argument :arg2, String, required: true
      #
      #     def resolve; end
      #   end
      #
      class UnusedArgument < Base
        extend AutoCorrector

        MSG = "Argument%<ending>s `%<unresolved_args>s` should be listed in the %<name>s signature."

        def on_class(node)
          resolve_method_node = find_resolve_method_node(node)
          return if resolve_method_node.nil? || ignore_arguments_type?(resolve_method_node)

          declared_arg_nodes = find_declared_arg_nodes(node)
          return unless declared_arg_nodes.any?

          unresolved_args = find_unresolved_args(resolve_method_node, declared_arg_nodes)
          register_offense(resolve_method_node, unresolved_args) if unresolved_args.any?
        end

        private

        def find_declared_arg_nodes(node)
          node.each_child_node.flat_map do |child|
            if scoped_node?(child)
              []
            elsif argument_declaration?(child)
              [child]
            else
              find_declared_arg_nodes(child)
            end
          end
        end

        def find_resolve_method_node(node)
          resolve_method_nodes = resolve_method_definition(node)
          resolve_method_nodes.find do |resolve_node|
            # reject resolve methods from other classes
            resolve_node.each_ancestor(:class).first == node
          end
        end

        def find_unresolved_args(method_node, declared_arg_nodes)
          resolve_method_kwargs = method_node.arguments.select do |arg|
            arg.type?(:kwarg, :kwoptarg)
          end
          resolve_method_kwargs_names = resolve_method_kwargs.map do |node|
            node.node_parts[0]
          end.to_set
          declared_args = declared_arg_nodes.map { |node| RuboCop::GraphQL::Argument.new(node) }
          declared_args.map(&method(:arg_name)).uniq.reject do |declared_arg_name|
            resolve_method_kwargs_names.include?(declared_arg_name)
          end
        end

        def ignore_arguments_type?(resolve_method_node)
          resolve_method_node.arguments.any? do |arg|
            arg.type?(:arg, :kwrestarg, :forward_arg)
          end
        end

        def register_offense(node, unresolved_args)
          unresolved_args_source = unresolved_args.map { |v| "#{v}:" }.join(", ")

          message = format(
            self.class::MSG,
            unresolved_args: unresolved_args_source,
            ending: unresolved_args.size == 1 ? "" : "s",
            name: node.method_name.to_s
          )

          add_offense(node, message: message) do |corrector|
            if node.arguments?
              corrector.insert_after(arg_end(node.last_argument), ", #{unresolved_args_source}")
            else
              corrector.insert_after(method_name(node), "(#{unresolved_args_source})")
            end
          end
        end

        def method_name(node)
          node.loc.keyword.end.resize(node.method_name.to_s.size + 1)
        end

        def arg_end(node)
          node.source_range.end
        end

        def inferred_arg_name(name_as_string)
          case name_as_string
          when /_id$/
            name_as_string.sub(/_id$/, "").to_sym
          when /_ids$/
            name_as_string.sub(/_ids$/, "")
                          .sub(/([^s])$/, "\\1s")
                          .to_sym
          else
            name_as_string.to_sym
          end
        end

        def arg_name(declared_arg)
          return declared_arg.as if declared_arg.kwargs.as
          return inferred_arg_name(declared_arg.name.to_s) if declared_arg.kwargs.loads

          declared_arg.name
        end

        def scoped_node?(node)
          scope_changing_syntax?(node) || block_or_lambda?(node)
        end

        def scope_changing_syntax?(node)
          node.type?(:def, :defs, :class, :module)
        end

        def block_or_lambda?(node)
          node.type?(:block, :lambda)
        end

        # @!method argument_declaration?(node)
        def_node_matcher :argument_declaration?, <<~PATTERN
          (send nil? :argument (:sym _) ...)
        PATTERN

        # @!method resolve_method_definition(node)
        def_node_search :resolve_method_definition, <<~PATTERN
          (def {:resolve | :authorized?} (args ...) ...)
        PATTERN
      end
    end
  end
end

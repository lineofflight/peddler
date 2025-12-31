# frozen_string_literal: true

module RuboCop
  module GraphQL
    class Field
      extend Forwardable
      extend RuboCop::NodePattern::Macros

      # These constants were extracted from graphql-ruby in lib/graphql/schema/member/has_fields.rb
      RUBY_KEYWORDS = %i[class module def undef begin rescue ensure end if unless then elsif else
                         case when while until for break next redo retry in do return yield super
                         self nil true false and or not alias defined? BEGIN END __LINE__
                         __FILE__].freeze

      GRAPHQL_RUBY_KEYWORDS = %i[context object raw_value].freeze

      CONFLICT_FIELD_NAMES = Set.new(
        GRAPHQL_RUBY_KEYWORDS + RUBY_KEYWORDS + Object.instance_methods
      )

      def_delegators :@node, :sibling_index, :parent

      # @!method field_name(node)
      def_node_matcher :field_name, <<~PATTERN
        (send nil? :field (:sym $_) ...)
      PATTERN

      # @!method field_with_body_name(node)
      def_node_matcher :field_with_body_name, <<~PATTERN
        (block
        (send nil? :field (:sym $_) ...)...)
      PATTERN

      # @!method field_description(node)
      def_node_matcher :field_description, <<~PATTERN
        (send nil? :field _ _ {(:str $_)|(:dstr $...)} ...)
      PATTERN

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def name
        @name ||= field_name(@node) || field_with_body_name(@node)
      end

      def underscore_name
        @underscore_name ||= begin
          word = name.to_s.dup
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
          word.tr!("-", "_")
          word.downcase!
          word
        end
      end

      def description
        @description ||= field_description(@node) || kwargs.description || block.description
      end

      def resolver_method_name
        kwargs.resolver_method_name || name
      end

      def kwargs
        @kwargs ||= Field::Kwargs.new(@node)
      end

      def block
        @block ||= Field::Block.new(@node.parent)
      end

      def schema_member
        @schema_member ||= SchemaMember.new(root_node)
      end

      private

      def root_node
        @node.ancestors.find { |parent| root_node?(parent) }
      end

      def root_node?(node)
        node.parent.nil? ||
          node.module_type? && node.children.none?(&:module_type?) ||
          node.class_type? ||
          root_with_siblings?(node.parent)
      end

      def root_with_siblings?(node)
        node.begin_type? && node.parent.nil?
      end
    end
  end
end

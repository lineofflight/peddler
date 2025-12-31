# frozen_string_literal: true

require "set"

module Structure
  # Type coercion methods for converting values to specific types
  module Types
    class << self
      # Rails-style boolean truthy values
      # Reference: https://api.rubyonrails.org/classes/ActiveModel/Type/Boolean.html
      BOOLEAN_TRUTHY = Set.new([true, 1, "1", "t", "T", "true", "TRUE", "on", "ON"]).freeze
      private_constant :BOOLEAN_TRUTHY

      # Main factory method for creating type coercers
      #
      # @param type [Class, Symbol, Array, String, nil] Type specification
      # @param context [Class, nil] Context class for lazy-loading and self-referential types
      # @return [Proc, nil] Coercion proc or nil if no coercion needed
      # @raise [ArgumentError] If type is a Hash instance (typed hashes not yet supported) or unsupported type
      #
      # @example Boolean type
      #   coerce(:boolean) # => boolean proc
      #
      # @example Self-referential types
      #   coerce(:self) # => proc that calls context.parse
      #
      # @example Kernel types
      #   coerce(Integer) # => proc that calls Kernel.Integer
      #
      # @example Array types
      #   coerce([String]) # => proc that coerces array elements to String
      #
      # @example Parseable types
      #   coerce(Date) # => proc that calls Date.parse
      #
      # @example No coercion
      #   coerce(nil) # => nil
      #
      # @example Custom lambdas
      #   coerce(->(val) { val.upcase }) # => returns the lambda itself
      #
      # @example Lazy-resolved classes
      #   coerce("MyClass") # => proc that resolves and coerces to MyClass
      def coerce(type, context = nil)
        case type
        when :boolean
          boolean
        when :self
          self_referential(context)
        when ->(t) { t.respond_to?(:name) && t.name && Kernel.respond_to?(t.name) }
          kernel(type)
        when ->(t) { t.is_a?(Array) && t.length == 1 }
          array(type.first, context)
        when ->(t) { t.respond_to?(:parse) }
          parseable(type)
        when nil
          type
        when ->(t) { t.respond_to?(:call) }
          type
        when String
          lazy_class(type, context)
        else
          raise ArgumentError, "cannot specify #{type.inspect} as type"
        end
      end

      private

      def boolean
        @boolean ||= ->(val) { BOOLEAN_TRUTHY.include?(val) }
      end

      def self_referential(context)
        ->(val) { context.parse(val) }
      end

      def lazy_class(class_name, context)
        resolved_class = nil

        ->(value) do
          resolved_class ||= resolve_class(class_name, context)
          # @type var resolved_class: untyped
          resolved_class.parse(value)
        end
      end

      def array(element_type, context = nil)
        case element_type
        when :self
          lambda do |value|
            unless value.respond_to?(:map)
              raise TypeError, "can't convert #{value.class} into Array"
            end

            value.map { |element| context.parse(element) }
          end
        when String
          resolved_class = nil

          lambda do |value|
            unless value.respond_to?(:map)
              raise TypeError, "can't convert #{value.class} into Array"
            end

            resolved_class ||= resolve_class(element_type, context)
            # @type var resolved_class: untyped
            value.map { |element| resolved_class.parse(element) }
          end
        else
          element_coercer = coerce(element_type, context)
          lambda do |value|
            unless value.respond_to?(:map)
              raise TypeError, "can't convert #{value.class} into Array"
            end

            value.map { |element| element_coercer.call(element) }
          end
        end
      end

      def parseable(type)
        @parseable_cache ||= {} # : Hash[untyped, Proc]
        @parseable_cache[type] ||= ->(val) { type.parse(val) }
      end

      def kernel(type)
        @kernel_cache ||= {} # : Hash[untyped, Proc]
        @kernel_cache[type] ||= ->(val) { Kernel.send(type.name, val) }
      end

      def resolve_class(class_name, context)
        if context && defined?(context.name)
          namespace = context.name.to_s.split("::")[0...-1]
          if namespace.any?
            begin
              namespace.reduce(Object) { |mod, name| mod.const_get(name) }.const_get(class_name)
            rescue NameError
              Object.const_get(class_name)
            end
          else
            Object.const_get(class_name)
          end
        else
          Object.const_get(class_name)
        end
      rescue NameError => e
        raise NameError, "Unable to resolve class '#{class_name}': #{e.message}"
      end
    end
  end
end

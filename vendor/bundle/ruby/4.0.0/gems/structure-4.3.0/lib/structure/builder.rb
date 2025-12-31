# frozen_string_literal: true

require "structure/types"

module Structure
  # Builder class for accumulating attribute definitions
  class Builder
    # @api private
    attr_reader :mappings, :defaults, :types, :after_parse_callback

    # @api private
    def initialize
      @mappings = {}
      @defaults = {}
      @types = {}
      @optional = Set.new
      @non_nullable = Set.new
    end

    # DSL method for defining attributes with optional type coercion
    #
    # @param name [Symbol] The attribute name
    # @param type [Class, Symbol, Array, nil] Type for coercion (e.g., String, :boolean, [String])
    # @param from [String, nil] Source key in the data hash (defaults to name.to_s)
    # @param default [Object, nil] Default value if attribute is missing
    # @param null [Boolean] Whether nil values are allowed (default: true)
    # @yield [value] Block for custom transformation
    # @raise [ArgumentError] If both type and block are provided
    #
    # @example With type coercion
    #   attribute :age, Integer
    #
    # @example With custom source key
    #   attribute :created_at, Time, from: "CreatedAt"
    #
    # @example With transformation block
    #   attribute :price do |value|
    #     Money.new(value["amount"], value["currency"])
    #   end
    #
    # @example Non-nullable attribute
    #   attribute :id, String, null: false
    def attribute(name, type = nil, from: nil, default: nil, null: true, &block)
      mappings[name] = (from || name).to_s
      defaults[name] = default unless default.nil?
      @non_nullable.add(name) unless null

      if type && block
        raise ArgumentError, "cannot specify both type and block for :#{name}"
      else
        types[name] = type || block
      end
    end

    # DSL method for defining optional attributes (key can be missing from input hash)
    #
    # @param name [Symbol] The attribute name
    # @param type [Class, Symbol, Array, nil] Type for coercion (e.g., String, :boolean, [String])
    # @param from [String, nil] Source key in the data hash (defaults to name.to_s)
    # @param default [Object, nil] Default value if attribute is missing
    # @param null [Boolean] Whether nil values are allowed (default: true)
    # @yield [value] Block for custom transformation
    # @raise [ArgumentError] If both type and block are provided
    #
    # @example Optional attribute
    #   attribute? :age, Integer
    #
    # @example Optional with default
    #   attribute? :status, String, default: "pending"
    #
    # @example Optional but non-nullable when present
    #   attribute? :name, String, null: false
    def attribute?(name, type = nil, from: nil, default: nil, null: true, &block)
      attribute(name, type, from: from, default: default, null: null, &block)
      @optional.add(name)
    end

    # Defines a callback to run after parsing
    #
    # @yield [instance] Block that receives the parsed instance
    # @return [void]
    #
    # @example Validation
    #   after_parse do |order|
    #     raise "Invalid order" if order.total < 0
    #   end
    def after_parse(&block)
      @after_parse_callback = block
    end

    # @api private
    def attributes = @mappings.keys

    # @api private
    def optional = @optional.to_a

    # @api private
    def required = attributes - optional

    # @api private
    def non_nullable = @non_nullable.to_a

    # @api private
    def coercions(context = nil)
      @types.to_h do |attr, type|
        coercion = Types.coerce(type, context)
        [attr, coercion]
      rescue ArgumentError => e
        raise ArgumentError, "#{e.message} for :#{attr}"
      end
    end

    # @api private
    def predicate_methods
      @types.filter_map do |name, type|
        if type == :boolean
          ["#{name}?".to_sym, name] unless name.to_s.end_with?("?")
        end
      end.to_h
    end
  end
end

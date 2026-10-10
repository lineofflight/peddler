# frozen_string_literal: true

module Peddler
  module Native
    # Turns the forms v5 took for an argument into the one the core takes
    #
    # v5 sent whatever it was given and the core is strict about types. Every generated method passes its arguments
    # through here. An error names the argument and what it should be, never its value.
    #
    # An object that converts itself to a String with `to_str` is that String wherever a String is taken, as a
    # {Peddler::Marketplace} is its ID.
    module Arguments
      INTEGER = /\A-?\d+\z/ #: Regexp
      DECIMAL = /\A-?\d+\.\d+\z/ #: Regexp
      NOT_JSON = Object.new.freeze #: Object
      private_constant :INTEGER, :DECIMAL, :NOT_JSON

      # What is said of a Hash or an Array that can't be encoded as a body
      JSON_RULE = "must be JSON: Strings of valid UTF-8 and finite numbers"

      # A String, or what v5 sent as one: see `text`
      #: (String name, untyped value, ?required: bool) -> String?
      def self.string(name, value, required: false)
        return missing(name, required) if value.nil?

        text(name, value) || raise(ArgumentError, "#{name} must be a String")
      end

      # An argument that is 1 segment of the path. What the core refuses is refused here by name: `.` and `..`
      # would address another resource, and so would nothing at the end of a path, which is the collection above.
      #: (String name, untyped value, ?last: bool) -> String
      def self.segment(name, value, last: false)
        segment = string(name, value, required: true).to_s
        raise ArgumentError, "#{name} must not be . or .." if segment == "." || segment == ".."
        raise ArgumentError, "#{name} must not be empty" if last && segment.empty?

        segment
      end

      # A String is a list of 1, which is how v5 sent it
      #: (String name, untyped value, ?required: bool) -> Array[String]?
      def self.array(name, value, required: false)
        return missing(name, required) if value.nil?

        (value.is_a?(Array) ? value : [value]).map do |item|
          text(name, item) || raise(ArgumentError, "#{name} must be an Array of Strings")
        end
      end

      #: (String name, untyped value, ?required: bool) -> Integer?
      def self.integer(name, value, required: false)
        value = plain(value)
        return missing(name, required) if value.nil?
        return value if value.is_a?(Integer)
        return value.to_i if numeral?(value, INTEGER)

        raise ArgumentError, "#{name} must be an Integer"
      end

      #: (String name, untyped value, ?required: bool) -> (Integer | Float)?
      def self.number(name, value, required: false)
        value = plain(value)
        return missing(name, required) if value.nil?
        return value if value.is_a?(Integer) || (value.is_a?(Float) && value.finite?)
        return value.to_i if numeral?(value, INTEGER)
        return value.to_f if numeral?(value, DECIMAL)

        raise ArgumentError, "#{name} must be an Integer or a Float"
      end

      #: (String name, untyped value, ?required: bool) -> bool?
      def self.boolean(name, value, required: false)
        case plain(value)
        when nil then missing(name, required)
        when true, "true" then true
        when false, "false" then false
        else raise ArgumentError, "#{name} must be true or false"
        end
      end

      # A String holds the JSON already, as in v5, so it is parsed and not encoded a second time
      #: (String name, untyped value, ?required: bool) -> untyped
      def self.body(name, value, required: false)
        value = plain(value)
        return missing(name, required) if value.nil?
        return value unless value.is_a?(String)

        # Parsed outside the raise: the parser's error quotes the body and would become the cause.
        parsed = begin
          JSON.parse(value)
        rescue JSON::ParserError, EncodingError
          NOT_JSON
        end
        raise ArgumentError, "#{name} must be JSON" if parsed.equal?(NOT_JSON)

        parsed
      end

      # A value of a raw request's query: what an operation's argument is as text, a boolean, or an Array of them,
      # joined with commas as v5 joined it
      #: (String name, untyped value) -> String
      def self.parameter(name, value)
        value.is_a?(Array) ? value.map { |item| scalar(name, item) }.join(",") : scalar(name, value)
      end

      # The requests per second a caller gives for the wait after a 429, in place of the rate Amazon documents for
      # the operation. nil is no rate. v5 divided 1.0 by it, so it is any number that is positive as a Float.
      #: (untyped value) -> Float?
      def self.rate_limit(value)
        return if value.nil?

        rate = Float(value, exception: false) if value.is_a?(Numeric)
        unless rate&.finite? && rate.positive?
          raise ArgumentError, "rate_limit must be a positive number of requests per second"
        end

        rate
      end

      # The arguments as the JSON the core takes. Each was checked but the inside of a body, so what can't be
      # encoded is there. The encoder's error quotes the value, so the error is raised here, outside its rescue,
      # where it can't become the cause.
      #: (Hash[Symbol, untyped] arguments, ?String? body) -> String
      def self.encode(arguments, body = nil)
        Native.generate(arguments) || raise(ArgumentError, body ? "#{body} #{JSON_RULE}" : "invalid arguments")
      end

      #: (String name, bool required) -> nil
      def self.missing(name, required)
        raise ArgumentError, "#{name} is required" if required
      end

      # What an object converts itself to with `to_str`. Without one it is itself, and so it is when its `to_str`
      # raises or returns no String. That error is not raised: it is the caller's own and may hold anything.
      #: (untyped value) -> untyped
      def self.plain(value)
        return value unless value.respond_to?(:to_str)

        converted = begin
          value.to_str
        rescue StandardError
          nil
        end
        converted.is_a?(String) ? converted : value
      end

      # An argument as text, or nil if it has none. A String is itself. nil, a boolean, a Hash and an Array have
      # none, nor has an object whose `to_str` fails. Anything else is its `to_s`, as v5 sent it, unless that is an
      # inspect form such as "#<Object>" or "#<data Point x=1>", which is nobody's argument.
      #
      # Text that is not valid UTF-8 is refused by the argument's name. The encoder would refuse it too, in an
      # error that quotes it.
      #: (String name, untyped value) -> String?
      def self.text(name, value)
        text = case value = plain(value)
        when String then value
        when nil, true, false, Hash, Array then return
        else
          return if value.respond_to?(:to_str)

          value.to_s
        end
        return if !value.is_a?(String) && text.start_with?("#<")
        raise ArgumentError, "#{name} must be valid UTF-8" unless Native.valid_utf8_string?(text)

        text
      end

      #: (String name, untyped value) -> String
      def self.scalar(name, value)
        scalar = case value
        when true, false then value.to_s
        when Float then value.to_s if value.finite?
        else text(name, value)
        end
        scalar || raise(ArgumentError, "#{name} must be a String, a finite number, a boolean or an Array of them")
      end

      # Whether the value is a String that spells a number. One that is not valid UTF-8 can't be matched.
      #: (untyped value, Regexp pattern) -> bool
      def self.numeral?(value, pattern)
        value.is_a?(String) && value.ascii_only? && value.match?(pattern)
      end

      private_class_method :missing, :plain, :text, :scalar, :numeral?
    end
  end
end

# frozen_string_literal: true

module Peddler
  module Native
    # Turns the forms v5 took for an argument into the one the core takes
    #
    # v5 sent whatever it was given and the core is strict about types. Every generated method passes its arguments
    # through here. An error names the argument and what it should be, never its value.
    module Arguments
      INTEGER = /\A-?\d+\z/
      DECIMAL = /\A-?\d+\.\d+\z/
      NOT_JSON = Object.new.freeze
      private_constant :INTEGER, :DECIMAL, :NOT_JSON

      class << self
        # Anything but nil, a boolean, a Hash or an Array, as its `to_s`
        def string(name, value, required: false)
          return missing(name, required) if value.nil?

          text(value) || raise(ArgumentError, "#{name} must be a String")
        end

        # An argument that is 1 segment of the path. What the core refuses is refused here by name: `.` and `..`
        # would address another resource, and so would nothing at the end of a path, which is the collection above.
        def segment(name, value, last: false)
          segment = string(name, value, required: true).to_s
          raise ArgumentError, "#{name} must not be . or .." if segment == "." || segment == ".."
          raise ArgumentError, "#{name} must not be empty" if last && segment.empty?

          segment
        end

        # A String is a list of 1, which is how v5 sent it
        def array(name, value, required: false)
          return missing(name, required) if value.nil?

          (value.is_a?(Array) ? value : [value]).map do |item|
            text(item) || raise(ArgumentError, "#{name} must be an Array of Strings")
          end
        end

        def integer(name, value, required: false)
          return missing(name, required) if value.nil?
          return value if value.is_a?(Integer)
          return value.to_i if value.is_a?(String) && value.match?(INTEGER)

          raise ArgumentError, "#{name} must be an Integer"
        end

        def number(name, value, required: false)
          return missing(name, required) if value.nil?
          return value if value.is_a?(Integer) || (value.is_a?(Float) && value.finite?)
          return value.to_i if value.is_a?(String) && value.match?(INTEGER)
          return value.to_f if value.is_a?(String) && value.match?(DECIMAL)

          raise ArgumentError, "#{name} must be an Integer or a Float"
        end

        def boolean(name, value, required: false)
          case value
          when nil then missing(name, required)
          when true, "true" then true
          when false, "false" then false
          else raise ArgumentError, "#{name} must be true or false"
          end
        end

        # A String holds the JSON already, as in v5, so it is parsed and not encoded a second time
        def body(name, value, required: false)
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

        private

        def missing(name, required)
          raise ArgumentError, "#{name} is required" if required
        end

        def text(value)
          case value
          when String then value
          when nil, true, false, Hash, Array then nil
          else value.to_s
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Generator
  # Amazon's enum lists are documentation, not a contract: they change without a version bump, one spec can spell a
  # value two ways, and the API can return values the spec doesn't list. Fields stay String; the values are listed in
  # the docs as known values. `crates/peddler-codegen/src/known_values.rs` holds the same rule.
  module KnownValues
    class << self
      # Enum values a schema declares inline, through a $ref, or on its array items.
      def enum_values(schema, definitions = nil)
        return [] unless schema.is_a?(Hash)

        schema = deref(schema, definitions)
        return schema["enum"] if schema["enum"].is_a?(Array)

        items = schema["items"]
        items = items.first if items.is_a?(Array)
        return [] unless items.is_a?(Hash)

        items = deref(items, definitions)
        items["enum"].is_a?(Array) ? items["enum"] : []
      end

      # Appends the known values to a description, unless it already lists them all.
      def append(description, values)
        return description if values.empty?
        return description if description && values.all? { |value| description.include?(value.to_s) }

        sentence = "Known values: #{values.map { |value| code(value) }.join(", ")}."
        return sentence unless description

        description = description.rstrip
        description += "." unless description.end_with?(".", "!", "?")
        "#{description} #{sentence}"
      end

      private

      # A value as Markdown code. A spec is data: a value that holds a backtick is fenced by a longer run of them, and
      # its whitespace is a space, so the value reads as the text it is.
      def code(value)
        text = value.to_s.split.join(" ")
        fence = "`" * (text.scan(/`+/).map(&:size).max.to_i + 1)
        text = " #{text} " if text.start_with?("`") || text.end_with?("`")
        "#{fence}#{text}#{fence}"
      end

      def deref(schema, definitions)
        ref = schema["$ref"]
        return schema unless ref && definitions

        definitions[ref.split("/").last] || schema
      end
    end
  end
end

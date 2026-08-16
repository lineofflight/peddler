# frozen_string_literal: true

require "json"
require "nokogiri"

module Peddler
  class Error
    # @!visibility private
    class Builder
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def build
        error_class.new(message, response)
      end

      private

      def error_class
        return Error unless code

        if Errors.const_defined?(class_name)
          Errors.const_get(class_name)
        else
          Errors.const_set(class_name, Class.new(Error))
        end
      rescue NameError
        Error
      end

      def class_name
        if code.match?(/\A([a-z_]+|[A-Z_]+)\z/)
          code.split("_").map(&:capitalize).join
        else
          code
        end
      end

      def code
        extracted[0]
      end

      def message
        extracted[1] || response.status.to_s
      end

      # Code and message always come from the same body shape
      def extracted
        @extracted ||= if payload.key?("error")
          [payload["error"], payload["error_description"]]
        elsif payload.key?("errors")
          [payload.dig("errors", 0, "code"), payload.dig("errors", 0, "message")]
        elsif payload.key?("Code")
          [payload["Code"], payload["Message"]]
        else
          [nil, nil]
        end
      end

      def payload
        @payload ||= begin
          parsed = JSON.parse(response)
          parsed.is_a?(Hash) ? parsed : {}
        rescue JSON::ParserError
          xml_payload
        end
      end

      def xml_payload
        doc = Nokogiri::XML(response)
        root = doc.root
        return {} unless root

        root.element_children.to_h { |e| [e.name, e.text] }
      rescue NoMethodError
        {}
      end
    end
  end
end

# frozen_string_literal: true

module Generator
  class ParameterBuilder
    def initialize(operation, shared_parameters, rate_limit)
      @operation = operation
      @shared_parameters = shared_parameters
      @rate_limit = rate_limit
    end

    def build
      parameters = (@shared_parameters + (@operation["parameters"] || [])).uniq { |p| p["name"] }
      parameters = parameters.select { |p| p["name"] }
      if @rate_limit
        parameters << build_rate_limit_param
      end
      parameters << build_notification_type_param if needs_notification_type?

      parameters
    end

    private

    def build_rate_limit_param
      {
        "name" => "rate_limit",
        "type" => "Float",
        "required" => false,
        "description" => "Requests per second",
        "default" => @rate_limit,
      }
    end

    def build_notification_type_param
      {
        "name" => "notification_type",
        "type" => "string",
        "required" => true,
        "description" => "The type of notification. For more information about notification types, refer to " \
          "[Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).",
      }
    end

    def needs_notification_type?
      @operation["parameters"].find { |el| el.key?("$ref") && !el.key?("name") }
    end
  end
end

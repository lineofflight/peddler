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

      # Add notification_type first since it's required
      parameters << build_notification_type_param if needs_notification_type?

      # Add rate_limit last since it's optional
      if @rate_limit
        parameters << build_rate_limit_param
      end

      parameters
    end

    private

    def build_rate_limit_param
      param = {
        "name" => "rate_limit",
        "type" => "Float",
        "required" => false,
        "description" => "Requests per second",
      }

      # Only add default if we have a known rate limit value (not :unknown)
      param["default"] = @rate_limit unless @rate_limit == :unknown

      param
    end

    # Builds a notification_type parameter for operations that reference the NotificationType parameter.
    # This is needed because the OpenAPI $ref doesn't get resolved during our generation process,
    # so we manually add this parameter when we detect a reference to it.
    #
    # @return [Hash] Parameter definition for notification_type
    def build_notification_type_param
      {
        "name" => "notification_type",
        "type" => "string",
        "required" => true,
        "description" => "The type of notification. For more information about notification types, refer to " \
          "[Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).",
      }
    end

    # Detects when an operation uses a shared parameter reference that doesn't include a name property.
    # This pattern is specific to Amazon's Notifications API where the notification type is defined as
    # a shared parameter reference like: { "$ref": "#/parameters/NotificationType" }
    #
    # In the OpenAPI spec, the actual parameter definition exists at the $ref location:
    #   parameters:
    #     NotificationType:
    #       name: notificationType
    #       in: path
    #       required: true
    #       ...
    #
    # Since our generator doesn't resolve $refs, we detect this pattern and manually add the parameter.
    #
    # @return [Boolean] true if the operation references NotificationType without a name property
    def needs_notification_type?
      @operation["parameters"].find { |el| el.key?("$ref") && !el.key?("name") }
    end
  end
end

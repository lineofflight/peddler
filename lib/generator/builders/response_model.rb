# frozen_string_literal: true

module Generator
  class ResponseModel
    attr_reader :operation

    def initialize(operation)
      @operation = operation
    end

    def build
      success_response = find_success_response
      return default_response_model unless success_response && success_response["schema"]

      schema = success_response["schema"]

      if schema["$ref"]
        build_ref_response_model(schema["$ref"])
      elsif schema["properties"] && schema["properties"]["payload"]
        handle_inline_payload_response(schema["properties"]["payload"])
      else
        default_response_model
      end
    end

    private

    def find_success_response
      operation["responses"].select { |code, _| code.match?(/\A2\d\d\z/) }.min_by(&:first)&.last
    end

    def default_response_model
      { model: nil }
    end

    def build_ref_response_model(ref)
      response_type_name = ref.split("/").last
      { model: response_type_name }
    end

    def handle_inline_payload_response(payload_schema)
      if payload_schema["$ref"]
        handle_payload_ref(payload_schema["$ref"])
      elsif payload_schema["properties"]
        handle_properties_payload(payload_schema)
      else
        default_response_model
      end
    end

    def handle_payload_ref(ref)
      model_name = ref.split("/").last
      build_single_model(model_name)
    end

    def handle_properties_payload(payload_schema)
      return default_response_model unless payload_schema["properties"]

      array_prop = find_array_in_properties(payload_schema["properties"])

      if array_prop
        build_properties_array_model(array_prop[0])
      else
        build_properties_single_model(payload_schema["properties"].keys.first)
      end
    end

    def find_array_in_properties(properties)
      properties.find { |_, prop| prop["type"] == "array" }
    end

    def build_properties_array_model(array_name)
      { model: array_name.sub(/s$/, "") }
    end

    def build_properties_single_model(model_name)
      { model: model_name }
    end

    def build_single_model(model_name)
      { model: model_name }
    end
  end
end

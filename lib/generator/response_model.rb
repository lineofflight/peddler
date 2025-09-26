# frozen_string_literal: true

module Generator
  class ResponseModel
    DEFAULT_PAYLOAD_KEY = "payload"

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
      responses = operation["responses"]
      responses["200"] || responses["201"] || responses["202"] || responses["204"]
    end

    def default_response_model
      { type: :raw, model: nil, path: ["payload"] }
    end

    def build_ref_response_model(ref)
      response_type_name = ref.split("/").last
      {
        type: :response,
        model: response_type_name,
        path: [],
      }
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
      {
        type: :array,
        model: array_name.sub(/s$/, ""),
        path: [DEFAULT_PAYLOAD_KEY, array_name],
      }
    end

    def build_properties_single_model(model_name)
      {
        type: :single,
        model: model_name,
        path: [DEFAULT_PAYLOAD_KEY, model_name],
      }
    end

    def build_single_model(model_name)
      {
        type: :single,
        model: model_name,
        path: [DEFAULT_PAYLOAD_KEY],
      }
    end
  end
end

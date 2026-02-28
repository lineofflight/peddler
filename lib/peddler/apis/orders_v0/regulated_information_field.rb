# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # A field collected from the regulatory form.
      RegulatedInformationField = Structure.new do
        # @return [String] The unique identifier of the field.
        attribute(:field_id, String, null: false, from: "FieldId")

        # @return [String] The name of the field.
        attribute(:field_label, String, null: false, from: "FieldLabel")

        # @return [String] The type of field.
        attribute(:field_type, String, null: false, from: "FieldType")

        # @return [String] The content of the field as collected in regulatory form. Note that `FileAttachment` type
        #   fields contain a URL where you can download the attachment.
        attribute(:field_value, String, null: false, from: "FieldValue")
      end
    end
  end
end

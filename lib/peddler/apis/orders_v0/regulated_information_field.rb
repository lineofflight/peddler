# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # A field collected from the regulatory form.
      RegulatedInformationField = Structure.new do
        # The unique identifier of the field.
        attribute(:field_id, String, null: false, from: "FieldId")

        # The name of the field.
        attribute(:field_label, String, null: false, from: "FieldLabel")

        # The type of field. Known values: `Text`, `FileAttachment`.
        attribute(:field_type, String, null: false, from: "FieldType")

        # The content of the field as collected in regulatory form. Note that `FileAttachment` type fields contain a URL
        # where you can download the attachment.
        attribute(:field_value, String, null: false, from: "FieldValue")
      end
    end
  end
end

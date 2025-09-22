# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # A field collected from the regulatory form.
      RegulatedInformationField = Structure.new do
        # @return [String] The unique identifier of the field.
        attribute(:field_id, String, from: "FieldId")

        # @return [String] The name of the field.
        attribute(:field_label, String, from: "FieldLabel")

        # @return [String] The type of field.
        attribute(:field_type, String, from: "FieldType")

        # @return [String] The content of the field as collected in regulatory form. Note that `FileAttachment` type
        # fields contain a URL where you can download the attachment.
        attribute(:field_value, String, from: "FieldValue")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ListingsItems20200901
      # An issue with a listings item.
      Issue = Structure.new do
        # @return [String] An issue code that identifies the type of issue.
        attribute(:code, String)

        # @return [String] A message that describes the issue.
        attribute(:message, String)

        # @return [String] The severity of the issue.
        attribute(:severity, String)

        # @return [String] Name of the attribute associated with the issue, if applicable.
        attribute?(:attribute_name, String, from: "attributeName")
      end
    end
  end
end

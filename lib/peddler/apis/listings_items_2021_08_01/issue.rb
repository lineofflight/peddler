# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # An issue with a listings item.
      Issue = Structure.new do
        # @return [Array<String>] List of issue categories.
        attribute(:categories, [String], null: false)

        # @return [String] An issue code that identifies the type of issue.
        attribute(:code, String, null: false)

        # @return [String] A message that describes the issue.
        attribute(:message, String, null: false)

        # @return [String] The severity of the issue. Known values: `ERROR`, `WARNING`, `INFO`.
        attribute(:severity, String, null: false)

        # @return [Array<String>] Names of the attributes that are associated with the issue, if applicable.
        attribute?(:attribute_names, [String], from: "attributeNames")

        # @return [IssueEnforcements] Information about enforcement actions by Amazon that affect the publishing or
        #   status of a listing, including any associated exemptions.
        attribute?(:enforcements, IssueEnforcements)

        # @return [Array<String>] List of Amazon store identifiers.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # An issue with a listings item.
      Issue = Structure.new do
        # @return [Array<String>] List of issue categories.
        #
        # Possible values:
        #
        # * 'INVALID_ATTRIBUTE' - Indicating an invalid attribute in the listing.
        #
        # * 'MISSING_ATTRIBUTE' - Highlighting a missing attribute in the listing.
        #
        # * 'INVALID_IMAGE' - Signifying an invalid image in the listing.
        #
        # * 'MISSING_IMAGE' - Noting the absence of an image in the listing.
        #
        # * 'INVALID_PRICE' - Pertaining to issues with the listing's price-related attributes.
        #
        # * 'MISSING_PRICE' - Pointing out the absence of a price attribute in the listing.
        #
        # * 'DUPLICATE' - Identifying listings with potential duplicate problems, such as this ASIN potentially being a
        #   duplicate of another ASIN.
        #
        # * 'QUALIFICATION_REQUIRED' - Indicating that the listing requires qualification-related approval.
        attribute(:categories, [String], null: false)

        # @return [String] An issue code that identifies the type of issue.
        attribute(:code, String, null: false)

        # @return [String] A message that describes the issue.
        attribute(:message, String, null: false)

        # @return [String] The severity of the issue.
        attribute(:severity, String, null: false)

        # @return [Array<String>] The names of the attributes associated with the issue, if applicable.
        attribute?(:attribute_names, [String], from: "attributeNames")

        # @return [IssueEnforcements] This field provides information about the enforcement actions taken by Amazon that
        #   affect the publishing or status of a listing. It also includes details about any associated exemptions.
        attribute?(:enforcements, IssueEnforcements)
      end
    end
  end
end

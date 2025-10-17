# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedSchema
      # Header information about the feed submission.
      Header = Structure.new do
        # @return [String] Identifier for the Selling Partner, such as the Merchant Account or Vendor Code.
        attribute(:seller_id, String, from: "sellerId")

        # @return [String] Version of the JSON Selling Partner Listings Feeds specification used for the feed
        #   submission.
        attribute(:version, String)

        # @return [String] Locale for issue localization. When not provided, the default language code of the first
        #   marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to "en_US" when a
        #   localization is not available in the specified locale.
        attribute?(:issue_locale, String, from: "issueLocale")

        # @return [Report] The report information for the feed submission.
        attribute?(:report, Report)
      end
    end
  end
end

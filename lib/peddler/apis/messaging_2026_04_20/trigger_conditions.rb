# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The conditions that determine when an automation configuration activates for a given store. All conditions must
      # be met simultaneously using `AND` logic. Within list-based conditions (such as `buyerContactTopics` or
      # `asinList`), any single match satisfies that condition using `OR` logic. For example, if `buyerContactTopics`
      # contains `SHIPPING` and `WHERES_MY_STUFF`, the automation triggers when the buyer's inquiry matches either
      # topic. Trigger conditions cannot overlap with another active automation configuration in the same store; if any
      # combination of ASIN, buyer contact topic, and buyer contact type is already covered by another active
      # configuration, the request is rejected with a `409` error.
      TriggerConditions = Structure.new do
        # @return [Array<String>] The ASINs this automation configuration applies to. The configuration only triggers
        #   for buyer inquiries about these ASINs. ASINs are validated for format only (10 alphanumeric characters);
        #   they are not checked against the catalog. Non-existent ASINs won't match a buyer inquiry.
        attribute(:asin_list, [String], null: false, from: "asinList")

        # @return [Array<String>] The buyer contact topics that trigger this automation configuration. Known values:
        #   `PRODUCT_DETAILS`, `WARRANTY`, `PRICING`, `SHIPPING`, `TROUBLESHOOTING`, `WHERES_MY_STUFF`, `RETURN_POLICY`.
        attribute(:buyer_contact_topics, [String], null: false, from: "buyerContactTopics")

        # @return [String] The buyer contact type that triggers this automation configuration. There is no default
        #   value. Known values: `PRE_ORDER`, `POST_ORDER`, `ANY`.
        attribute(:buyer_contact_type, String, null: false, from: "buyerContactType")
      end
    end
  end
end

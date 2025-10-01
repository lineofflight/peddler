# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # Conveying the status of the listed enforcement actions and, if applicable, provides information about the
      # exemption's expiry date.
      IssueExemption = Structure.new do
        # @return [String] This field indicates the current exemption status for the listed enforcement actions. It can
        # take values such as `EXEMPT`, signifying permanent exemption, `EXEMPT_UNTIL_EXPIRY_DATE` indicating temporary
        # exemption until a specified date, or `NOT_EXEMPT` signifying no exemptions, and enforcement actions were
        # already applied.
        attribute(:status, String)

        # @return [String] Represents the timestamp, in ISO 8601 format, that specifies the date when the temporary
        # exemptions expires, and Amazon begins enforcing the listed actions.
        attribute?(:expiry_date, String, from: "expiryDate")
      end
    end
  end
end

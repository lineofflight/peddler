# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # This field provides information about the enforcement actions taken by Amazon that affect the publishing or
      # status of a listing. It also includes details about any associated exemptions.
      IssueEnforcements = Structure.new do
        # @return [Array<IssueEnforcementAction>] List of enforcement actions taken by Amazon that affect the publishing
        #   or status of a listing.
        attribute(:actions, [IssueEnforcementAction])

        # @return [IssueExemption] The "exemption" field serves to convey the status of enforcement actions by Amazon.
        attribute(:exemption, IssueExemption)
      end
    end
  end
end

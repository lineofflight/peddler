# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `completeServiceJobByServiceJobId` operation.
      CompleteServiceJobByServiceJobIdResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the `completeServiceJobByServiceJobId` operation.
        attribute(:errors, [Error])
      end
    end
  end
end

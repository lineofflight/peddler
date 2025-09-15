# frozen_string_literal: true

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `cancelServiceJobByServiceJobId` operation.
      CancelServiceJobByServiceJobIdResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the `cancelServiceJobByServiceJobId` operation.
        attribute(:errors, [Error])
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Response schema for the `completeServiceJobByServiceJobId` operation.
      CompleteServiceJobByServiceJobIdResponse = Structure.new do
        # Encountered errors for the `completeServiceJobByServiceJobId` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end

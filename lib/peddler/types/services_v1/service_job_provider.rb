# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Information about the service job provider.
      ServiceJobProvider = Structure.new do
        # @return [String] The identifier of the service job provider.
        attribute?(:service_job_provider_id, String, from: "serviceJobProviderId")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The scope of work for the order.
      ScopeOfWork = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the service job.
        attribute?(:asin, String)

        # @return [String] The title of the service job.
        attribute?(:title, String)

        # @return [Integer] The number of service jobs.
        attribute?(:quantity, Integer)

        # @return [Array<String>] A list of skills required to perform the job.
        attribute?(:required_skills, [String], from: "requiredSkills")
      end
    end
  end
end

# frozen_string_literal: true

require "peddler/types/tokens_2021_03_01/restricted_resource"

module Peddler
  module Types
    module Tokens20210301
      # The request schema for the createRestrictedDataToken operation.
      CreateRestrictedDataTokenRequest = Structure.new do
        # @return [String] The application ID for the target application to which access is being delegated.
        attribute(:target_application, String, from: "targetApplication")

        # @return [Array<RestrictedResource>] A list of restricted resources.
        # Maximum: 50
        attribute(:restricted_resources, [RestrictedResource], from: "restrictedResources")
      end
    end
  end
end

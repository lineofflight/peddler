# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Tokens20210301
      # The request schema for the createRestrictedDataToken operation.
      CreateRestrictedDataTokenRequest = Structure.new do
        # A list of restricted resources.
        # Maximum: 50
        attribute(:restricted_resources, [RestrictedResource], null: false, from: "restrictedResources")

        # The application ID for the target application to which access is being delegated.
        attribute?(:target_application, String, from: "targetApplication")
      end
    end
  end
end

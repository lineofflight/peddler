# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Encryption details for required client-side encryption and decryption of document contents.
      EncryptionDetails = Structure.new do
        # @return [String] The vector to encrypt or decrypt the document contents using Cipher Block Chaining (CBC).
        attribute(:initialization_vector, String, null: false, from: "initializationVector")

        # @return [String] The encryption key used to encrypt or decrypt the document contents.
        attribute(:key, String, null: false)

        # @return [String] The encryption standard required to encrypt or decrypt the document contents.
        attribute(:standard, String, null: false)
      end
    end
  end
end

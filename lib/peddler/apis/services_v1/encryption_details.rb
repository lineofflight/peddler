# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Encryption details for required client-side encryption and decryption of document contents.
      EncryptionDetails = Structure.new do
        # The vector to encrypt or decrypt the document contents using Cipher Block Chaining (CBC).
        attribute(:initialization_vector, String, null: false, from: "initializationVector")

        # The encryption key used to encrypt or decrypt the document contents.
        attribute(:key, String, null: false)

        # The encryption standard required to encrypt or decrypt the document contents. Known values: `AES`.
        attribute(:standard, String, null: false)
      end
    end
  end
end

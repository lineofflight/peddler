# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Encryption details for required client-side encryption and decryption of document contents.
      EncryptionDetails = Structure.new do
        # @return [String] The encryption standard required to encrypt or decrypt the document contents.
        attribute(:standard, String)

        # @return [String] The vector to encrypt or decrypt the document contents using Cipher Block Chaining (CBC).
        attribute(:initialization_vector, String, from: "initializationVector")

        # @return [String] The encryption key used to encrypt or decrypt the document contents.
        attribute(:key, String)
      end
    end
  end
end

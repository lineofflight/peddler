# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The standard company logo image.
      StandardCompanyLogoModule = Structure.new do
        attribute(:company_logo, ImageComponent, null: false, from: "companyLogo")
      end
    end
  end
end

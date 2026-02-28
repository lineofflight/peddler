# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The standard company logo image.
      StandardCompanyLogoModule = Structure.new do
        # @return [ImageComponent]
        attribute(:company_logo, ImageComponent, null: false, from: "companyLogo")
      end
    end
  end
end

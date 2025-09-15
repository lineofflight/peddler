# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/image_component"

module Peddler
  module Types
    module AplusContent20201101
      # The standard company logo image.
      StandardCompanyLogoModule = Structure.new do
        # @return [ImageComponent]
        attribute(:company_logo, ImageComponent, from: "companyLogo")
      end
    end
  end
end

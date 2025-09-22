# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/standard_company_logo_module"
require "peddler/types/aplus_content_2020_11_01/standard_comparison_table_module"
require "peddler/types/aplus_content_2020_11_01/standard_four_image_text_module"
require "peddler/types/aplus_content_2020_11_01/standard_four_image_text_quadrant_module"
require "peddler/types/aplus_content_2020_11_01/standard_header_image_text_module"
require "peddler/types/aplus_content_2020_11_01/standard_image_sidebar_module"
require "peddler/types/aplus_content_2020_11_01/standard_image_text_overlay_module"
require "peddler/types/aplus_content_2020_11_01/standard_multiple_image_text_module"
require "peddler/types/aplus_content_2020_11_01/standard_product_description_module"
require "peddler/types/aplus_content_2020_11_01/standard_single_image_highlights_module"
require "peddler/types/aplus_content_2020_11_01/standard_single_image_specs_detail_module"
require "peddler/types/aplus_content_2020_11_01/standard_single_side_image_module"
require "peddler/types/aplus_content_2020_11_01/standard_tech_specs_module"
require "peddler/types/aplus_content_2020_11_01/standard_text_module"
require "peddler/types/aplus_content_2020_11_01/standard_three_image_text_module"

module Peddler
  module Types
    module AplusContent20201101
      # An A+ Content module. An A+ Content document is composed of content modules. The `contentModuleType` property
      # selects which content module types to use.
      ContentModule = Structure.new do
        # @return [String]
        attribute(:content_module_type, String, from: "contentModuleType")

        # @return [StandardCompanyLogoModule]
        attribute(:standard_company_logo, StandardCompanyLogoModule, from: "standardCompanyLogo")

        # @return [StandardComparisonTableModule]
        attribute(:standard_comparison_table, StandardComparisonTableModule, from: "standardComparisonTable")

        # @return [StandardFourImageTextModule]
        attribute(:standard_four_image_text, StandardFourImageTextModule, from: "standardFourImageText")

        # @return [StandardFourImageTextQuadrantModule]
        attribute(:standard_four_image_text_quadrant, StandardFourImageTextQuadrantModule, from: "standardFourImageTextQuadrant")

        # @return [StandardHeaderImageTextModule]
        attribute(:standard_header_image_text, StandardHeaderImageTextModule, from: "standardHeaderImageText")

        # @return [StandardImageSidebarModule]
        attribute(:standard_image_sidebar, StandardImageSidebarModule, from: "standardImageSidebar")

        # @return [StandardImageTextOverlayModule]
        attribute(:standard_image_text_overlay, StandardImageTextOverlayModule, from: "standardImageTextOverlay")

        # @return [StandardMultipleImageTextModule]
        attribute(:standard_multiple_image_text, StandardMultipleImageTextModule, from: "standardMultipleImageText")

        # @return [StandardProductDescriptionModule]
        attribute(:standard_product_description, StandardProductDescriptionModule, from: "standardProductDescription")

        # @return [StandardSingleImageHighlightsModule]
        attribute(:standard_single_image_highlights, StandardSingleImageHighlightsModule, from: "standardSingleImageHighlights")

        # @return [StandardSingleImageSpecsDetailModule]
        attribute(:standard_single_image_specs_detail, StandardSingleImageSpecsDetailModule, from: "standardSingleImageSpecsDetail")

        # @return [StandardSingleSideImageModule]
        attribute(:standard_single_side_image, StandardSingleSideImageModule, from: "standardSingleSideImage")

        # @return [StandardTechSpecsModule]
        attribute(:standard_tech_specs, StandardTechSpecsModule, from: "standardTechSpecs")

        # @return [StandardTextModule]
        attribute(:standard_text, StandardTextModule, from: "standardText")

        # @return [StandardThreeImageTextModule]
        attribute(:standard_three_image_text, StandardThreeImageTextModule, from: "standardThreeImageText")
      end
    end
  end
end

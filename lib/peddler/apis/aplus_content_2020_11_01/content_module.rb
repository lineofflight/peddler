# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # An A+ Content module. An A+ Content document is composed of content modules. The contentModuleType property
      # selects which content module types to use.
      ContentModule = Structure.new do
        # @return [String]
        attribute(:content_module_type, String, null: false, from: "contentModuleType")

        # @return [BrandStoryAboutModule]
        attribute?(:brand_story_about, BrandStoryAboutModule, from: "brandStoryAbout")

        # @return [BrandStoryFourASINModule]
        attribute?(:brand_story_four_asin, BrandStoryFourASINModule, from: "brandStoryFourAsin")

        # @return [BrandStoryImageWithLogoModule]
        attribute?(:brand_story_image_with_logo, BrandStoryImageWithLogoModule, from: "brandStoryImageWithLogo")

        # @return [BrandStoryMediaAssetModule]
        attribute?(:brand_story_media_asset, BrandStoryMediaAssetModule, from: "brandStoryMediaAsset")

        # @return [BrandStoryQuestionsModule]
        attribute?(:brand_story_questions, BrandStoryQuestionsModule, from: "brandStoryQuestions")

        # @return [PremiumComparisonCarouselModule]
        attribute?(:premium_comparison_carousel, PremiumComparisonCarouselModule, from: "premiumComparisonCarousel")

        # @return [PremiumComparisonScrollerModule]
        attribute?(:premium_comparison_scroller, PremiumComparisonScrollerModule, from: "premiumComparisonScroller")

        # @return [PremiumDualImageTextModule]
        attribute?(:premium_dual_image_text, PremiumDualImageTextModule, from: "premiumDualImageText")

        # @return [PremiumFaqModule]
        attribute?(:premium_faq, PremiumFaqModule, from: "premiumFaq")

        # @return [PremiumFourColumnImagesModule]
        attribute?(:premium_four_column_images, PremiumFourColumnImagesModule, from: "premiumFourColumnImages")

        # @return [PremiumFullBackgroundImageModule]
        attribute?(:premium_full_background_image, PremiumFullBackgroundImageModule, from: "premiumFullBackgroundImage")

        # @return [PremiumFullBackgroundTextModule]
        attribute?(:premium_full_background_text, PremiumFullBackgroundTextModule, from: "premiumFullBackgroundText")

        # @return [PremiumHeroVideoModule]
        attribute?(:premium_hero_video, PremiumHeroVideoModule, from: "premiumHeroVideo")

        # @return [PremiumHotspotImageModule]
        attribute?(:premium_hotspot_image, PremiumHotspotImageModule, from: "premiumHotspotImage")

        # @return [PremiumHotspotImageTextModule]
        attribute?(:premium_hotspot_image_text, PremiumHotspotImageTextModule, from: "premiumHotspotImageText")

        # @return [PremiumImageCarouselModule]
        attribute?(:premium_image_carousel, PremiumImageCarouselModule, from: "premiumImageCarousel")

        # @return [PremiumImageTextModule]
        attribute?(:premium_image_text, PremiumImageTextModule, from: "premiumImageText")

        # @return [PremiumNavigationCarouselModule]
        attribute?(:premium_navigation_carousel, PremiumNavigationCarouselModule, from: "premiumNavigationCarousel")

        # @return [PremiumRegimenCarouselModule]
        attribute?(:premium_regimen_carousel, PremiumRegimenCarouselModule, from: "premiumRegimenCarousel")

        # @return [PremiumTechSpecsModule]
        attribute?(:premium_tech_specs, PremiumTechSpecsModule, from: "premiumTechSpecs")

        # @return [PremiumTextModule]
        attribute?(:premium_text, PremiumTextModule, from: "premiumText")

        # @return [PremiumThreeColumnComparisonModule]
        attribute?(:premium_three_column_comparison, PremiumThreeColumnComparisonModule, from: "premiumThreeColumnComparison")

        # @return [PremiumVideoImageCarouselModule]
        attribute?(:premium_video_image_carousel, PremiumVideoImageCarouselModule, from: "premiumVideoImageCarousel")

        # @return [PremiumVideoTextModule]
        attribute?(:premium_video_text, PremiumVideoTextModule, from: "premiumVideoText")

        # @return [StandardCompanyLogoModule]
        attribute?(:standard_company_logo, StandardCompanyLogoModule, from: "standardCompanyLogo")

        # @return [StandardComparisonTableModule]
        attribute?(:standard_comparison_table, StandardComparisonTableModule, from: "standardComparisonTable")

        # @return [StandardFourImageTextModule]
        attribute?(:standard_four_image_text, StandardFourImageTextModule, from: "standardFourImageText")

        # @return [StandardFourImageTextQuadrantModule]
        attribute?(:standard_four_image_text_quadrant, StandardFourImageTextQuadrantModule, from: "standardFourImageTextQuadrant")

        # @return [StandardHeaderImageTextModule]
        attribute?(:standard_header_image_text, StandardHeaderImageTextModule, from: "standardHeaderImageText")

        # @return [StandardImageSidebarModule]
        attribute?(:standard_image_sidebar, StandardImageSidebarModule, from: "standardImageSidebar")

        # @return [StandardImageTextOverlayModule]
        attribute?(:standard_image_text_overlay, StandardImageTextOverlayModule, from: "standardImageTextOverlay")

        # @return [StandardMultipleImageTextModule]
        attribute?(:standard_multiple_image_text, StandardMultipleImageTextModule, from: "standardMultipleImageText")

        # @return [StandardProductDescriptionModule]
        attribute?(:standard_product_description, StandardProductDescriptionModule, from: "standardProductDescription")

        # @return [StandardSingleImageHighlightsModule]
        attribute?(:standard_single_image_highlights, StandardSingleImageHighlightsModule, from: "standardSingleImageHighlights")

        # @return [StandardSingleImageSpecsDetailModule]
        attribute?(:standard_single_image_specs_detail, StandardSingleImageSpecsDetailModule, from: "standardSingleImageSpecsDetail")

        # @return [StandardSingleSideImageModule]
        attribute?(:standard_single_side_image, StandardSingleSideImageModule, from: "standardSingleSideImage")

        # @return [StandardTechSpecsModule]
        attribute?(:standard_tech_specs, StandardTechSpecsModule, from: "standardTechSpecs")

        # @return [StandardTextModule]
        attribute?(:standard_text, StandardTextModule, from: "standardText")

        # @return [StandardThreeImageTextModule]
        attribute?(:standard_three_image_text, StandardThreeImageTextModule, from: "standardThreeImageText")
      end
    end
  end
end

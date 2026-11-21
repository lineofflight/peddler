# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # An A+ Content module. An A+ Content document is composed of content modules. The contentModuleType property
      # selects which content module types to use.
      ContentModule = Structure.new do
        # Known values: `STANDARD_COMPANY_LOGO`, `STANDARD_COMPARISON_TABLE`, `STANDARD_FOUR_IMAGE_TEXT`,
        # `STANDARD_FOUR_IMAGE_TEXT_QUADRANT`, `STANDARD_HEADER_IMAGE_TEXT`, `STANDARD_IMAGE_SIDEBAR`,
        # `STANDARD_IMAGE_TEXT_OVERLAY`, `STANDARD_MULTIPLE_IMAGE_TEXT`, `STANDARD_PRODUCT_DESCRIPTION`,
        # `STANDARD_SINGLE_IMAGE_HIGHLIGHTS`, `STANDARD_SINGLE_IMAGE_SPECS_DETAIL`, `STANDARD_SINGLE_SIDE_IMAGE`,
        # `STANDARD_TECH_SPECS`, `STANDARD_TEXT`, `STANDARD_THREE_IMAGE_TEXT`, `PREMIUM_IMAGE_TEXT`, `PREMIUM_TEXT`,
        # `PREMIUM_FULL_BACKGROUND_TEXT`, `PREMIUM_FULL_BACKGROUND_IMAGE`, `PREMIUM_FOUR_COLUMN_IMAGES`,
        # `PREMIUM_DUAL_IMAGE_TEXT`, `PREMIUM_IMAGE_CAROUSEL`, `PREMIUM_NAVIGATION_CAROUSEL`,
        # `PREMIUM_REGIMEN_CAROUSEL`, `PREMIUM_THREE_COLUMN_COMPARISON`, `PREMIUM_COMPARISON_CAROUSEL`,
        # `PREMIUM_COMPARISON_SCROLLER`, `PREMIUM_HOTSPOT_IMAGE`, `PREMIUM_HOTSPOT_IMAGE_TEXT`, `PREMIUM_FAQ`,
        # `PREMIUM_TECH_SPECS`, `PREMIUM_VIDEO_TEXT`, `PREMIUM_HERO_VIDEO`, `PREMIUM_VIDEO_IMAGE_CAROUSEL`,
        # `BRAND_STORY_IMAGE_WITH_LOGO`, `BRAND_STORY_FOUR_ASIN`, `BRAND_STORY_MEDIA_ASSET`, `BRAND_STORY_ABOUT`,
        # `BRAND_STORY_QUESTIONS`.
        attribute(:content_module_type, String, null: false, from: "contentModuleType")

        attribute?(:brand_story_about, BrandStoryAboutModule, from: "brandStoryAbout")

        attribute?(:brand_story_four_asin, BrandStoryFourASINModule, from: "brandStoryFourAsin")

        attribute?(:brand_story_image_with_logo, BrandStoryImageWithLogoModule, from: "brandStoryImageWithLogo")

        attribute?(:brand_story_media_asset, BrandStoryMediaAssetModule, from: "brandStoryMediaAsset")

        attribute?(:brand_story_questions, BrandStoryQuestionsModule, from: "brandStoryQuestions")

        attribute?(:premium_comparison_carousel, PremiumComparisonCarouselModule, from: "premiumComparisonCarousel")

        attribute?(:premium_comparison_scroller, PremiumComparisonScrollerModule, from: "premiumComparisonScroller")

        attribute?(:premium_dual_image_text, PremiumDualImageTextModule, from: "premiumDualImageText")

        attribute?(:premium_faq, PremiumFaqModule, from: "premiumFaq")

        attribute?(:premium_four_column_images, PremiumFourColumnImagesModule, from: "premiumFourColumnImages")

        attribute?(:premium_full_background_image, PremiumFullBackgroundImageModule, from: "premiumFullBackgroundImage")

        attribute?(:premium_full_background_text, PremiumFullBackgroundTextModule, from: "premiumFullBackgroundText")

        attribute?(:premium_hero_video, PremiumHeroVideoModule, from: "premiumHeroVideo")

        attribute?(:premium_hotspot_image, PremiumHotspotImageModule, from: "premiumHotspotImage")

        attribute?(:premium_hotspot_image_text, PremiumHotspotImageTextModule, from: "premiumHotspotImageText")

        attribute?(:premium_image_carousel, PremiumImageCarouselModule, from: "premiumImageCarousel")

        attribute?(:premium_image_text, PremiumImageTextModule, from: "premiumImageText")

        attribute?(:premium_navigation_carousel, PremiumNavigationCarouselModule, from: "premiumNavigationCarousel")

        attribute?(:premium_regimen_carousel, PremiumRegimenCarouselModule, from: "premiumRegimenCarousel")

        attribute?(:premium_tech_specs, PremiumTechSpecsModule, from: "premiumTechSpecs")

        attribute?(:premium_text, PremiumTextModule, from: "premiumText")

        attribute?(:premium_three_column_comparison, PremiumThreeColumnComparisonModule, from: "premiumThreeColumnComparison")

        attribute?(:premium_video_image_carousel, PremiumVideoImageCarouselModule, from: "premiumVideoImageCarousel")

        attribute?(:premium_video_text, PremiumVideoTextModule, from: "premiumVideoText")

        attribute?(:standard_company_logo, StandardCompanyLogoModule, from: "standardCompanyLogo")

        attribute?(:standard_comparison_table, StandardComparisonTableModule, from: "standardComparisonTable")

        attribute?(:standard_four_image_text, StandardFourImageTextModule, from: "standardFourImageText")

        attribute?(:standard_four_image_text_quadrant, StandardFourImageTextQuadrantModule, from: "standardFourImageTextQuadrant")

        attribute?(:standard_header_image_text, StandardHeaderImageTextModule, from: "standardHeaderImageText")

        attribute?(:standard_image_sidebar, StandardImageSidebarModule, from: "standardImageSidebar")

        attribute?(:standard_image_text_overlay, StandardImageTextOverlayModule, from: "standardImageTextOverlay")

        attribute?(:standard_multiple_image_text, StandardMultipleImageTextModule, from: "standardMultipleImageText")

        attribute?(:standard_product_description, StandardProductDescriptionModule, from: "standardProductDescription")

        attribute?(:standard_single_image_highlights, StandardSingleImageHighlightsModule, from: "standardSingleImageHighlights")

        attribute?(:standard_single_image_specs_detail, StandardSingleImageSpecsDetailModule, from: "standardSingleImageSpecsDetail")

        attribute?(:standard_single_side_image, StandardSingleSideImageModule, from: "standardSingleSideImage")

        attribute?(:standard_tech_specs, StandardTechSpecsModule, from: "standardTechSpecs")

        attribute?(:standard_text, StandardTextModule, from: "standardText")

        attribute?(:standard_three_image_text, StandardThreeImageTextModule, from: "standardThreeImageText")
      end
    end
  end
end

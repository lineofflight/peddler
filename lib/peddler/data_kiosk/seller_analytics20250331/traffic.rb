# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Traffic metric group. A null value for a given metric means that this metric is not yet available.
      Traffic = Structure.new do
        # Browser page views are the number of times a user visited your Amazon.com browser pages for the selected time
        # period.
        attribute?(:browser_page_views, IntWithBenchmarking, from: "browserPageViews")

        # Browser sessions are visits to your Amazon.com browser pages by a user. All browser activity within a 24-hour
        # period is considered a browser session. For example, if a user visits your pages using a browser multiple
        # times within a 24 hour period it is counted as a single browser session.
        attribute?(:browser_sessions, IntWithBenchmarking, from: "browserSessions")

        # The conversion rate describes the successful transition of a customer from clicks to purchase.
        # This metric includes the percentage of purchases to clicks for ASINs originated from the search results page.
        attribute?(:conversation_rate_pct, FloatWithBenchmarking, from: "conversationRatePct")

        # The conversion rate describes the successful transition of a customer from clicks to purchase.
        # This metric includes the percentage of purchases to clicks for ASINs originated from the search results page.
        attribute?(:conversion_rate_pct, FloatWithBenchmarking, from: "conversionRatePct")

        # Featured Offer glance views is the count of glance views where your product appeared as the Featured Offer on
        # the search results page.
        attribute?(:feature_offer_glance_views, IntWithBenchmarking, from: "featureOfferGlanceViews")

        # Featured Offer percentage shows how often your offer is the Featured Offer when customers can add to their
        # cart.
        # It's calculated by dividing the number of times your offer is the Featured Offer by the number of times
        # customers viewed it (that is, Glance Views).
        attribute?(:feature_offer_pct, FloatWithBenchmarking, from: "featureOfferPct")

        # Glance views is the number of times customers actively engage with your product detail page.
        attribute?(:glance_views, IntWithBenchmarking, from: "glanceViews")

        # Glance views B2B is the number of times customers actively engage with your product detail page.
        # Note: This field is only populated if you are a B2B seller on Amazon.
        attribute?(:glance_views_b2b, IntWithBenchmarking, from: "glanceViewsB2B")

        # Mobile app page views are the number of times a user visited your Amazon.com mobile app pages for the selected
        # time period.
        attribute?(:mobile_app_page_views, IntWithBenchmarking, from: "mobileAppPageViews")

        # Mobile app sessions are visits to your Amazon.com mobile app pages by a user.
        # All mobile app activity within a 24-hour period is considered a mobile app session. For example, if a user
        # visits your pages using a mobile app multiple times within a 24 hour period it is counted as a single mobile
        # app session.
        attribute?(:mobile_app_sessions, IntWithBenchmarking, from: "mobileAppSessions")

        # Page views are the number of times a user visited your Amazon.com browser or mobile app pages for the selected
        # time period. It is calculated as the sum of browserPageViews and mobileAppPageViews.
        attribute?(:page_views, IntWithBenchmarking, from: "pageViews")

        # Sessions are visits to your Amazon.com browser or mobile app pages by a user.
        # All browser and mobile app activity within a 24-hour period is considered a session. It is calculated as the
        # sum of browserSessions and mobileAppSessions.
        attribute?(:sessions, IntWithBenchmarking)
      end
    end
  end
end

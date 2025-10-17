# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The traffic data for the seller's account aggregated by date.
      ByDateTraffic = Structure.new do
        # @return [String] The average number of offers listed for sale in the selected time period. It is calculated
        #   from the total number of offers and the total number of days in the selected time period.
        attribute?(:average_offer_count, String, null: false, from: "averageOfferCount")

        # @return [String] The average number of parent items listed for sale in the selected time period.
        attribute?(:average_parent_items, String, null: false, from: "averageParentItems")

        # @return [String] Browser page views are the number of times a user visited your Amazon.com browser pages for
        #   the selected time period.
        attribute?(:browser_page_views, String, null: false, from: "browserPageViews")

        # @return [String] Browser B2B page views are the number of times an Amazon Business customer visited your
        #   Amazon.com browser pages for the selected time period. Note: This field is only populated when the seller is
        #   a B2B seller.
        attribute?(:browser_page_views_b2b, String, from: "browserPageViewsB2B")

        # @return [String] Browser sessions are visits to your Amazon.com browser pages by a user. All browser activity
        #   within a 24-hour period is considered a browser session. For example, if a user visits your pages using a
        #   browser multiple times within a 24 hour period it is counted as a single browser session.
        attribute?(:browser_sessions, String, null: false, from: "browserSessions")

        # @return [String] Browser B2B sessions are visits to your Amazon.com browser pages by an Amazon Business
        #   customer. All activity within a 24-hour period is considered a browser session. For example, if an Amazon
        #   Business customer visits your pages using browser multiple times within a 24 hour period it is counted as a
        #   single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_sessions_b2b, String, from: "browserSessionsB2B")

        # @return [Float] The percentage of page views where the buy box (the add to shopping cart link) appeared on the
        #   page for customers to add your product to their cart.
        attribute?(:buy_box_percentage, Float, null: false, from: "buyBoxPercentage")

        # @return [Float] The percentage of page views by Amazon Business customers where the buy box (the add to
        #   shopping cart link) appeared on the page for customers to add your product to their cart. Note: This field
        #   is only populated when the seller is a B2B seller.
        attribute?(:buy_box_percentage_b2b, Float, from: "buyBoxPercentageB2B")

        # @return [String] The number of times customers left feedback in the selected time period.
        attribute?(:feedback_received, String, null: false, from: "feedbackReceived")

        # @return [String] Mobile app page views are the number of times a user visited your Amazon.com mobile app pages
        #   for the selected time period.
        attribute?(:mobile_app_page_views, String, null: false, from: "mobileAppPageViews")

        # @return [String] Mobile app B2B page views are the number of times an Amazon Business customer visited your
        #   Amazon.com mobile app pages for the selected time period. Note:
        # This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_page_views_b2b, String, from: "mobileAppPageViewsB2B")

        # @return [String] Mobile app sessions are visits to your Amazon.com mobile app pages by a user.
        # All mobile app activity within a 24-hour period is considered a mobile app session. For example, if a user
        #   visits your pages using a mobile app multiple times within a 24 hour period it is counted as a single mobile
        #   app session.
        attribute?(:mobile_app_sessions, String, null: false, from: "mobileAppSessions")

        # @return [String] Mobile app B2B sessions are visits to your Amazon.com mobile app pages by an Amazon Business
        #   customer. All activity within a 24-hour period is considered a mobile app session. For example, if an Amazon
        #   Business customer visits your pages using mobile app multiple times within a 24 hour period it is counted as
        #   a single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_sessions_b2b, String, from: "mobileAppSessionsB2B")

        # @return [String] The number of times customers left negative feedback in the selected time period.
        attribute?(:negative_feedback_received, String, null: false, from: "negativeFeedbackReceived")

        # @return [Float] The percentage conversion metric indicating how many order items were generated relative to
        #   the number of people who viewed the products.
        attribute?(:order_item_session_percentage, Float, null: false, from: "orderItemSessionPercentage")

        # @return [Float] The percentage conversion metric indicating how many order items were generated by Amazon
        #   Business customers relative to the number of Amazon Business customers who viewed the products. Note: This
        #   field is only populated when the seller is a B2B seller.
        attribute?(:order_item_session_percentage_b2b, Float, from: "orderItemSessionPercentageB2B")

        # @return [String] Page views are the number of times a user visited your Amazon.com browser or mobile app pages
        #   for the selected time period. It is calculated as the sum of browserPageViews and mobileAppPageViews.
        attribute?(:page_views, String, null: false, from: "pageViews")

        # @return [String] B2B page views are the number of times an Amazon Business customer visited your Amazon.com
        #   pages using browser or mobile app for the selected time period. Note: This field is only populated when the
        #   seller is a B2B seller.
        attribute?(:page_views_b2b, String, from: "pageViewsB2B")

        # @return [Float] The negative feedback rate is the number of orders that have received negative feedback
        #   divided by the number of orders in the selected time period.
        attribute?(:received_negative_feedback_rate, Float, null: false, from: "receivedNegativeFeedbackRate")

        # @return [String] Sessions are visits to your Amazon.com browser or mobile app pages by a user.
        # All browser and mobile app activity within a 24-hour period is considered a session. It is calculated as the
        #   sum of browserSessions and mobileAppSessions.
        attribute?(:sessions, String, null: false)

        # @return [String] B2B sessions are visits to your Amazon.com pages using browser or mobile app by an Amazon
        #   Business customer. All activity within a 24-hour period is considered a session. For example, if an Amazon
        #   Business customer visits your pages multiple times using mobile app or browser within a 24 hour period it is
        #   counted as a single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:sessions_b2b, String, from: "sessionsB2B")

        # @return [Float] The percentage conversion metric indicating how many units were purchased relative to the
        #   number of people who viewed the products.
        attribute?(:unit_session_percentage, Float, null: false, from: "unitSessionPercentage")

        # @return [Float] The percentage conversion metric indicating how many units were purchased by Amazon Business
        #   customers relative to number of Amazon Business customers who viewed the products. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:unit_session_percentage_b2b, Float, from: "unitSessionPercentageB2B")
      end
    end
  end
end

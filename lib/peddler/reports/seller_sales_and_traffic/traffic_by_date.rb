# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing traffic metrics for ASINs in the seller's account aggregated by date.
      TrafficByDate = Structure.new do
        # @return [Integer] The average number of offers listed for sale in the selected time period. It is calculated
        #   from the total number of offers and the total number of days in the selected time period.
        attribute(:average_offer_count, Integer, null: false, from: "averageOfferCount")

        # @return [Integer] The average number of parent items listed for sale in the selected time period.
        attribute(:average_parent_items, Integer, null: false, from: "averageParentItems")

        # @return [Integer] Browser page views are the number of times any user visited your Amazon.com browser pages
        #   for the selected time period.
        attribute(:browser_page_views, Integer, null: false, from: "browserPageViews")

        # @return [Integer] Browser sessions are visits to your Amazon.com browser pages by any user. All activity
        #   within a 24-hour period is considered a browser session. For example, if any user visits your pages using
        #   browser multiple times within a 24 hour period it is counted as a single session.
        attribute(:browser_sessions, Integer, null: false, from: "browserSessions")

        # @return [Float] The percentage of page views where the buy box (the add to shopping cart link) appeared on the
        #   page for customers to add your product to their cart.
        attribute(:buy_box_percentage, Float, null: false, from: "buyBoxPercentage")

        # @return [Integer] The number of customer feedback received in the selected time period.
        attribute(:feedback_received, Integer, null: false, from: "feedbackReceived")

        # @return [Integer] Mobile app page views are the number of times any user visited your Amazon.com mobile app
        #   pages for the selected time period.
        attribute(:mobile_app_page_views, Integer, null: false, from: "mobileAppPageViews")

        # @return [Integer] Mobile app sessions are visits to your Amazon.com mobile app pages by any user. All activity
        #   within a 24-hour period is considered a mobile app session. For example, if any user visits your pages using
        #   mobile app multiple times within a 24 hour period it is counted as a single session.
        attribute(:mobile_app_sessions, Integer, null: false, from: "mobileAppSessions")

        # @return [Integer] The number of negative customer feedback received in the selected time period.
        attribute(:negative_feedback_received, Integer, null: false, from: "negativeFeedbackReceived")

        # @return [Float] The percentage conversion metric indicating how many order items were generated relative to
        #   the number of people who viewed the products.
        attribute(:order_item_session_percentage, Float, null: false, from: "orderItemSessionPercentage")

        # @return [Integer] Page views are the number of times any user visited your Amazon.com pages using browser or
        #   mobile app for the selected time period.
        attribute(:page_views, Integer, null: false, from: "pageViews")

        # @return [Float] The negative feedback rate is the number of orders that have received a negative feedback
        #   divided by the number of orders in the selected time period.
        attribute(:received_negative_feedback_rate, Float, null: false, from: "receivedNegativeFeedbackRate")

        # @return [Integer] Sessions are visits to your Amazon.com pages using browser or mobile app by any user. All
        #   activity within a 24-hour period is considered a session. For example, if any user visits your pages
        #   multiple times using mobile app or browser within a 24 hour period it is counted as a single session.
        attribute(:sessions, Integer, null: false)

        # @return [Float] The percentage conversion metric indicating how many units were purchased relative to the
        #   number of people who viewed the products.
        attribute(:unit_session_percentage, Float, null: false, from: "unitSessionPercentage")

        # @return [Integer] Browser B2B page views are the number of times an Amazon Business customer visited your
        #   Amazon.com browser pages for the selected time period. Note: This field is only populated when the seller is
        #   a B2B seller.
        attribute?(:browser_page_views_b2b, Integer, from: "browserPageViewsB2B")

        # @return [Integer] Browser B2B sessions are visits to your Amazon.com browser pages by an Amazon Business
        #   customer. All activity within a 24-hour period is considered a browser session. For example, if an Amazon
        #   Business customer visits your pages using browser multiple times within a 24 hour period it is counted as a
        #   single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_sessions_b2b, Integer, from: "browserSessionsB2B")

        # @return [Float] The percentage of page views by Amazon Business customers where the buy box (the add to
        #   shopping cart link) appeared on the page for customers to add your product to their cart. Note: This field
        #   is only populated when the seller is a B2B seller.
        attribute?(:buy_box_percentage_b2b, Float, from: "buyBoxPercentageB2B")

        # @return [Integer] Mobile app B2B page views are the number of times an Amazon Business customer visited your
        #   Amazon.com mobile app pages for the selected time period. Note: This field is only populated when the seller
        #   is a B2B seller.
        attribute?(:mobile_app_page_views_b2b, Integer, from: "mobileAppPageViewsB2B")

        # @return [Integer] Mobile app B2B sessions are visits to your Amazon.com mobile app pages by an Amazon Business
        #   customer. All activity within a 24-hour period is considered a mobile app session. For example, if an Amazon
        #   Business customer visits your pages using mobile app multiple times within a 24 hour period it is counted as
        #   a single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_sessions_b2b, Integer, from: "mobileAppSessionsB2B")

        # @return [Float] The percentage conversion metric indicating how many order items were generated by Amazon
        #   Business customers relative to the number of Amazon Business customers who viewed the products. Note: This
        #   field is only populated when the seller is a B2B seller.
        attribute?(:order_item_session_percentage_b2b, Float, from: "orderItemSessionPercentageB2B")

        # @return [Integer] B2B page views are the number of times an Amazon Business customer visited your Amazon.com
        #   pages using browser or mobile app for the selected time period. Note: This field is only populated when the
        #   seller is a B2B seller.
        attribute?(:page_views_b2b, Integer, from: "pageViewsB2B")

        # @return [Integer] B2B sessions are visits to your Amazon.com pages using browser or mobile app by an Amazon
        #   Business customer. All activity within a 24-hour period is considered a session. For example, if an Amazon
        #   Business customer visits your pages multiple times using mobile app or browser within a 24 hour period it is
        #   counted as a single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:sessions_b2b, Integer, from: "sessionsB2B")

        # @return [Float] The percentage conversion metric indicating how many units were purchased by Amazon Business
        #   customers relative to number of Amazon Business customers who viewed the products. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:unit_session_percentage_b2b, Float, from: "unitSessionPercentageB2B")
      end
    end
  end
end

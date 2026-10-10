# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing traffic metrics for ASINs in the seller's account aggregated by ASIN.
      TrafficByASIN = Structure.new do
        # Browser page views are the number of times any user visited your Amazon.com browser pages for the selected
        # time period.
        attribute(:browser_page_views, Integer, null: false, from: "browserPageViews")

        # The percentage of browser views that a particular SKU/ASIN receives relative to the total number of mobile
        # page views for all products.
        attribute(:browser_page_views_percentage, Float, null: false, from: "browserPageViewsPercentage")

        # The percentage of browser sessions that contain at least one page view for a particular SKU/ASIN relative to
        # the total number of browser sessions for all products.
        attribute(:browser_session_percentage, Float, null: false, from: "browserSessionPercentage")

        # Browser sessions are visits to your Amazon.com browser pages by any user. All activity within a 24-hour period
        # is considered a browser session. For example, if any user visits your pages using browser multiple times
        # within a 24 hour period it is counted as a single session.
        attribute(:browser_sessions, Integer, null: false, from: "browserSessions")

        # The percentage of page views where the buy box (the add to shopping cart link) appeared on the page for
        # customers to add your product to their cart.
        attribute(:buy_box_percentage, Float, null: false, from: "buyBoxPercentage")

        # Mobile app page views are the number of times any user visited your Amazon.com mobile app pages for the
        # selected time period.
        attribute(:mobile_app_page_views, Integer, null: false, from: "mobileAppPageViews")

        # The percentage of mobile page views that a particular SKU/ASIN receives relative to the total number of mobile
        # page views for all products.
        attribute(:mobile_app_page_views_percentage, Float, null: false, from: "mobileAppPageViewsPercentage")

        # The percentage of mobile app sessions that contain at least one page view for a particular SKU/ASIN relative
        # to the total number of mobile app sessions for all products.
        attribute(:mobile_app_session_percentage, Float, null: false, from: "mobileAppSessionPercentage")

        # Mobile app sessions are visits to your Amazon.com mobile app pages by any user. All activity within a 24-hour
        # period is considered a mobile app session. For example, if any user visits your pages using mobile app
        # multiple times within a 24 hour period it is counted as a single session.
        attribute(:mobile_app_sessions, Integer, null: false, from: "mobileAppSessions")

        # Page views are the number of times any user visited your Amazon.com pages using browser or mobile app for the
        # selected time period.
        attribute(:page_views, Integer, null: false, from: "pageViews")

        # The percentage of page views that a particular SKU/ASIN receives relative to the total number of page views
        # for all products.
        attribute(:page_views_percentage, Float, null: false, from: "pageViewsPercentage")

        # The percentage of sessions that contain at least one page view for a particular SKU/ASIN relative to the total
        # number of sessions for all products.
        attribute(:session_percentage, Float, null: false, from: "sessionPercentage")

        # Sessions are visits to your Amazon.com pages using mobile app or browser by any user. All activity within a
        # 24-hour period is considered a session. For example, if any user visits your pages multiple times within a 24
        # hour period it is counted as a single session.
        attribute(:sessions, Integer, null: false)

        # The percentage conversion metric indicating how many units were purchased relative to the number of people who
        # viewed the products, calculated by dividing unitsOrdered by sessions.
        attribute(:unit_session_percentage, Float, null: false, from: "unitSessionPercentage")

        # Browser page views are the number of times an Amazon Business customer visited your Amazon.com browser pages
        # for the selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_page_views_b2b, Integer, from: "browserPageViewsB2B")

        # The percentage of browser views by Amazon Business customers that a particular SKU/ASIN receives relative to
        # the total number of mobile page views by Amazon Business customers for all products. Note: This field is only
        # populated when the seller is a B2B seller.
        attribute?(:browser_page_views_percentage_b2b, Float, from: "browserPageViewsPercentageB2B")

        # The percentage of browser sessions that contain at least one page view by an Amazon Business customer for a
        # particular SKU/ASIN relative to the total number of browser sessions by Amazon Business customers for all
        # products. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_session_percentage_b2b, Float, from: "browserSessionPercentageB2B")

        # Browser B2B sessions are visits to your Amazon.com browser pages by an Amazon Business customer. All activity
        # within a 24-hour period is considered a browser session. For example, if an Amazon Business customer visits
        # your pages using browser multiple times within a 24 hour period it is counted as a single session. Note: This
        # field is only populated when the seller is a B2B seller.
        attribute?(:browser_sessions_b2b, Integer, from: "browserSessionsB2B")

        # The percentage of page views by Amazon Business customers where the buy box (the add to shopping cart link)
        # appeared on the page for customers to add your product to their cart. Note: This field is only populated when
        # the seller is a B2B seller.
        attribute?(:buy_box_percentage_b2b, Float, from: "buyBoxPercentageB2B")

        # Mobile app B2B page views are the number of times an Amazon Business customer visited your Amazon.com mobile
        # app pages for the selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_page_views_b2b, Integer, from: "mobileAppPageViewsB2B")

        # The percentage of mobile page views by Amazon Business customers that a particular SKU/ASIN receives relative
        # to the total number of mobile page views by Amazon Business customers for all products. Note: This field is
        # only populated when the seller is a B2B seller.
        attribute?(:mobile_app_page_views_percentage_b2b, Float, from: "mobileAppPageViewsPercentageB2B")

        # The percentage of mobile app sessions that contain at least one page view by an Amazon Business customer for a
        # particular SKU/ASIN relative to the total number of mobile app sessions by Amazon Business customers for all
        # products. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_session_percentage_b2b, Float, from: "mobileAppSessionPercentageB2B")

        # Mobile app B2B sessions are visits to your Amazon.com mobile app pages by an Amazon Business customer. All
        # activity within a 24-hour period is considered a mobile app session. For example, if an Amazon Business
        # customer visits your pages using mobile app multiple times within a 24 hour period it is counted as a single
        # session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_sessions_b2b, Integer, from: "mobileAppSessionsB2B")

        # B2B page views are the number of times an Amazon Business customer visited your Amazon.com pages using browser
        # or mobile app for the selected time period. Note: This field is only populated when the seller is a B2B
        # seller.
        attribute?(:page_views_b2b, Integer, from: "pageViewsB2B")

        # The percentage of page views by Amazon Business customers that a particular SKU/ASIN receives relative to the
        # total number of page views by Amazon Business customers for all products. Note: This field is only populated
        # when the seller is a B2B seller.
        attribute?(:page_views_percentage_b2b, Float, from: "pageViewsPercentageB2B")

        # The percentage of sessions that contain at least one page view by an Amazon Business customer for a particular
        # SKU/ASIN relative to the total number of sessions by Amazon Business customers for all products. Note: This
        # field is only populated when the seller is a B2B seller.
        attribute?(:session_percentage_b2b, Float, from: "sessionPercentageB2B")

        # B2B sessions are visits to your Amazon.com pages by Amazon Business customers using mobile app or browser. All
        # activity within a 24-hour period is considered a session. For example, if an Amazon Business customer visits
        # your pages multiple times within a 24 hour period it is counted as a single session. Note: This field is only
        # populated when the seller is a B2B seller.
        attribute?(:sessions_b2b, Integer, from: "sessionsB2B")

        # The percentage conversion metric indicating how many units were purchased by Amazon Business customers
        # relative to the number of Amazon Business customers who viewed the products, calculated by dividing
        # unitsOrderedB2B by sessions. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:unit_session_percentage_b2b, Float, from: "unitSessionPercentageB2B")
      end
    end
  end
end

# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20231115
      # The traffic data for the seller's account aggregated by ASIN.
      ByASINTraffic = Structure.new do
        # @return [String] Browser page views are the number of times a user visited your Amazon.com browser pages for
        # the selected time period.
        attribute?(:browser_page_views, String, from: "browserPageViews")

        # @return [String] Browser B2B page views are the number of times an Amazon Business customer
        # visited your Amazon.com browser pages for the selected time period. Note: This
        # field is only populated when the seller is a B2B seller.
        attribute?(:browser_page_views_b2b, String, from: "browserPageViewsB2B")

        # @return [Float] The percentage of browser page views that a particular SKU/ASIN receives
        # relative to the total number of browser page views for all products.
        attribute?(:browser_page_views_percentage, Float, from: "browserPageViewsPercentage")

        # @return [Float] The percentage of browser views by Amazon Business customers that a particular
        # SKU/ASIN receives relative to the total number of mobile page views by Amazon
        # Business customers for all products. Note: This field is only populated when
        # the seller is a B2B seller.
        attribute?(:browser_page_views_percentage_b2b, Float, from: "browserPageViewsPercentageB2B")

        # @return [Float] The percentage of browser sessions that contain at least one page view for a
        # particular SKU/ASIN relative to the total number of browser sessions for all products.
        attribute?(:browser_session_percentage, Float, from: "browserSessionPercentage")

        # @return [Float] The percentage of browser sessions that contain at least one page view by an
        # Amazon Business customer for a particular SKU/ASIN relative to the total
        # number of browser sessions by Amazon Business customers for all products.
        # Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_session_percentage_b2b, Float, from: "browserSessionPercentageB2B")

        # @return [String] Browser sessions are visits to your Amazon.com browser pages by a user. All
        # browser activity within a 24-hour period is considered a browser session. For
        # example, if a user visits your pages using a browser multiple times within a
        # 24 hour period it is counted as a single browser session.
        attribute?(:browser_sessions, String, from: "browserSessions")

        # @return [String] Browser B2B sessions are visits to your Amazon.com browser pages by an Amazon
        # Business customer. All activity within a 24-hour period is considered a
        # browser session. For example, if an Amazon Business customer visits your pages
        # using browser multiple times within a 24 hour period it is counted as a single
        # session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:browser_sessions_b2b, String, from: "browserSessionsB2B")

        # @return [Float] The percentage of page views where the buy box (the add to shopping cart link)
        # appeared on the page for customers to add your product to their cart.
        attribute?(:buy_box_percentage, Float, from: "buyBoxPercentage")

        # @return [Float] The percentage of page views by Amazon Business customers where the buy box
        # (the add to shopping cart link) appeared on the page for customers to add your
        # product to their cart. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:buy_box_percentage_b2b, Float, from: "buyBoxPercentageB2B")

        # @return [String] Mobile app page views are the number of times a user visited your Amazon.com
        # mobile app pages for the selected time period.
        attribute?(:mobile_app_page_views, String, from: "mobileAppPageViews")

        # @return [String] Mobile app B2B page views are the number of times an Amazon Business customer
        # visited your Amazon.com mobile app pages for the selected time period. Note:
        # This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_page_views_b2b, String, from: "mobileAppPageViewsB2B")

        # @return [Float] The percentage of mobile app page views that a particular SKU/ASIN receives
        # relative to the total number of mobile app page views for all products.
        attribute?(:mobile_app_page_views_percentage, Float, from: "mobileAppPageViewsPercentage")

        # @return [Float] The percentage of mobile page views by Amazon Business customers that a
        # particular SKU/ASIN receives relative to the total number of mobile page views
        # by Amazon Business customers for all products. Note: This field is only
        # populated when the seller is a B2B seller.
        attribute?(:mobile_app_page_views_percentage_b2b, Float, from: "mobileAppPageViewsPercentageB2B")

        # @return [Float] The percentage of mobile app sessions that contain at least one page view for
        # a particular SKU/ASIN relative to the total number of mobile app sessions for all products.
        attribute?(:mobile_app_session_percentage, Float, from: "mobileAppSessionPercentage")

        # @return [Float] The percentage of mobile app sessions that contain at least one page view by
        # an Amazon Business customer for a particular SKU/ASIN relative to the total
        # number of mobile app sessions by Amazon Business customers for all products.
        # Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_session_percentage_b2b, Float, from: "mobileAppSessionPercentageB2B")

        # @return [String] Mobile app sessions are visits to your Amazon.com mobile app pages by a user.
        # All mobile app activity within a 24-hour period is considered a mobile app
        # session. For example, if a user visits your pages using a mobile app multiple
        # times within a 24 hour period it is counted as a single mobile app session.
        attribute?(:mobile_app_sessions, String, from: "mobileAppSessions")

        # @return [String] Mobile app B2B sessions are visits to your Amazon.com mobile app pages by an
        # Amazon Business customer. All activity within a 24-hour period is considered a
        # mobile app session. For example, if an Amazon Business customer visits your
        # pages using mobile app multiple times within a 24 hour period it is counted as
        # a single session. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:mobile_app_sessions_b2b, String, from: "mobileAppSessionsB2B")

        # @return [String] Page views are the number of times a user visited your Amazon.com browser or
        # mobile app pages for the selected time period. It is calculated as the sum of
        # browserPageViews and mobileAppPageViews.
        attribute?(:page_views, String, from: "pageViews")

        # @return [String] B2B page views are the number of times an Amazon Business customer visited
        # your Amazon.com pages using browser or mobile app for the selected time
        # period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:page_views_b2b, String, from: "pageViewsB2B")

        # @return [Float] The percentage of browser and mobile app page views that a particular SKU/ASIN
        # receives relative to the total number of browser and mobile app page views for all products.
        attribute?(:page_views_percentage, Float, from: "pageViewsPercentage")

        # @return [Float] The percentage of page views by Amazon Business customers that a particular
        # SKU/ASIN receives relative to the total number of page views by Amazon
        # Business customers for all products. Note: This field is only populated when
        # the seller is a B2B seller.
        attribute?(:page_views_percentage_b2b, Float, from: "pageViewsPercentageB2B")

        # @return [Float] The percentage of sessions that contain at least one page view for a
        # particular SKU/ASIN relative to the total number of sessions for all products.
        attribute?(:session_percentage, Float, from: "sessionPercentage")

        # @return [Float] The percentage of sessions that contain at least one page view by an Amazon
        # Business customer for a particular SKU/ASIN relative to the total number of
        # sessions by Amazon Business customers for all products. Note: This field is
        # only populated when the seller is a B2B seller.
        attribute?(:session_percentage_b2b, Float, from: "sessionPercentageB2B")

        # @return [String] Sessions are visits to your Amazon.com browser or mobile app pages by a user.
        # All browser and mobile app activity within a 24-hour period is considered a
        # session. It is calculated as the sum of browserSessions and mobileAppSessions.
        attribute?(:sessions, String)

        # @return [String] B2B sessions are visits to your Amazon.com pages using browser or mobile app
        # by an Amazon Business customer. All activity within a 24-hour period is
        # considered a session. For example, if an Amazon Business customer visits your
        # pages multiple times using mobile app or browser within a 24 hour period it is
        # counted as a single session. Note: This field is only populated when the
        # seller is a B2B seller.
        attribute?(:sessions_b2b, String, from: "sessionsB2B")

        # @return [Float] The percentage conversion metric indicating how many units were purchased
        # relative to the number of people who viewed the products, calculated by
        # dividing unitsOrdered by sessions.
        attribute?(:unit_session_percentage, Float, from: "unitSessionPercentage")

        # @return [Float] The percentage conversion metric indicating how many units were purchased by
        # Amazon Business customers relative to the number of Amazon Business customers
        # who viewed the products, calculated by dividing unitsOrderedB2B by sessions.
        # Note: This field is only populated when the seller is a B2B seller.
        attribute?(:unit_session_percentage_b2b, Float, from: "unitSessionPercentageB2B")
      end
    end
  end
end

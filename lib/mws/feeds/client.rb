require 'mws/feeds/requests/feed_submission_list'
require 'mws/feeds/requests/feed_submission_count'
require 'mws/feeds/requests/feed_submission_result'
require 'peddler/client'

module MWS
  module Feeds
    class Client < ::Peddler::Client
      # Public: Get a list of feed submissions submitted during a specified time
      # frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Feeds API for available parameters.
      #
      # Examples
      #
      #   client.get_feed_submission_list(submitted_from_date: 1.week.ago)
      #
      # Returns an enumerable Feed Submission List.
      def_delegator :feed_submission_list, :get, :get_feed_submission_list

      # Public: List the next page of the list of feed submissions.
      #
      # Examples
      #
      #   client.get_feed_submission_list_by_next_token
      #
      # Returns an enumerable Feed Submission List.
      def_delegator :feed_submission_list, :get_by_next_token, :get_feed_submission_list_by_next_token

      # Public: Returns a count of the feeds submitted during a specified time
      # frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Feeds API for available parameters.
      #
      # Examples
      #
      #   client.get_feed_submission_count(submitted_from_date: 1.week.ago)
      #
      # Returns the Feed Submission Count.
      def_delegator :feed_submission_count, :get, :get_feed_submission_count

      # Public: Gets the feed processing report and the Content-MD5 header for
      # the returned HTTP body.
      #
      # feed_submission_id - The String Feed Submission Id.
      #
      # Examples
      #
      #   client.get_feed_submission_result('123456')
      #
      # Returns the Feed Submission Result.
      def_delegator :feed_submission_result, :get, :get_feed_submission_result

      private

      def feed_submission_count
        @feed_submission_count ||= Requests::FeedSubmissionCount.new(self)
      end

      def feed_submission_list
        @feed_submission_list ||= Requests::FeedSubmissionList.new(self)
      end

      def feed_submission_result
        @feed_submission_result ||= Requests::FeedSubmissionResult.new(self)
      end
    end
  end
end

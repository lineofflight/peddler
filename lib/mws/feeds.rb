require 'peddler/client'

module MWS
  # The MWS Feeds API lets you upload inventory and order data to Amazon. You
  # can also use this API to get information about the processing of feeds.
  class Feeds < ::Peddler::Client
    # Uploads a feed
    #
    # @note Feed size is limited to 2,147,483,647 bytes (2^31 -1) per feed
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_SubmitFeed.html
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
    # @param feed_content [String] an XML or flat file feed
    # @param feed_type [String] the feed type
    # @param opts [Hash]
    # @option opts [Array<String>, String] :marketplace_id_list
    # @option opts [Boolean] :purge_and_replace
    # @return [Peddler::Parser]
    def submit_feed(content, feed_type, opts = {})
      self.body = content
      operation('SubmitFeed')
        .add(opts.merge('FeedType' => feed_type))
        .structure!('MarketplaceId', 'Id')

      run
    end

    # List feed submissions
    #
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionList.html
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
    # @param opts [Hash]
    # @option opts [Array<String>, String] :feed_submission_id_list
    # @option opts [Integer] :max_count
    # @option opts [Array<String>, String] :feed_type_list
    # @option opts [Array<String>, String] :feed_processing_status_list
    # @option opts [String, #iso8601] :submitted_from_date
    # @option opts [String, #iso8601] :submitted_to_date
    # @return [Peddler::Parser]
    def get_feed_submission_list(opts = {})
      operation('GetFeedSubmissionList')
        .add(opts)
        .structure!('FeedSubmissionIdList', 'Id')
        .structure!('FeedTypeList', 'Type')
        .structure!('FeedProcessingStatusList', 'Status')

      run
    end

    # List the next page of feed submissions
    #
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionListByNextToken.html
    # @param next_token [String]
    # @return [Peddler::Parser]
    # @return false if there are no more pages
    def get_feed_submission_list_by_next_token(next_token)
      operation('GetFeedSubmissionListByNextToken')
        .add('NextToken' => next_token)

      run
    end

    # Counts submitted feeds
    #
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionCount.html
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
    # @param opts [Hash]
    # @option opts [Array<String>, String] :feed_type_list
    # @option opts [Array<String>, String] :feed_processing_status_list
    # @option opts [String, #iso8601] :submitted_from_date
    # @option opts [String, #iso8601] :submitted_to_date
    # @return [Peddler::Parser]
    def get_feed_submission_count(opts = {})
      operation('GetFeedSubmissionCount')
        .add(opts)
        .structure!('FeedTypeList', 'Type')
        .structure!('FeedProcessingStatusList', 'Status')

      run
    end

    # Cancel one or more feed submissions
    #
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_CancelFeedSubmissions.html
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
    # @param opts [Hash]
    # @option opts [Array<String>, String] :feed_submission_id_list
    # @option opts [Array<String>, String] :feed_type_list
    # @option opts [String, #iso8601] :submitted_from_date
    # @option opts [String, #iso8601] :submitted_to_date
    # @return [Peddler::Parser]
    def cancel_feed_submissions(opts = {})
      operation('CancelFeedSubmissions')
        .add(opts)

      run
    end

    # Gets the processing report for a feed and its Content-MD5 header
    #
    # @see http://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionResult.html
    # @param feed_submission_id [Integer, String]
    # @return Peddler::Parser
    def get_feed_submission_result(feed_submission_id)
      operation('GetFeedSubmissionResult')
        .add('FeedSubmissionId' => feed_submission_id)

      run
    end
  end
end

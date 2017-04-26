require 'delegate'
require 'csv'
require 'digest/md5'
require 'peddler/headers'

module Peddler
  # @api private
  class FlatFileParser < SimpleDelegator
    include Headers

    # http://stackoverflow.com/questions/8073920/importing-csv-quoting-error-is-driving-me-nuts
    OPTIONS = { col_sep: "\t", quote_char: "\x00", headers: true }.freeze

    attr_reader :content, :summary

    def initialize(res, encoding)
      super(res)
      scrub_body!(encoding)
      extract_content
    end

    def parse(&blk)
      CSV.parse(content, OPTIONS, &blk) if content
    end

    def records_count
      summarize if summary?
    end

    def valid?
      headers['Content-MD5'] == Digest::MD5.base64digest(body)
    end

    private

    def scrub_body!(encoding)
      body
        .force_encoding(encoding)
        .encode!('UTF-8', invalid: :replace, undef: :replace, replace: '?')
    end

    def extract_content
      if summary?
        @summary, @content = body.split("\n\n")
      else
        @content = body.dup
      end
    end

    def summary?
      body.include?("\n\n")
    end

    def summarize
      Hash[summary.split("\n\t")[1, 2].map { |line| line.split("\t\t") }]
    end
  end
end

require 'delegate'
require 'csv'
require 'digest/md5'

module Peddler
  # @api private
  class CSVParser < SimpleDelegator
    attr :content, :summary

    def initialize(res)
      super(res)
      split_body
    end

    def parse
      # http://stackoverflow.com/questions/8073920/importing-csv-quoting-error-is-driving-me-nuts
      CSV.parse(content, col_sep: "\t", quote_char: "\x00", headers: true) if content
    end

    def records_count
      Hash[summary.split("\n\t")[1, 2].map { |line| line.split("\t\t") }]
    end

    def valid?
      headers['Content-MD5'] == Digest::MD5.base64digest(body)
    end

    private

    def split_body
      @summary, @content = body.split("\n\n")
    end

    def scrub_content
      content.force_encoding(encoding).encode('UTF-8')
    end

    def encoding
      'ISO-8859-1'
    end
  end
end

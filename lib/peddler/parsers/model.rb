require 'cgi'
require 'time'
require 'money'
require 'structure'

require 'peddler/parsers/xml'

module Peddler
  module Parsers
    class Model < XML
      include Structure

      def boolean_at_xpath(path)
        !!text_at_xpath(path).match(/true|yes/i)
      end

      def float_at_xpath(path)
        str = text_at_xpath(path)
        str.to_f if str
      end

      def integer_at_xpath(path)
        str = text_at_xpath(path)
        str.to_i if str
      end

      def money_at_xpath(path)
        return unless amount = float_at_xpath("#{path}/Amount")

        currency_code = text_at_xpath("#{path}/CurrencyCode")
        amount = amount * 100 unless currency_code == 'JPY'

        Money.new(amount, currency_code)
      end

      def time_at_xpath(path)
        str = text_at_xpath(path)
        Time.parse(CGI.unescape(str)) if str
      end
    end
  end
end

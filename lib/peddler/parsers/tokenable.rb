module Peddler
  module Parsers
    module Tokenable
      def next_token
        text_at_xpath('NextToken')
      end

      def has_next_token?
        !!next_token
      end
    end
  end
end

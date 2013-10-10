require 'peddler/parsers/model'

module Peddler
  module Parsers
    class Counter < Model
      value :count do
        integer_at_xpath('Count')
      end

      alias :to_i :count
    end
  end
end

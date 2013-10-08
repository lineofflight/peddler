require 'csv'

module Peddler
  module Parsers
    class CSV
      include Enumerable

      attr :content, :encoding

      def initialize(content, encoding)
        @content = content
        @encoding = encoding
      end

      def each
        ::CSV.parse(scrub_content, col_sep: "\t", headers: true).to_enum
      end

      private

      def scrub_content
        content
          .force_encoding(encoding)
          .encode('UTF-8')
          .tr(%q("), %q('))
      end
    end
  end
end

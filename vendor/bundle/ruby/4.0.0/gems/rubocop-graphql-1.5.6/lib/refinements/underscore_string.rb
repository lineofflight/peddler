# frozen_string_literal: true

module UnderscoreString
  refine String do
    # This method was extracted from activesupport in Rails:
    # https://github.com/rails/rails/blob/8dab534ca81dd32c6a83ac03596a1feb7ddaaca7/activesupport/lib/active_support/inflector/methods.rb#L96

    def underscore
      camel_cased_word = self
      regex = /(?:(?<=([A-Za-z\d]))|\b)((?=a)b)(?=\b|[^a-z])/
      return camel_cased_word.to_s unless /[A-Z-]|::/.match?(camel_cased_word)

      word = camel_cased_word.to_s.gsub("::", "/")
      word.gsub!(regex) { "#{Regexp.last_match(1) && '_'}#{Regexp.last_match(2).downcase}" }
      word.gsub!(/([A-Z\d]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
        (Regexp.last_match(1) || Regexp.last_match(2)) << "_"
      end
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end

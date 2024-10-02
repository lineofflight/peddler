# frozen_string_literal: true

require "generator/config"

module Generator
  module Utils
    def snakecase(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .gsub(/(\d{4})(\d{2})(\d{2})/, '_\1_\2_\3') # Format date-like sequences
        .tr("-", "_")
        .downcase
    end

    def pascalcase(string, acronyms: ["FBA"])
      s = string.split(/[_\s-]/).map(&:capitalize).join
      acronyms.each { |a| s.gsub!(/#{a.capitalize}/, a.upcase) }
      s
    end

    def format_text(text, base_indent, wrap_indent = 2)
      text = convert_doc_links_to_full_url(text)

      max_width = Config::MAX_LINE_LENGTH - base_indent
      words = text.split
      lines = []
      current_line = []
      is_tag_line = false

      words.each do |word|
        if word.start_with?("@")
          # Start a new line for tags
          lines << "# " + current_line.join(" ") unless current_line.empty?
          current_line = [word]
          is_tag_line = true
        elsif (current_line + [word]).join(" ").length <= (max_width - 2) # -2 for "# "
          current_line << word
        else
          lines << "# " + current_line.join(" ")
          current_line = is_tag_line ? [" " * wrap_indent + word] : [word]
        end
      end

      lines << "# " + current_line.join(" ") unless current_line.empty?
      lines.join("\n")
    end

    def convert_doc_links_to_full_url(text)
      text.gsub(/\[([^\]]+)\]\(doc:([^\)]+)\)/) do
        link_text = Regexp.last_match(1)
        path = Regexp.last_match(2)

        "[#{link_text}](https://developer-docs.amazon.com/sp-api/docs/#{path})"
      end
    end

    def convert_links_to_markdown(text)
      text.gsub(%r{<a href=['"]([^'"]+)['"]>([^<]+)</a>}) do
        url = Regexp.last_match(1)
        link_text = Regexp.last_match(2)

        "[#{link_text}](#{url})"
      end
    end
  end
end

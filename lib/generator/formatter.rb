# frozen_string_literal: true

module Generator
  module Formatter
    MAX_LINE_LENGTH = 120

    def split_long_comment_line(line, base_indent, wrap_indent = 0)
      max_width = MAX_LINE_LENGTH - base_indent - 2 # Account for the space and `#`

      current_line = []
      lines = []
      line.sub(/^\s*#\s*/, "").split.each do |word|
        if lines.empty? && (current_line + [word]).join(" ").size <= max_width
          current_line << word
        elsif !lines.empty? && (current_line + [word]).join(" ").size <= max_width - wrap_indent
          current_line << word
        else
          lines << " " * base_indent + "# " + " " * (lines.empty? ? 0 : wrap_indent) + current_line.join(" ")
          current_line = [word]
        end
      end
      unless current_line.empty?
        lines << " " * base_indent + "# " + " " * (lines.empty? ? 0 : wrap_indent) + current_line.join(" ")
      end

      lines.empty? ? " " * base_indent + "#\n" : lines.join("\n")
    end

    def build_method_definition(method_name, params, base_indent)
      max_width = MAX_LINE_LENGTH - base_indent

      current_line = ["def #{method_name}("]
      lines = []
      params.each do |param|
        if (current_line + ["#{param},"]).join.size <= max_width
          current_line << param + ", "
        else
          lines << " " * base_indent + current_line.join.strip
          current_line = ["  " + param + ", "]
        end
      end
      lines << " " * base_indent + current_line.join[..-3] + ")"

      lines.join("\n")
    end

    def convert_doc_links_to_full_url(text)
      text.gsub(/\[([^\]]+)\]\(doc:([^\)]+)\)/) do
        link_text = Regexp.last_match(1)
        path = Regexp.last_match(2)
        url = "https://developer-docs.amazon.com/sp-api/docs/#{path}"

        "{#{link_text} #{url}}"
      end
    end

    def convert_html_links_to_yard(text)
      text.gsub(%r{<a href=['"]([^'"]+)['"]>([^<]+)</a>}) do
        url = Regexp.last_match(1)
        link_text = Regexp.last_match(2)

        "{#{link_text} #{url}}"
      end
    end
  end
end

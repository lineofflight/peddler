# frozen_string_literal: true

module Generator
  module Formatter
    MAX_LINE_LENGTH = 120

    def split_long_comment_line(line, base_indent: 0, wrap_indent: 0, max_line_length: MAX_LINE_LENGTH)
      max_width = max_line_length - base_indent - 2 # Account for the space and `#`

      # Handle multi-line input by processing each line separately
      input_lines = line.split("\n")
      all_lines = []

      input_lines.each do |input_line|
        # Preserve blank lines
        if input_line.strip.empty?
          all_lines << " " * base_indent + "#"
          next
        end

        current_line = []
        lines = []
        first_line = true
        input_line.sub(/^\s*#\s*/, "").split.each do |word|
          if first_line && (current_line + [word]).join(" ").size <= max_width
            current_line << word
          elsif !first_line && (current_line + [word]).join(" ").size <= max_width - wrap_indent
            current_line << word
          else
            lines << " " * base_indent + "# " + " " * (first_line ? 0 : wrap_indent) + current_line.join(" ")
            first_line = false
            current_line = [word]
          end
        end
        unless current_line.empty?
          lines << " " * base_indent + "# " + " " * (first_line ? 0 : wrap_indent) + current_line.join(" ")
        end

        all_lines.concat(lines)
      end

      all_lines.empty? ? " " * base_indent + "#" : all_lines.join("\n")
    end

    def format_method_definition(method_name, params, base_indent: 0, max_line_length: MAX_LINE_LENGTH)
      max_width = max_line_length - base_indent

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
      joined = current_line.join
      lines << " " * base_indent + (joined[..-3] || "") + ")"

      lines.join("\n")
    end

    def convert_doc_links_to_full_url(text)
      text.gsub(/\[([^\]]+)\]\(doc:([^\)]+)\)/) do
        link_text = Regexp.last_match(1)
        path = Regexp.last_match(2)
        url = "https://developer-docs.amazon.com/sp-api/docs/#{path}"

        "{#{url} #{link_text}}"
      end
    end

    def convert_html_links_to_yard(text)
      # Handle quoted href attributes: <a href="url"> or <a href='url'>
      text = text.gsub(%r{<a href=['"]([^'"]+)['"]>([^<]+)</a>}) do
        url = Regexp.last_match(1)
        link_text = Regexp.last_match(2)

        "{#{url} #{link_text}}"
      end

      # Handle unquoted href attributes: <a href=url>
      text = text.gsub(%r{<a href=([^\s>]+)>([^<]+)</a>}) do
        url = Regexp.last_match(1)
        link_text = Regexp.last_match(2)

        "{#{url} #{link_text}}"
      end

      # Normalize markdown bold: convert __text__ to **text** for consistency
      text.gsub(/__(.*?)__/, '**\1**')
    end
  end
end

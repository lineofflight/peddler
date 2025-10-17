# frozen_string_literal: true

module Generator
  module Formatter
    MAX_LINE_LENGTH = 120

    def split_long_comment_line(line, base_indent: 0, wrap_indent: 0, max_line_length: MAX_LINE_LENGTH)
      max_width = max_line_length - base_indent - 2 # Account for the space and `#`

      # Split into lines and process them intelligently:
      # - Preserve blank lines (paragraph breaks)
      # - Join lines that are mid-sentence continuations
      # - Keep lines that end complete sentences separate
      # - Add blank lines before special sections (**Note:**, etc.)
      input_lines = line.split("\n")
      paragraphs = []
      current_paragraph = []

      input_lines.each do |input_line|
        stripped = input_line.strip

        # Empty line = paragraph break
        if stripped.empty?
          if current_paragraph.any?
            paragraphs << current_paragraph.join(" ")
            current_paragraph = []
          end
          paragraphs << "" # blank line
          next
        end

        # Check if this starts a special section
        if stripped.match?(/^\*\*(?:Note|Warning|Important|Example|Examples|Usage)/)
          # Finish current paragraph
          if current_paragraph.any?
            paragraphs << current_paragraph.join(" ")
            current_paragraph = []
          end
          # Add blank line before special section (unless we just had one)
          paragraphs << "" if paragraphs.any? && paragraphs.last != ""
          # Start new paragraph with this line
          current_paragraph = [stripped]
        else
          # Add to current paragraph
          current_paragraph << stripped

          # If ends with sentence punctuation, finish paragraph
          if stripped.match?(/[.!?:]$/)
            paragraphs << current_paragraph.join(" ")
            current_paragraph = []
          end
        end
      end

      # Finish last paragraph
      if current_paragraph.any?
        paragraphs << current_paragraph.join(" ")
      end

      # Now wrap each paragraph
      all_lines = []
      paragraphs.each do |paragraph|
        if paragraph.empty?
          all_lines << " " * base_indent + "#"
          next
        end

        # Remove any remaining comment markers
        paragraph = paragraph.sub(/^\s*#\s*/, "")

        # Word wrap this paragraph
        current_line = []
        lines = []
        first_line = true
        paragraph.split.each do |word|
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

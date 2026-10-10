# frozen_string_literal: true

require "helper"
require "rdoc"
require "rdoc/generator/markup"
require_relative "../../tools/rdoc_rbs"

# What the site shows of HTML in a comment, held against a later RDoc. Most comments are Amazon's text.
class RDocRBSTest < Minitest::Test
  PARAGRAPHS = [
    "A sentence.",
    "<script>window.live = 1</script>",
    '<div onclick="alert(1)">a div</div>',
    "Map<String, List<Integer>> and a < b > c",
  ].freeze

  # RDoc writes a paragraph that starts with a tag to the page as it is. With tools/rdoc_rbs.rb loaded the page shows
  # it as text, and loses nothing that stands between a `<` and a `>`.
  def test_html_in_a_comment_is_text_on_the_page_and_whole
    page = description(PARAGRAPHS.join("\n\n"))
    shown = page.scan(%r{<p>(.*?)</p>}m).flatten.map { |text| CGI.unescapeHTML(text) }

    assert_equal(["</p>", "<p>"], page.scan(/<[^>]*>/).uniq.sort)
    assert_includes(shown, PARAGRAPHS.last)
    assert_equal(PARAGRAPHS, shown)
  end

  private

  # The comment of a class as the docs task formats it: read as Markdown, written by the formatter of a page
  def description(text)
    file = RDoc::Store.new(RDoc::Options.new).add_file("odd.rb")
    comment = RDoc::Comment.new(text, file)
    comment.format = "markdown"
    file.add_class(RDoc::NormalClass, "Odd").tap { |odd| odd.add_comment(comment, file) }.description
  end
end

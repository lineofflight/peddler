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

  MODEL = <<~RUBY
    module Peddler
      module APIs
        module Odd
          # A model.
          Model = Structure.new do
            # A kind. Known values: `A`, `B`.
            attribute(:kind, String, null: false)

            # <script>window.live = 1</script>
            attribute?(:shady, String, from: "shadyName")

            attribute?(:other, "Other")
          end
        end
      end
    end
  RUBY

  def test_a_typed_model_is_a_class_with_its_description
    model = parse(MODEL).find_class_named("Peddler::APIs::Odd::Model")

    assert_equal("Data", model.superclass)
    assert_equal("A model.", model.comment.text)
  end

  def test_the_class_of_a_typed_model_has_an_attribute_for_each_of_its_own
    model = parse(MODEL).find_class_named("Peddler::APIs::Odd::Model")

    assert_equal(["kind", "other", "shady"], model.attributes.map(&:name).sort)
    assert_equal("<p>A kind. Known values: <code>A</code>, <code>B</code>.</p>", attribute(model, "kind").description.strip)
  end

  def test_the_namespace_keeps_a_typed_model_as_a_constant_with_its_description
    constant = parse(MODEL).find_module_named("Peddler::APIs::Odd").find_constant_named("Model")

    assert_equal("A model.", constant.comment.text)
  end

  def test_html_in_the_description_of_an_attribute_is_text_on_the_page
    shady = attribute(parse(MODEL).find_class_named("Peddler::APIs::Odd::Model"), "shady")

    assert_equal("<p>&lt;script&gt;window.live = 1&lt;/script&gt;</p>", shady.description.strip)
  end

  private

  # A file of Ruby as the docs task reads it
  def parse(source)
    options = RDoc::Options.new
    options.markup = "markdown"
    store = RDoc::Store.new(options)
    file = store.add_file("odd.rb")
    RDoc::Parser::Ruby.new(file, source, options, RDoc::Stats.new(store, 1, 0)).scan
    store
  end

  def attribute(model, name)
    model.attributes.find { |attribute| attribute.name == name }
  end

  # The comment of a class as the docs task formats it: read as Markdown, written by the formatter of a page
  def description(text)
    file = RDoc::Store.new(RDoc::Options.new).add_file("odd.rb")
    comment = RDoc::Comment.new(text, file)
    comment.format = "markdown"
    file.add_class(RDoc::NormalClass, "Odd").tap { |odd| odd.add_comment(comment, file) }.description
  end
end

# frozen_string_literal: true

require "helper"
require "generator/feed"

module Generator
  class FeedTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/feeds")
      @listings_feed_spec = File.join(@spec_path, "listings-feed-schema-v2.json")
      @listings_message_spec = File.join(@spec_path, "listings-feed-message-schema-v2.json")

      @listings_feed = Generator::Feed.new(@listings_feed_spec)
      @listings_message = Generator::Feed.new(@listings_message_spec)
    end

    def test_root_properties_returns_hash
      properties = @listings_feed.root_properties

      assert_instance_of(Hash, properties)
      assert_predicate(properties.size, :positive?)
    end

    def test_root_required_properties_returns_array
      required = @listings_feed.root_required_properties

      assert_instance_of(Array, required)
    end

    def test_raw_description_returns_nil_for_generic_placeholder
      schema_with_placeholder = {
        "title" => "An explanation about the purpose of this instance.",
      }

      temp_file = Tempfile.new(["test-feed-schema", ".json"])
      temp_file.write(schema_with_placeholder.to_json)
      temp_file.rewind

      feed = Generator::Feed.new(temp_file.path)

      assert_nil(feed.raw_description)

      temp_file.close
      temp_file.unlink
    end

    def test_raw_description_prefers_title_over_description
      schema_with_both = {
        "title" => "Listings Feed Schema",
        "description" => "Detailed description here",
      }

      temp_file = Tempfile.new(["test-feed-title", ".json"])
      temp_file.write(schema_with_both.to_json)
      temp_file.rewind

      feed = Generator::Feed.new(temp_file.path)

      assert_equal("Listings Feed Schema", feed.raw_description)

      temp_file.close
      temp_file.unlink
    end

    def test_nested_type_files_returns_array
      files = @listings_feed.nested_type_files

      assert_instance_of(Array, files)
      assert(files.all?(String))
    end

    def test_feed_type_definition_structure
      type_def = @listings_feed.send(:feed_type_definition)

      assert_equal("object", type_def["type"])
      assert_kind_of(Hash, type_def["properties"])
      assert_kind_of(Array, type_def["required"])
    end

    def test_feed_type_definition_has_description
      type_def = @listings_feed.send(:feed_type_definition)

      assert(type_def["description"])
    end
  end
end

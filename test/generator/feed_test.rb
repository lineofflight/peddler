# frozen_string_literal: true

require "helper"
require "generator/feed"

module Generator
  class FeedTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/feeds")
      @listings_feed_spec = File.join(@spec_path, "listings-feed-schema-v2.json")
      @listings_message_spec = File.join(@spec_path, "listings-feed-message-schema-v2.json")

      skip("Feed specs not found") unless File.exist?(@listings_feed_spec)

      @listings_feed = Generator::Feed.new(@listings_feed_spec)
      @listings_message = Generator::Feed.new(@listings_message_spec) if File.exist?(@listings_message_spec)
    end

    def test_feed_name_extraction_from_filename
      # listings-feed-schema-v2.json => ListingsFeedSchema
      assert_equal("ListingsFeedSchema", @listings_feed.feed_name)
    end

    def test_feed_name_removes_version_suffix
      # The -v2 suffix should be removed
      refute_includes(@listings_feed.feed_name, "v2")
      refute_includes(@listings_feed.feed_name, "V2")
    end

    def test_feed_name_handles_multiple_word_names
      skip unless @listings_message

      # listings-feed-message-schema-v2.json => ListingsFeedMessageSchema
      assert_equal("ListingsFeedMessageSchema", @listings_message.feed_name)
    end

    def test_class_name_matches_feed_name
      # For feeds, class_name should match feed_name after camelization
      assert_equal("ListingsFeedSchema", @listings_feed.class_name)
    end

    def test_root_properties_returns_hash
      properties = @listings_feed.root_properties

      assert_instance_of(Hash, properties)
      assert_predicate(properties.size, :positive?)
    end

    def test_root_properties_are_sorted
      properties = @listings_feed.root_properties

      keys = properties.keys

      assert_equal(keys, keys.sort)
    end

    def test_root_required_properties_returns_array
      required = @listings_feed.root_required_properties

      assert_instance_of(Array, required)
    end

    def test_raw_description_returns_nil_for_generic_placeholder
      # Create a mock feed with generic placeholder
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
      # All items should be strings (underscored type names)
      assert(files.all?(String))
    end

    def test_api_name_for_type_resolver
      # Private method but important for SchemaHelpers integration
      api_name = @listings_feed.send(:api_name_for_type_resolver)

      assert_equal("feeds/listings_feed_schema", api_name)
    end

    def test_output_file_path
      file_path = @listings_feed.send(:output_file_path)

      assert_includes(file_path, "lib/peddler/feeds/listings_feed_schema.rb")
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

    def test_class_name_is_consistent
      # Call multiple times to ensure consistency
      name1 = @listings_feed.class_name
      name2 = @listings_feed.class_name

      assert_equal(name1, name2)
    end
  end
end

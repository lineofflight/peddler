# frozen_string_literal: true

require "helper"
require "erb"
require "tempfile"
require "tmpdir"
require "generator/data_kiosk"
require "generator/feed"
require "generator/notification"
require "generator/report"

module Generator
  # The file that names a feed, a notification or a report opens with the schema's title and description. A schema
  # is data: neither ends the comment, and neither writes what RDoc reads as a directive.
  class MainTemplateTest < Minitest::Test
    HOSTILE = { "title" => ":include: /etc/passwd\nexit 1", "description" => ":stopdoc:\nexit 2" }.freeze

    [Feed, Notification, Report].each do |generator|
      define_method("test_the_comment_of_a_#{generator.name.split("::").last.downcase}_is_all_comment_and_no_directive") do
        comment = comment_of(generator)

        assert_equal(
          ["# \\:include: /etc/passwd exit 1", "#", "# \\:stopdoc:", "# exit 2"],
          comment,
        )
      end
    end

    # The module that file opens is named after the schema's file, and so are the modules of its types. The name
    # of a file is data as the schema is: one that would be anything but a constant is refused, and nothing is
    # written. This one would open `module X;exit 1;y`.
    { DataKiosk => ".graphql", Feed => ".json", Notification => ".json", Report => ".json" }.each do |generator, extension|
      define_method("test_a_#{generator.name.split("::").last.downcase}_named_after_a_hostile_file_is_refused") do
        Dir.mktmpdir do |dir|
          path = File.join(dir, "x;exit 1;y#{extension}")
          File.write(path, extension == ".json" ? "{}" : "type Query { a: String }")
          instance = generator.new(path)
          instance.define_singleton_method(:write_file) { |*| raise "a file was written" }

          assert_raises(ArgumentError) { instance.class_name }
          assert_raises(ArgumentError) { instance.generate_main_file! }
        end
      end
    end

    private

    # The lines between the namespace and the module the template opens
    def comment_of(generator)
      Tempfile.create(["hostile", ".json"]) do |file|
        file.write(HOSTILE.to_json)
        file.flush
        # A template calls `schema`, so the generator takes another name here.
        instance = generator.new(file.path)
        source = ERB.new(instance.send(:main_template), trim_mode: "-").result(instance.instance_eval { binding })
        lines = source.lines.map(&:strip)
        namespace = lines.index { |line| line.match?(/\Amodule (Feeds|Notifications|Reports)\z/) }

        lines.drop(namespace + 1).take_while { |line| !line.start_with?("module ") }
      end
    end
  end
end

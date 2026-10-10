# frozen_string_literal: true

require "helper"
require "erb"
require "tempfile"
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

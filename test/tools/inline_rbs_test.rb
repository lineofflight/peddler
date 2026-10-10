# frozen_string_literal: true

require "helper"
require_relative "../../tools/inline_rbs"

# What `rake rbs:export` writes for each construct it handles, and what it refuses to write. Each case is the body
# of a class.
class InlineRBSTest < Minitest::Test
  HANDLED = {
    "a method by its annotation" => [<<~RUBY, <<~RBS],
      #: () -> Integer
      def one = 1
    RUBY
      def one: () -> Integer
    RBS
    "a method of the class" => [<<~RUBY, <<~RBS],
      #: () -> Integer
      def self.one = 1
    RUBY
      def self.one: () -> Integer
    RBS
    "a method without an annotation" => [<<~RUBY, <<~RBS],
      def bare(text) = text
    RUBY
      def bare: (?) -> untyped
    RBS
    "what a method's annotations say of its arguments" => [<<~RUBY, <<~RBS],
      # Counts the letters
      #
      # @rbs name: String -- what it is called,
      #   which may run on
      # @rbs strict: bool
      # @rbs return: Integer -- how many
      def count(name, strict: false) = name.size
    RUBY
      # Counts the letters
      #
      # - name: what it is called, which may run on
      # - return: how many
      def count: (String name, ?strict: bool) -> Integer
    RBS
    "nothing for a method that is skipped" => [<<~RUBY, ""],
      # @rbs skip
      def skipped = 1
    RUBY
    "attributes" => [<<~RUBY, <<~RBS],
      attr_reader :name #: String
      attr_writer :size #: Integer
      attr_accessor :kind, :sort #: Symbol
    RUBY
      attr_reader name: String

      attr_writer size: Integer

      attr_accessor kind: Symbol

      attr_accessor sort: Symbol
    RBS
    "mixins" => [<<~RUBY, <<~RBS],
      include Comparable
      extend Enumerable #[String]
      prepend Kernel
    RUBY
      include Comparable

      extend Enumerable[String]

      prepend Kernel
    RBS
    "an instance variable" => [<<~RUBY, <<~RBS],
      # @rbs @name: String

      #: () -> String
      def name = @name
    RUBY
      @name: String

      def name: () -> String
    RBS
    "constants" => [<<~RUBY, <<~RBS],
      LIMIT = 3
      # The names
      NAMES = ["a"].freeze #: Array[String]
    RUBY
      LIMIT: ::Integer

      # The names
      NAMES: Array[String]
    RBS
    "classes, modules and aliases inside" => [<<~RUBY, <<~RBS],
      class Inner < Base
      end

      module Mixin
      end

      Other = Inner #: class-alias
    RUBY
      class Inner < Base
      end

      module Mixin
      end

      class Other = Inner
    RBS
    "a bare private and a bare public" => [<<~RUBY, <<~RBS],
      private

      #: () -> Integer
      def hidden = 1

      #: () -> Integer
      def self.open = 2

      public

      #: () -> Integer
      def shown = 3
    RUBY
      private

      def hidden: () -> Integer

      def self.open: () -> Integer

      public

      def shown: () -> Integer
    RBS
    "private_class_method with names" => [<<~RUBY, <<~RBS],
      #: () -> Integer
      def self.hidden = 1

      #: () -> Integer
      def self.open = 2
      private_class_method :hidden
    RUBY
      private def self.hidden: () -> Integer

      def self.open: () -> Integer
    RBS
  }.freeze

  REFUSED = {
    "private with a def" => ["private def secret = 1", "odd.rb:2: `private` with arguments: put the method under a bare `private`"],
    "private with a name" => ["def secret = 1\nprivate :secret", "odd.rb:3: `private` with arguments: put the method under a bare `private`"],
    "public with a name" => ["def shown = 1\npublic :shown", "odd.rb:3: `public` with arguments: put the method under a bare `public`"],
    "protected" => ["protected\n\ndef guarded = 1", "odd.rb:2: `protected`: RBS has no such visibility"],
    "protected with a name" => ["def guarded = 1\nprotected :guarded", "odd.rb:3: `protected`: RBS has no such visibility"],
    "alias" => ["def one = 1\nalias uno one", "odd.rb:3: `alias`: write a def with its own annotation"],
    "alias_method" => ["def one = 1\nalias_method :uno, :one", "odd.rb:3: `alias_method`: write a def with its own annotation"],
    "module_function" => ["module_function\n\ndef helper = 1", "odd.rb:2: `module_function`: write `def self.`"],
    "class << self" => ["class << self\n  def build = 1\nend", "odd.rb:2: `class << self`: write `def self.`"],
    "a method defined twice" => ["def twice = 1\n\ndef twice = 2", "odd.rb:4: twice is defined twice"],
    "a method defined on both sides of a condition" => [
      "if RUBY_VERSION >= \"4\"\n  def modern = 1\nelse\n  def modern = 2\nend", "odd.rb:5: modern is defined twice",
    ],
    "private_class_method with a def" => [
      "private_class_method def self.hidden = 1", "odd.rb:2: `private_class_method` takes the names of methods",
    ],
    "private_class_method with the name of no method" => [
      "def gone = 1\nprivate_class_method :gone", "odd.rb:3: `private_class_method` names gone, which is not defined here",
    ],
    "an annotation above nothing" => ["#: () -> Integer\n\ndef one = 1", "odd.rb:2: Unused inline rbs annotation"],
  }.freeze

  HANDLED.each do |name, (ruby, rbs)|
    define_method("test_writes_#{name.tr(" ", "_")}") do
      assert_equal("class Odd\n#{indent(rbs)}end\n", export(ruby))
    end
  end

  REFUSED.each do |name, (ruby, message)|
    define_method("test_refuses_#{name.tr(" ", "_")}") do
      _, printed = capture_io { assert_raises(SystemExit) { export(ruby) } }

      assert_equal(message, printed.lines.first.chomp)
    end
  end

  # The words are Prism's.
  def test_refuses_ruby_that_does_not_parse
    _, printed = capture_io { assert_raises(SystemExit) { export("def keyword(end: nil) = { end: end }") } }

    assert_match(/\Aodd\.rb:2: \S/, printed)
  end

  # The same holds for the body of a module.
  def test_reads_the_body_of_a_module_as_it_reads_a_class
    signatures = InlineRBS.rbs("odd.rb", "module Odd\n  #: () -> Integer\n  def self.one = 1\n  private_class_method :one\nend\n")

    assert_equal("module Odd\n  private def self.one: () -> Integer\nend\n", signatures.lines.drop(2).join)
    _, printed = capture_io { assert_raises(SystemExit) { InlineRBS.rbs("odd.rb", "module Odd\n  module_function\nend\n") } }

    assert_equal("odd.rb:2: `module_function`: write `def self.`\n", printed)
  end

  def test_names_the_file_it_was_written_from
    assert_equal("# Generated from odd.rb by rake rbs:export. Do not edit.\n", InlineRBS.rbs("odd.rb", "class Odd\nend\n").lines.first)
  end

  private

  # The signatures of a class with this body, without the notice above them
  def export(body)
    InlineRBS.rbs("odd.rb", "class Odd\n#{indent("#{body.chomp}\n")}end\n").lines.drop(2).join
  end

  def indent(text)
    text.gsub(/^(?=.)/, "  ")
  end
end

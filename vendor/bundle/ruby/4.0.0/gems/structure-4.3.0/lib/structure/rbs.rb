# frozen_string_literal: true

require "fileutils"
require "pathname"

module Structure
  # Generates RBS type signatures for Structure classes
  module RBS
    # @type const EMPTY_CUSTOM_METHODS: { instance: Array[untyped], singleton: Array[untyped] }
    empty_instance = _ = [] #: Array[untyped]
    empty_singleton = _ = [] #: Array[untyped]
    EMPTY_CUSTOM_METHODS = { instance: empty_instance, singleton: empty_singleton }.freeze
    private_constant :EMPTY_CUSTOM_METHODS

    class << self
      def emit(klass)
        return unless klass < Data

        class_name = klass.name
        return unless class_name

        # @type var meta: Hash[Symbol, untyped]
        meta = klass.respond_to?(:__structure_meta__) ? klass.__structure_meta__ : {}

        attributes = meta[:mappings] ? meta[:mappings].keys : klass.members
        # @type var types: Hash[Symbol, untyped]
        default_types = _ = {} #: Hash[Symbol, untyped]
        types = meta.fetch(:types, default_types)
        # @type var required: Array[Symbol]
        required = meta.fetch(:required, attributes)
        custom_methods = meta.fetch(:custom_methods, EMPTY_CUSTOM_METHODS)

        emit_rbs_content(
          class_name:,
          attributes:,
          types:,
          required:,
          has_structure_modules: meta.any?,
          custom_methods:,
        )
      end

      def write(klass, dir: "sig")
        rbs_content = emit(klass)
        return unless rbs_content

        # User::Address -> user/address.rbs
        path_segments = klass.name.split("::").map(&:downcase)
        filename = "#{path_segments.pop}.rbs"

        # full path
        dir_path = Pathname.new(dir)
        dir_path = dir_path.join(*path_segments) unless path_segments.empty?
        FileUtils.mkdir_p(dir_path)

        file_path = dir_path.join(filename).to_s
        File.write(file_path, rbs_content)

        file_path
      end

      private

      def emit_rbs_content(class_name:, attributes:, types:, required:, has_structure_modules:, custom_methods:)
        # @type var lines: Array[String]
        lines = []
        lines << "class #{class_name} < Data"

        unless attributes.empty?
          # map types to rbs
          rbs_types = attributes.map do |attr|
            type = types.fetch(attr, nil)
            rbs_type = map_type_to_rbs(type, class_name)

            [attr, rbs_type != "untyped" ? "#{rbs_type}?" : rbs_type]
          end.to_h

          # Sort keyword params: required first, then optional (with ? prefix)
          # Within each group, maintain declaration order
          required_params = required.map { |attr| "#{attr}: #{rbs_types[attr]}" }
          optional_params = (attributes - required).map { |attr| "?#{attr}: #{rbs_types[attr]}" }
          keyword_params = (required_params + optional_params).join(", ")
          positional_params = attributes.map { |attr| rbs_types[attr] }.join(", ")

          needs_parse_data = types.any? do |_attr, type|
            type == :self || type == [:self]
          end

          # Generate type alias first if needed (RBS::Sorter puts types at top)
          if needs_parse_data
            lines << "  type parse_data = { " + attributes.map { |attr|
              type = types.fetch(attr, nil)
              parse_type = parse_data_type(type, class_name)
              "?#{attr}: #{parse_type}"
            }.join(", ") + " }"
          end

          # Build singleton methods list
          # Note: `new` and `[]` are kept at top (RBS::Sorter convention)
          special_singleton_methods = [
            {
              name: "new",
              lines: [
                "  def self.new: (#{keyword_params}) -> #{class_name}",
                "              | (#{positional_params}) -> #{class_name}",
              ],
            },
            {
              name: "[]",
              lines: [
                "  def self.[]: (#{keyword_params}) -> #{class_name}",
                "             | (#{positional_params}) -> #{class_name}",
              ],
            },
          ]

          # Regular singleton methods (to be sorted)
          # @type var singleton_methods_list: Array[{ name: String, lines: Array[String] }]
          singleton_methods_list = []

          # Add custom singleton methods
          # @type var custom_singleton: Array[untyped]
          default_singleton = _ = [] #: Array[untyped]
          custom_singleton = custom_methods.fetch(:singleton, default_singleton)
          custom_singleton.each do |method_meta|
            singleton_methods_list << {
              name: method_meta[:name].to_s,
              lines: [format_method_signature(method_meta, singleton: true)],
            }
          end

          # Add standard singleton methods
          members_tuple = attributes.map { |attr| ":#{attr}" }.join(", ")
          singleton_methods_list << {
            name: "members",
            lines: ["  def self.members: () -> [ #{members_tuple} ]"],
          }

          singleton_methods_list << if needs_parse_data
            {
              name: "parse",
              lines: [
                "  def self.parse: (?parse_data data) -> #{class_name}",
                "                | (?Hash[String, untyped] data) -> #{class_name}",
              ],
            }
          else
            {
              name: "parse",
              lines: ["  def self.parse: (?Hash[String | Symbol, untyped], **untyped) -> #{class_name}"],
            }
          end

          # Emit special singleton methods first (new, [])
          special_singleton_methods.each do |method|
            # @type var method_lines: Array[String]
            method_lines = method[:lines]
            method_lines.each { |line| lines << line }
          end

          # Sort and emit other singleton methods
          singleton_methods_list.sort_by { |m| m[:name] }.each do |method|
            lines << "" # Blank line before each method group
            # @type var method_lines: Array[String]
            method_lines = method[:lines]
            method_lines.each { |line| lines << line }
          end

          lines << ""

          # Sort attr_reader lines alphabetically (RBS::Sorter does this)
          attributes.sort.each do |attr|
            lines << "  attr_reader #{attr}: #{rbs_types[attr]}"
          end
          lines << ""

          # Build instance methods list (standard + custom), then sort
          # @type var instance_methods_list: Array[{ name: String, lines: Array[String] }]
          instance_methods_list = []

          # Add boolean predicates
          boolean_predicates = types.sort.select { |attr, type| type == :boolean && !attr.to_s.end_with?("?") }
          boolean_predicates.each do |attr, _type|
            instance_methods_list << {
              name: "#{attr}?",
              lines: ["  def #{attr}?: () -> bool"],
            }
          end

          # Add custom instance methods
          # @type var custom_instance: Array[untyped]
          default_instance = _ = [] #: Array[untyped]
          custom_instance = custom_methods.fetch(:instance, default_instance)
          custom_instance.each do |method_meta|
            instance_methods_list << {
              name: method_meta[:name].to_s,
              lines: [format_method_signature(method_meta, singleton: false)],
            }
          end

          # Add standard instance methods
          instance_methods_list << {
            name: "members",
            lines: ["  def members: () -> [ #{members_tuple} ]"],
          }

          hash_type = attributes.map { |attr| "#{attr}: #{rbs_types[attr]}" }.join(", ")
          instance_methods_list << {
            name: "to_h",
            lines: ["  def to_h: () -> { #{hash_type} }"],
          }

          # Sort and emit instance methods
          instance_methods_list.sort_by { |m| m[:name] }.each do |method|
            # @type var method_lines: Array[String]
            method_lines = method[:lines]
            method_lines.each { |line| lines << line }
          end
        end

        lines << "end"
        lines.join("\n")
      end

      def parse_data_type(type, class_name)
        case type
        when [:self]
          "Array[#{class_name} | parse_data]"
        when Array
          if type.size == 1 && type.first == :self
            "Array[#{class_name} | parse_data]"
          elsif type.size == 1
            # Regular array type like [String], [Integer], etc.
            # Use Array[untyped] since we coerce values
            "Array[untyped]"
          else
            "untyped"
          end
        when :self
          "#{class_name} | parse_data"
        else
          "untyped"
        end
      end

      def map_type_to_rbs(type, class_name)
        case type
        when Class
          if type == Array
            "Array[untyped]"
          elsif type == Hash
            "Hash[untyped, untyped]"
          else
            type.name || "untyped"
          end

        when :boolean
          "bool"
        when :self
          class_name || "untyped"
        when Array
          if type.size == 1
            # Single element array means array of that type
            element_type = map_type_to_rbs(type.first, class_name)
            "Array[#{element_type}]"
          else
            "untyped"
          end
        else
          "untyped"
        end
      end

      def format_method_signature(method_meta, singleton:)
        name = method_meta.fetch(:name)
        parameters = method_meta.fetch(:parameters, [])

        params_str, block_str = build_parameters_fragment(parameters)

        method_prefix = singleton ? "self." : ""
        signature = "  def #{method_prefix}#{name}: #{params_str}"
        signature += " #{block_str}" if block_str
        signature + " -> untyped"
      end

      def build_parameters_fragment(parameters)
        # @type var parts: Array[String]
        parts = []
        block_required = false

        parameters.each do |kind, param_name|
          case kind
          when :req
            parts << "untyped"
          when :opt
            parts << "?untyped"
          when :rest
            parts << "*untyped"
          when :keyreq
            key_name = param_name || :arg
            parts << "#{key_name}: untyped"
          when :key
            key_name = param_name || :arg
            parts << "?#{key_name}: untyped"
          when :keyrest
            parts << "**untyped"
          when :block
            block_required = true
          else
            parts << "untyped"
          end
        end

        params_str = "(#{parts.join(", ")})"
        params_str = "()" if parts.empty?

        block_str = block_required ? "?{ (*untyped, **untyped) -> untyped }" : nil

        [params_str, block_str]
      end
    end
  end
end

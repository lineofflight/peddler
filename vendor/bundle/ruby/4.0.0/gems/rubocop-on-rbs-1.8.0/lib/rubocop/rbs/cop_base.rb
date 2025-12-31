# frozen_string_literal: true

require 'zlib'

module RuboCop
  module RBS
    # Base class for cops that operate on RBS signatures.
    class CopBase < RuboCop::Cop::Base
      include RuboCop::Cop::RangeHelp
      include RuboCop::RBS::OnTypeHelper

      attr_reader :processed_rbs_source

      exclude_from_registry

      def self.documentation_url(_config = nil)
        base = "cops_#{department.to_s.downcase.tr('/', '_')}"
        fragment = cop_name.downcase.gsub(/[^a-z]/, '')
        "https://github.com/ksss/rubocop-on-rbs/blob/v#{VERSION}/docs/modules/ROOT/pages/#{base}.adoc##{fragment}"
      end

      def on_new_investigation
        # Called here when valid as Ruby
        investigation_rbs()
      end

      def on_other_file
        investigation_rbs()
      end

      @@cache = {}
      def parse_rbs
        buffer = rbs_buffer()
        @processed_rbs_source = RuboCop::RBS::ProcessedRBSSource.new(buffer)
      end

      def investigation_rbs
        return unless processed_source.buffer.name.then { |n| n.end_with?(".rbs") || n == "(string)" }

        if processed_source.buffer.name == "(string)"
          parse_rbs
        else
          crc32 = Zlib.crc32(processed_source.raw_source)
          hit_path = @@cache[processed_source.buffer.name]
          if hit_path
            if hit_crc32 = hit_path[crc32]
              @processed_rbs_source = hit_crc32
            else
              hit_path.clear # Other key expect clear by GC
              hit_path[crc32] = parse_rbs
            end
          else
            (@@cache[processed_source.buffer.name] ||= {})[crc32] = parse_rbs
          end
        end

        if processed_rbs_source.error
          on_rbs_parsing_error()
        else
          on_rbs_new_investigation()

          processed_rbs_source.decls.each do |decl|
            walk(decl)
          end
        end
      end

      def on_rbs_new_investigation; end
      def on_rbs_parsing_error; end

      # other on_* methods should sync with `#walk` method
      def on_rbs_class(member); end
      def on_rbs_module(member); end
      def on_rbs_interface(member); end
      def on_rbs_constant(const); end
      def on_rbs_global(global); end
      def on_rbs_type_alias(decl); end
      def on_rbs_def(member); end
      def on_rbs_attribute(member); end
      def on_rbs_public(member); end
      def on_rbs_private(member); end
      def on_rbs_var(member); end

      def walk(decl)
        case decl
        when ::RBS::AST::Declarations::Module
          on_rbs_module(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Class
          on_rbs_class(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Interface
          on_rbs_interface(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Constant
          on_rbs_constant(decl)
        when ::RBS::AST::Declarations::Global
          on_rbs_global(decl)
        when ::RBS::AST::Declarations::TypeAlias
          on_rbs_type_alias(decl)
        when ::RBS::AST::Members::MethodDefinition
          on_rbs_def(decl)
        when ::RBS::AST::Members::Attribute
          on_rbs_attribute(decl)
        when ::RBS::AST::Members::Public
          on_rbs_public(decl)
        when ::RBS::AST::Members::Private
          on_rbs_private(decl)
        when ::RBS::AST::Members::Var
          on_rbs_var(decl)
        end
      end

      def rbs_buffer
        ::RBS::Buffer.new(
          name: processed_source.buffer.name,
          content: processed_source.raw_source
        )
      end

      def location_to_range(location)
        range_between(location.start_pos, location.end_pos)
      end

      def tokenize(source)
        ::RBS::Parser.lex(source).value.reject { |t| t.type == :tTRIVIA }
      end

      private

      # HACK: Required to autocorrect
      def current_corrector
        @current_corrector ||= RuboCop::Cop::Corrector.new(@processed_source) if @processed_rbs_source.valid_syntax?
      end
    end
  end
end

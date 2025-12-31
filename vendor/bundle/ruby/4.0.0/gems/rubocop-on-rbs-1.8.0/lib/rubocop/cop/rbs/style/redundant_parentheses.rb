# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Check for redundant parentheses.
        #
        # @example
        #   # bad
        #   def foo: () -> (bool)
        #
        #   # bad
        #   def foo: (((true | false))) -> void
        #
        #   # good
        #   def foo: () -> bool
        #
        #   # good
        #   def foo: ((true | false)) -> bool
        #
        class RedundantParentheses < RuboCop::RBS::CopBase
          module BeforeTokenIfLparen
            def before_token_if_lparen(tokens, base, fun)
              first_param = fun.each_param.first
              return unless first_param

              b, _ = token_before_after(tokens, first_param.location.start_pos - base)
              return unless b&.type == :pLPAREN

              yield b
            end

            private

            def token_before_after(tokens, pos)
              token_index = tokens.bsearch_index do |t|
                t.location.start_pos >= pos
              end
              return unless token_index

              [
                tokens[token_index - 1],
                tokens[token_index + 1]
              ]
            end
          end

          class ParenChecker
            include BeforeTokenIfLparen
            include RangeHelp
            attr_reader :processed_source

            def initialize(processed_source:, base:, tokens:, type:, skip:, cop:)
              @processed_source = processed_source
              @base = base
              @tokens = tokens
              @type = type
              @skip = skip
              @cop = cop
            end

            def check
              @cop.on_type([::RBS::Types::Proc], @type) do |proc_type|
                before_token_if_lparen(@tokens, @base, proc_type.type) do |b|
                  @skip << (b.location.start_pos + @base)
                end
                if proc_type.block
                  before_token_if_lparen(@tokens, @base, proc_type.block.type) do |b|
                    @skip << (b.location.start_pos + @base)
                  end
                end
              end

              excludes = [
                ::RBS::Types::Union,
                ::RBS::Types::Intersection,
                ::RBS::Types::Proc,
              ]
              @cop.on_not_type(excludes, @type) do |type|
                case type
                when ::RBS::Types::Optional
                  case type.type
                  when ::RBS::Types::Literal
                    case type.type.literal
                    when Symbol
                      # Skip optional with symbol literal (e.g. `(:sym)?`)
                      @skip << type.location.start_pos
                    end
                  end
                end
                check_parentheses(type)
              end
            end

            def check_parentheses(type)
              type_token_start_index = @tokens.bsearch_index do |token|
                (token.location.start_pos + @base) >= type.location.start_pos
              end or raise
              before_token = @tokens[type_token_start_index - 1]
              return if @skip.include?(before_token.location.start_pos + @base)
              return if before_token&.type != :pLPAREN

              type_token_end_index = @tokens.bsearch_index do |token|
                (token.location.start_pos + @base) >= type.location.end_pos
              end or raise
              after_token = @tokens[type_token_end_index]
              return if after_token&.type != :pRPAREN

              range = range_between(before_token.location.start_pos + @base, after_token.location.end_pos + @base)
              @cop.add_offense(range, message: "Don't use parentheses around simple type.") do |corrector|
                corrector.remove(range_between(before_token.location.start_pos + @base,
                                               before_token.location.end_pos + @base))
                corrector.remove(range_between(after_token.location.start_pos + @base,
                                               after_token.location.end_pos + @base))
              end
            end
          end

          include BeforeTokenIfLparen
          extend AutoCorrector

          def on_rbs_def(decl)
            base = decl.location.start_pos
            tokens = tokenize(decl.location.source)
            skip = Set.new
            decl.overloads.each do |overload|
              before_token_if_lparen(tokens, base, overload.method_type.type) do |b|
                skip << (b.location.start_pos + base)
              end
              if overload.method_type.block
                before_token_if_lparen(tokens, base, overload.method_type.block.type) do |b|
                  skip << (b.location.start_pos + base)
                end
              end
              overload.method_type.each_type do |type|
                check_type(tokens:, type:, base:, skip:)
              end
            end
          end

          def check_type(tokens:, type:, base:, skip: Set.new)
            ParenChecker.new(
              processed_source:,
              base:,
              tokens:,
              type:,
              skip:,
              cop: self
            ).check
          end

          def on_rbs_constant(const)
            tokens = tokenize(const.location.source)
            type = const.type
            base = const.location.start_pos
            check_type(tokens:, type:, base:)
          end
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant
        end
      end
    end
  end
end

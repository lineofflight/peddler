# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks keyword argument keys that are not local variable names.
        #
        # @example default
        #   # bad
        #   def foo: (option?: bool, option!: bool, Option: bool) -> void
        #
        class AmbiguousKeywordArgumentKey < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @rbs decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              func = overload.method_type.type
              next unless func.kind_of?(::RBS::Types::Function)
              next unless !func.required_keywords.empty? || !func.optional_keywords.empty?

              base_pos = overload.method_type.location.start_pos
              lex_result = ::RBS::Parser.lex(overload.method_type.location.source)
              buf = []
              lex_result.value.each do |token|
                case token.type
                when :pLPAREN, :pRPAREN, :tTRIVIA
                  # skip
                when :pCOLON
                  next if buf.empty?

                  case buf.last.type
                  when :pQUESTION
                    buf.shift if buf.first.type == :pQUESTION
                    actual = buf.map { |t| t.location.source }.join
                    did_you_mean = buf.reject { |t| t.location.source == '?' }.map { |t| t.location.source }.join
                    message = +"`#{actual}` is not local variable name."
                    if did_you_mean.length > 0
                      message << " Did you mean `?#{did_you_mean}` for optional keyword argument?"
                    end
                    range = range_between(buf.first.location.start_pos + base_pos, buf.last.location.end_pos + base_pos)
                    add_offense(range, message: message)
                  when :tBANGIDENT, :tUIDENT
                    buf.shift if buf.first.type == :pQUESTION
                    actual = buf.map { |t| t.location.source }.join
                    range = range_between(buf.first.location.start_pos + base_pos, buf.last.location.end_pos + base_pos)
                    add_offense(range, message: "`#{actual}` is not local variable name.")
                  end
                when :pCOMMA
                  buf.clear
                else
                  buf << token
                end
              end
            end
          end
        end
      end
    end
  end
end

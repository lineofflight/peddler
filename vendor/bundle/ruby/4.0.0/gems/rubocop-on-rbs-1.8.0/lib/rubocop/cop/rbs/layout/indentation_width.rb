# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks if the indentation width.
        #
        # @example
        #   # bad
        #   class Foo
        #   def foo: () -> void
        #   end
        #
        #   # good
        #   class Foo
        #     def foo: () -> void
        #   end
        #
        class IndentationWidth < RuboCop::RBS::CopBase
          extend AutoCorrector

          def on_rbs_new_investigation
            @first_char_columns = processed_source.raw_source.each_line.map do |line|
              line.index(/[^[:space:]]/) || 0
            end
            processed_rbs_source.decls.each do |decl|
              check_indentation(decl, expect: 0)
            end
          end

          def check_indentation(decl, expect:)
            if decl.respond_to?(:members)
              check(decl, expect: expect)
              decl.members.each do |member|
                check_indentation(member, expect: expect + 2)
              end
            else
              check(decl, expect: expect)
            end
          end

          def check(decl, expect:)
            line_start_pos = line_start_pos(decl)
            actual = @first_char_columns[decl.location.start_line - 1]
            if actual != expect
              range = range_between(line_start_pos, line_start_pos + actual)
              message = "Use #{expect} (not #{actual}) spaces for indentation."
              add_offense(range, message: message) do |corrector|
                corrector.replace(range, ' ' * expect)
              end
            end
          end

          def line_start_pos(decl)
            rindex = processed_source.raw_source.rindex(/\R/, decl.location.start_pos)
            if rindex
              rindex + 1
            else
              0
            end
          end
        end
      end
    end
  end
end

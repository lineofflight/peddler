# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks if `end` is aligned with the start of the class, module or interface.
        #
        # @example
        #   # bad
        #   class Foo
        #     def foo: () -> void
        #     end
        #
        #   # good
        #   class Foo
        #     def foo: () -> void
        #   end
        #
        class EndAlignment < RuboCop::RBS::CopBase
          extend AutoCorrector

          def on_rbs_new_investigation
            processed_rbs_source.decls.each do |decl|
              check_indentation(decl, expect: 0)
            end
          end

          def check_indentation(decl, expect:)
            if decl.location.key?(:end)
              # module, class and interface
              check(decl, expect: expect)
              decl.members.each do |member|
                check_indentation(member, expect: expect + 2)
              end
            end
          end

          def check(decl, expect:)
            return if decl.location.start_line == decl.location.end_line

            end_loc = decl.location[:end]
            actual = end_loc.start_column
            if actual != expect
              line_start_pos = processed_source.raw_source.rindex(/\R/, end_loc.start_pos) + 1
              range = range_between(end_loc.start_pos, end_loc.end_pos)
              source = decl.location.source.each_line.first.strip
              message = "`end` at #{end_loc.start_line}, #{end_loc.start_column} is not aligned with " \
                        "`#{source}` at #{decl.location.start_line}, #{decl.location.start_column}."
              add_offense(range, message: message) do |corrector|
                whitespace = range_between(line_start_pos, end_loc.start_pos)
                corrector.replace(whitespace, ' ' * expect)
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Top-level namespaces are likely to conflict and should be avoided.
        #
        # @example
        #   # bad
        #   interface _Option
        #     def option: () -> untyped
        #   end
        #
        #   # good
        #   class Foo
        #     interface _Option
        #       def option: () -> untyped
        #     end
        #   end
        #
        class TopLevelInterface < RuboCop::RBS::CopBase
          MSG = 'Top level interface detected.'

          def on_rbs_new_investigation
            @last_end = nil
          end

          def on_rbs_class(decl)
            return unless @last_end_pos.nil? || (@last_end_pos < decl.location.end_pos)

            @last_end_pos = decl.location.end_pos
          end
          alias on_rbs_module on_rbs_class

          def on_rbs_interface(decl)
            return unless @last_end_pos.nil? || (@last_end_pos < decl.location.start_pos)
            return unless decl.name.namespace.path.empty?

            range = location_to_range(decl.location)
            add_offense(range)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks for redundant access modifiers in class and module definitions.
        #
        # @example
        #   # bad
        #   class Foo
        #     public # this is redundant (default access is public)
        #
        #     def method: () -> void
        #   end
        #
        #   # bad
        #   class Foo
        #     # The following is redundant (methods defined on the class'
        #     # singleton class are not affected by the private modifier)
        #     private
        #
        #     def self.method3: () -> void
        #   end
        #
        #   # bad
        #   class Foo
        #     private # this is redundant (no following methods are defined)
        #   end
        #
        #   # good
        #   class Foo
        #     private # this is not redundant (a method is defined)
        #
        #     def method2
        #     end
        #   end
        #
        class UselessAccessModifier < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Useless `%<current>s` access modifier.'

          def on_rbs_class(decl)
            current = nil
            unused = true
            decl.members.each do |member|
              next unless member.location

              case member
              when ::RBS::AST::Members::Public
                if current.nil? || current.is_a?(::RBS::AST::Members::Public)
                  range = location_to_range(member.location)
                  add_offense(range, message: format(MSG, { current: 'public' })) do |corrector|
                    autocorrect(corrector, range)
                  end
                end
                current = member
              when ::RBS::AST::Members::Private
                if current.is_a?(::RBS::AST::Members::Private)
                  range = location_to_range(member.location)
                  add_offense(range, message: format(MSG, { current: 'private' })) do |corrector|
                    autocorrect(corrector, range)
                  end
                end
                current = member
              when ::RBS::AST::Members::MethodDefinition
                if member.kind != :singleton
                  unused = false
                end
              end
            end

            if unused && current
              range = location_to_range(current.location)
              vis = case current
                    when ::RBS::AST::Members::Public
                      'public'
                    when ::RBS::AST::Members::Private
                      'private'
                    end
              add_offense(range, message: format(MSG, { current: vis })) do |corrector|
                autocorrect(corrector, range)
              end
            end
          end
          alias on_rbs_module on_rbs_class

          def autocorrect(corrector, range)
            line = range_by_whole_lines(range, include_final_newline: true)
            corrector.remove(line)
          end
        end
      end
    end
  end
end

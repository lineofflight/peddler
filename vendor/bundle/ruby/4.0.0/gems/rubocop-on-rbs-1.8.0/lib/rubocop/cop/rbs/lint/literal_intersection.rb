# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are no repeated overload bodies
        #
        # @example default
        #   # bad
        #   1 & 2
        #
        #   # bad
        #   1 & _Foo
        #
        class LiteralIntersection < RuboCop::RBS::CopBase
          MSG = "Don't use literals with `&`."

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def check_type(type)
            on_type([::RBS::Types::Intersection], type) do |intersection|
              check_intersection(intersection)
            end
          end

          def on_rbs_constant(type)
            check_type(type.type)
          end
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          def check_intersection(intersection)
            intersection.types.each do |type|
              check_intersection_child(type)
            end
          end

          def check_intersection_child(type)
            case type
            when ::RBS::Types::Literal
              range = location_to_range(type.location)
              add_offense(range)
            when ::RBS::Types::Intersection
              check_intersection(type)
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are no repeated overload bodies.
        # This cop ignores the difference of return type.
        #
        # @example
        #   # bad
        #   def foo: () -> void
        #          | () -> top
        #
        class DuplicateOverload < RuboCop::RBS::CopBase
          MSG = 'Duplicate overload arguments detected.'

          def on_rbs_def(decl)
            overloads = decl.overloads
            overloads.each_with_index do |overload, idx|
              next if idx == overloads.size - 1

              next_overloads = overloads[(idx + 1)..-1]
              next_overloads.each do |next_overload|
                a = method_type_with_untyped_return_type(overload.method_type)
                b = method_type_with_untyped_return_type(next_overload.method_type)
                next unless a == b

                range = location_to_range(next_overload.method_type.location)
                add_offense(range)
              end
            end
          end

          private

          def method_type_with_untyped_return_type(method_type)
            type = method_type.type.with_return_type(::RBS::Types::Bases::Any.new(location: nil))
            method_type.update(type:)
          end
        end
      end
    end
  end
end

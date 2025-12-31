# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Specifying the `Hash` type for `**` is a very special case and,
        # in most situations, it is a mistake in type specification.
        #
        # @example
        #   # bad
        #   def foo: (**Hash[Symbol, String]) -> void
        #   # e.g.) foo(a: {x: "x"}, b: {y: "y"}, c: {z: "z"})
        #
        #   # good
        #   def foo: (**String) -> void
        #   # e.g.) foo(a: "x", b: "y", c: "z")
        #
        class RestKeywordHash < RuboCop::RBS::CopBase
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              func = overload.method_type.type
              next unless func.is_a?(::RBS::Types::Function)

              if !func.rest_keywords.nil?
                check_type(func.rest_keywords.type)
              end
            end
          end

          def check_type(type)
            case type
            when ::RBS::Types::ClassInstance
              if type.name.relative!.to_s == 'Hash'
                did_you_mean = type.args[1] or return
                range = location_to_range(type.location)
                message = "The type of `**` specifies only the type of value. " \
                          "Did you mean `**#{did_you_mean}`?"
                add_offense(range, message:)
              end
            end
          end
        end
      end
    end
  end
end

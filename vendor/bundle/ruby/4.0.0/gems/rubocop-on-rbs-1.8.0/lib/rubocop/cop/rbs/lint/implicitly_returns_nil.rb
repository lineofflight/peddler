# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # This cop checks for conflicts between `implicitly-returns-nil` annotations and return types.
        #
        # @example
        #   # bad
        #   %a{implicitly-returns-nil}
        #   def foo: () -> Integer?
        #
        #   # good
        #   %a{implicitly-returns-nil}
        #   def foo: () -> Integer
        #
        #   # good
        #   def foo: () -> Integer?
        #
        class ImplicitlyReturnsNil < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = "There is a conflict between `%<annotation>s` and return type `%<return_type>s`."

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              annotation = find_implicitly_returns_nil(decl) || find_implicitly_returns_nil(overload)
              next unless annotation
              next unless overload_returns_nil?(overload)

              return_type = overload.method_type.type.return_type.to_s
              range = location_to_range(annotation.location)
              message = format(MSG, annotation: annotation.location.source, return_type:)
              add_offense(range, message:)
            end
          end

          private

          def find_implicitly_returns_nil(decl)
            decl.annotations.find { |a| a.string == 'implicitly-returns-nil' }
          end

          def overload_returns_nil?(overload)
            returns_nil?(overload.method_type.type.return_type)
          end

          def returns_nil?(type)
            case type
            when ::RBS::Types::Bases::Nil,
                 ::RBS::Types::Optional
              true
            when ::RBS::Types::Union
              type.types.any? { |t| returns_nil?(t) }
            else
              false
            end
          end
        end
      end
    end
  end
end

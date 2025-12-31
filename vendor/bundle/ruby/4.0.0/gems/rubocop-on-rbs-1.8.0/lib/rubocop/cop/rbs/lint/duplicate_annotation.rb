# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are no repeated annotations.
        #
        # @example
        #   # bad
        #   def %a{foo} %a{foo} def foo: () -> void
        #
        #   # bad
        #   def %a{foo} foo: %a{foo} () -> void
        #
        #   # bad
        #   def foo: %a{foo} %a{foo} () -> void
        #
        #   # not bad
        #   def foo: %a{foo} () -> void
        #          | %a{foo} (Integer) -> void
        #
        class DuplicateAnnotation < RuboCop::RBS::CopBase
          MSG = 'Duplicate annotation detected.'

          def on_rbs_def(decl)
            decl.annotations.each_with_index do |annotation, idx|
              next_annotations = decl.annotations[(idx + 1)..] or next
              check_annotations(annotation, next_annotations)

              decl.overloads.each do |overload|
                check_annotations(annotation, overload.annotations)
              end
            end

            decl.overloads.each do |overload|
              overload.annotations.each_with_index do |overload_annotation, idx|
                next_annotations = overload.annotations[(idx + 1)..] or next
                check_annotations(overload_annotation, next_annotations)
              end
            end
          end

          def check_annotations(left_annotation, right_annotations)
            right_annotations.each do |right_annotation|
              next unless left_annotation == right_annotation
              next unless right_annotation.location

              range = location_to_range(right_annotation.location)
              add_offense(range)
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for empty lines between declarations.
        #
        # @example Class: true (default)
        #   # checks for empty lines between class declarations.
        #
        #   # bad
        #   class A
        #   end
        #   class B
        #   end
        #
        #   # good
        #   class A
        #   end
        #
        #   class B
        #   end
        #
        # @example Module: true (default)
        #   # checks for empty lines between module declarations.
        #
        #   # bad
        #   module A
        #   end
        #   module B
        #   end
        #
        #   # good
        #   module A
        #   end
        #
        #   module B
        #   end
        #
        # @example Interface: true (default)
        #   # checks for empty lines between interface declarations.
        #
        #   # bad
        #   interface _A
        #   end
        #   interface _B
        #   end
        #
        #   # good
        #   interface _A
        #   end
        #
        #   interface _B
        #   end
        #
        class EmptyLineBetweenDeclarations < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Expected %<expected>s between %<type>s definitions; found %<actual>d.'

          def on_rbs_new_investigation
            [nil, *processed_rbs_source.decls, nil].each_cons(2) do |decls|
              check_decls(decls)
            end
          end

          private

          def check_decls(decls)
            walk_pair(decls) do |before, after|
              next unless candidate?(before) && candidate?(after)

              check(before, after)
            end
          end

          def walk_pair(decls, &block)
            before, after = decls

            case before
            when ::RBS::AST::Declarations::Class,
                 ::RBS::AST::Declarations::Module,
                 ::RBS::AST::Declarations::Interface
              case after
              when ::RBS::AST::Declarations::Class,
                   ::RBS::AST::Declarations::Module,
                   ::RBS::AST::Declarations::Interface
                block.call(before, after)
              end
              [nil, *before.members, nil].each_cons(2) do |members|
                walk_pair(members, &block)
              end
            end
          end

          def check(before, after)
            count = blank_lines_count_between(before, after)
            return if count == 1
            return if multiple_blank_lines_groups?(before, after)

            after_start_line = processed_source.lines[after.location.start_line - 1]
            range = range_between(after.location.start_pos, after.location.start_pos + after_start_line.length)
            type = decl_type(after)
            add_offense(range, message: format(MSG, expected: "1 empty line", type:, actual: count)) do |corrector|
              if count.zero?
                range_of_first = location_to_range(location_of_first(after))
                corrector.insert_before(range_by_whole_lines(range_of_first), "\n")
              else
                range_to_remove = range_between(before.location.end_pos + 1, location_of_first(after).start_pos)
                corrector.remove(range_to_remove)
              end
            end
          end

          def decl_type(decl)
            case decl
            when ::RBS::AST::Declarations::Class
              'class'
            when ::RBS::AST::Declarations::Module
              'module'
            when ::RBS::AST::Declarations::Interface
              'interface'
            end
          end

          def multiple_blank_lines_groups?(first_def_decl, second_def_decl)
            lines = lines_between_decl(first_def_decl, second_def_decl)
            blank_start = lines.each_index.select { |i| lines[i].blank? }.max
            non_blank_end = lines.each_index.reject { |i| lines[i].blank? }.min
            return false if blank_start.nil? || non_blank_end.nil?

            blank_start > non_blank_end
          end

          def lines_between_decl(first_def_decl, second_def_decl)
            begin_line_num = first_def_decl.location.end_line
            end_line_num = location_of_first(second_def_decl).start_line - 2
            return [] if end_line_num.negative?

            processed_source.lines[begin_line_num..end_line_num]
          end

          def blank_lines_count_between(before, after)
            lines_between_decl(before, after).count(&:blank?)
          end

          def location_of_first(decl)
            [
              *decl.annotations.map(&:location),
              decl.comment&.location,
              decl.location
            ].compact.min_by(&:start_pos)
          end

          def candidate?(decl)
            class_candidate?(decl) || module_candidate?(decl) || interface_candidate?(decl)
          end

          def class_candidate?(decl)
            cop_config['Class'] && decl.is_a?(::RBS::AST::Declarations::Class)
          end

          def module_candidate?(decl)
            cop_config['Module'] && decl.is_a?(::RBS::AST::Declarations::Module)
          end

          def interface_candidate?(decl)
            cop_config['Interface'] && decl.is_a?(::RBS::AST::Declarations::Interface)
          end
        end
      end
    end
  end
end

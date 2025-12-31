# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for unnecessary spacing between tokens.
        #
        # @example
        #   # bad
        #   def   foo:   ()   ->   void
        #
        #   # good
        #   def foo: () -> void
        #
        class ExtraSpacing < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Unnecessary spacing detected.'

          def on_rbs_new_investigation
            aligned_comments = aligned_locations()
            tokens = processed_rbs_source.tokens.reject { |t| t.type == :tTRIVIA }
            tokens.each_cons(2) do |a, b|
              next unless a&.location
              next unless b&.location

              if (b.type == :tCOMMENT || b.type == :tLINECOMMENT)
                next if aligned_comments.include?(b.location.start_line)
              end
              next if a.location.end_line != b.location.start_line
              next if a.location.end_pos + 1 >= b.location.start_pos

              space = range_between(a.location.end_pos, b.location.start_pos - 1)
              add_offense(space) do |corrector|
                corrector.remove(space)
              end
            end
          end

          def aligned_locations
            comments = processed_rbs_source.tokens.select(&:comment?)
            Set.new.tap do |aligned|
              comments.map(&:location).each_cons(2) do |loc1, loc2|
                next unless loc1
                next unless loc2

                if loc1.start_column == loc2.start_column
                  aligned << loc1.start_line << loc2.start_line
                end
              end
            end
          end
        end
      end
    end
  end
end

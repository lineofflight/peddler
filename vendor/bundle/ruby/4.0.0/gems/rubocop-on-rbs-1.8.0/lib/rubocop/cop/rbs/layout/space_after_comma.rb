# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for missing spaces after commas.
        #
        # @example
        #   # bad
        #   def foo: (Integer,String) -> void
        #
        #   # good
        #   def foo: (Integer, String) -> void
        #
        class SpaceAfterComma < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Space missing after comma.'

          def on_rbs_new_investigation
            processed_rbs_source.tokens.each_cons(2) do |comma, after|
              next unless comma.type == :pCOMMA
              next unless comma.location
              next unless comma.location.end_line == after.location.start_line
              next unless after.type != :tTRIVIA

              range = location_to_range(comma.location)
              add_offense(range) do |corrector|
                corrector.insert_after(range, ' ')
              end
            end
          end
        end
      end
    end
  end
end

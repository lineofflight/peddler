# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks for deprecated global expectations
      # and autocorrects them to use expect format.
      #
      # @example EnforcedStyle: any (default)
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   # good
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: _
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      #   # good
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: expect
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      #   # good
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: value
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   # good
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      class GlobalExpectations < Base
        include ConfigurableEnforcedStyle
        extend AutoCorrector

        MSG = 'Use `%<preferred>s` instead.'

        VALUE_MATCHERS = %i[
          must_be_empty must_equal must_be_close_to must_be_within_delta
          must_be_within_epsilon must_include must_be_instance_of must_be_kind_of
          must_match must_be_nil must_be must_respond_to must_be_same_as
          path_must_exist path_wont_exist wont_be_empty wont_equal wont_be_close_to
          wont_be_within_delta wont_be_within_epsilon wont_include wont_be_instance_of
          wont_be_kind_of wont_match wont_be_nil wont_be wont_respond_to wont_be_same_as
        ].freeze

        BLOCK_MATCHERS = %i[
          must_output must_pattern_match must_raise must_be_silent must_throw wont_pattern_match
        ].freeze

        RESTRICT_ON_SEND = VALUE_MATCHERS + BLOCK_MATCHERS

        # There are aliases for the `_` method - `expect` and `value`
        DSL_METHODS = %i[_ expect value].freeze

        def on_send(node)
          receiver = node.receiver
          return unless receiver

          method = block_receiver?(receiver) || value_receiver?(receiver)
          return if method == preferred_method || (method && style == :any)

          register_offense(node, method)
        end

        private

        def_node_matcher :block_receiver?, <<~PATTERN
          (block (send nil? $#method_allowed?) _ _)
        PATTERN

        def_node_matcher :value_receiver?, <<~PATTERN
          (send nil? $#method_allowed? _)
        PATTERN

        def method_allowed?(method)
          DSL_METHODS.include?(method)
        end

        def preferred_method
          style == :any ? :_ : style
        end

        def preferred_receiver(node)
          receiver = node.receiver

          if BLOCK_MATCHERS.include?(node.method_name)
            body = receiver.lambda? ? receiver.body : receiver
            "#{preferred_method} { #{body.source} }"
          else
            "#{preferred_method}(#{receiver.source})"
          end
        end

        def register_offense(node, method)
          receiver = node.receiver

          if method
            preferred = preferred_method
            replacement = receiver.source.sub(method.to_s, preferred_method.to_s)
          else
            preferred = preferred_receiver(node)
            replacement = preferred
          end

          message = format(MSG, preferred: preferred)

          add_offense(receiver, message: message) do |corrector|
            corrector.replace(receiver, replacement)
          end
        end
      end
    end
  end
end

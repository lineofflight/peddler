require 'helper'
require 'peddler/errors/handler'

class TestPeddlerErrorsHandler < MiniTest::Test
  def setup
    @error = Peddler::Errors::Handler.call(@cause)
  end

  class CausedByHTTPStatusError < TestPeddlerErrorsHandler
    def setup
      @code = 'FeedProcessingResultNotReady'
      @message = 'Feed Submission Result is not ready for Feed 123'
      @cause = Excon::Errors::NotFound.new(
        'Expected(200) <=> Actual(404 Not Found)',
        nil,
        build_response('Code' => @code, 'Message' => @message)
      )
      super
    end

    def test_generates_custom_error
      assert_includes @error.class.name, @code
    end

    def test_caches_custom_error
      assert_equal @error.class, Peddler::Errors::Handler.instance.errors.fetch(@code)
    end

    def test_provides_message
      assert_equal @message, @error.message
    end

    def test_provides_cause
      assert_equal @cause, @error.cause
    end

    private

    def build_response(payload)
      mock = BasicObject.new
      (class << mock; self; end).send(:define_method, :parse) { payload }

      mock
    end
  end

  class CausedByAnotherError < TestPeddlerErrorsHandler
    def setup
      @cause = StandardError.new
      super
    end

    def test_returns_original_error
      assert_equal @cause, @error
    end
  end
end

# frozen_string_literal: true

require 'helper'
require 'peddler/errors/builder'

class TestPeddlerErrorsBuilder < MiniTest::Test
  def setup
    @error = Peddler::Errors::Builder.call(@cause)
  end

  class CausedByHTTPStatusError < TestPeddlerErrorsBuilder
    def setup
      @code = 'FeedProcessingResultNotReady'
      @message = 'Feed Submission Result is not ready for Feed 123'
      body = <<-XML
        <ErrorResponse>
          <Error>
            <Code>#{@code}</Code>
            <Message>#{@message}</Message>
          </Error>
        </ErrorResponse>
      XML
      @cause = Excon::Error::NotFound.new(
        'Expected(200) <=> Actual(404 Not Found)',
        nil,
        OpenStruct.new(body: body)
      )
      super
    end

    def test_generates_custom_error
      assert_includes @error.class.name, @code
    end

    def test_provides_message
      assert_equal @message, @error.message
    end

    def test_provides_cause
      assert_equal @cause, @error.cause
    end
  end

  class CausedByInternalServerError < TestPeddlerErrorsBuilder
    def setup
      body = <<-XML
        <ErrorResponse>
          <Error>
            <Code>500</Code>
          </Error>
        </ErrorResponse>
      XML
      @cause = Excon::Error::InternalServerError.new(
        nil,
        nil,
        OpenStruct.new(body: body)
      )
      super
    end

    def test_returns_nothing
      assert_nil @error
    end
  end
end

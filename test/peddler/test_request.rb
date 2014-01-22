require 'helper'
require 'excon'
require 'peddler/request'

class PeddlerRequestTest < MiniTest::Test
  def mock_client
    Object.new.tap do |o|
      def o.post(opts = {})
        Excon.post('http://localhost', opts)
      end
    end
  end

  def setup
    @body = 'body'
    Excon.defaults[:mock] = true
    Excon.stub({}, { body: @body, status: 200 })
  end

  def teardown
    Excon.stubs.clear
    Excon.defaults.delete(:mock)
  end

  def test_executes
    request = Peddler::Request.new(mock_client)
    mock_parser = Minitest::Mock.new
    mock_parser.expect(:xml?, false)
    mock_parser.expect(:new, nil, [@body])
    request.parser = mock_parser
    request.execute
    assert mock_parser.verify
  end

  def test_streams_response
    chunks = ''
    stream = -> (chunk, _, _) { chunks << chunk }
    request = Peddler::Request.new(mock_client)
    request.execute(&stream)
    assert_equal @body, chunks
  end
end

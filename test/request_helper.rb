require 'helper'

class RequestTest < Minitest::Test
  def mock_response_body
    raise NotImplementedError
  end

  def mock_response
    res = Minitest::Mock.new
    res.expect(:body, mock_response_body)

    Peddler::ResponseWrapper.new(res)
  end

  def mock_client
    client = Minitest::Mock.new
    client.expect(:marketplace_id, '123456')
    client.expect(:post, mock_response, [Hash])
  end
end

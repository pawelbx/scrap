require_relative 'invalid_http_request_error'

class HttpRequest
  attr_accessor :url, :method, :version

  def initialize(request)
    raise InvalidHttpRequestError if request.nil?
    request_parts = request.split(' ')
    raise InvalidHttpRequestError if request_parts.length < 3
    @method = request_parts[0]
    @url = request_parts[1]
    @version = request_parts[2]
  end
end

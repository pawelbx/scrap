require 'invalid_http_request_error'
class HttpRequest
  attr_accessor :url, :method, :version
  def initialize(request)
    raise InvalidHttpRequestError if request.nil?
    request_parts = request.split(' ')
    raise InvalidHttpRequestError if request_parts.length < 3
    @method = request_parts.first
    @url = request_parts.second
    @version = request_parts.third
  end
end

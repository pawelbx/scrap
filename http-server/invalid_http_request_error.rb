class InvalidHttpRequestError < StandardError
  def initialize(msg = 'Invalid HTTP request')
    super(msg)
  end
end

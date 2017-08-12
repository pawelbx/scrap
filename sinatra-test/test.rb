# myapp.rb
require 'sinatra'

get '/' do
  t1 = Time.now.to_i
  t2 = t1 + 10
  i = params[:request_i]
  while Time.now.to_i < t2
    # sleep 0
    puts i
  end
  'hello'
end

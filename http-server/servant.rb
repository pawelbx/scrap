#!/usr/bin/ruby
require 'socket'
require 'optparse'
require 'byebug'
require_relative 'http_request'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: servant.rb [options]"
  opts.on("-dDirectory", "--directory DIRECTORY") { |dir| options[:dir] = dir }
end.parse!

raise OptionParser::MissingArgument if options[:dir].nil?

def socket_listen(port: 3000)
  socket = Socket.new(:INET, :STREAM)
  status = socket.bind(Addrinfo.tcp('127.0.0.1', port))
  raise IOError("Error binding socket: #{status}") unless status.zero?
  socket.listen(5)
  raise IOError("Error listening on socket: #{status}") unless status.zero?
  socket
end

def response(payload)
  server_header = <<-HEADER
HTTP/1.1 200 OK
Keep-Alive: timeout=600
Connection: Keep-Alive
Content-Type: text/plain
Content-Length: #{payload.bytesize}
Status: 200
Date: #{Time.now}

#{payload}
HEADER
end

begin
  socket = socket_listen
  loop do
    puts 'Listening...'
    Thread.new(socket.accept) do |client_socket, client_addrinfo|
      puts "Accepted client connection: #{client_socket.inspect}"
      puts "Client information: #{client_addrinfo.inspect}"
      client_msg = client_socket.recv(4096)
      puts "Received from client: #{client_msg}"

      http_request = HttpRequest.new(client_msg)

      puts "HTTP Request: #{http_request}"
      root_path = File.expand_path(options[:dir])
      request_path = File.expand_path(options[:dir] + http_request.url)
      request_path_dir_list = request_path.split('/')
      root_path_dir_list = root_path.split('/')
      valid_dir = request_path_dir_list[0..root_path_dir_list.size - 1] == root_path_dir_list
      if !valid_dir
        return 401
      end

      request_path += '/index.html' if request_path == root_path

      if File.file?(request_path)
        payload = File.open(request_path).read
        full_msg = response(payload)
      else
        return 404
      end

      client_socket.send(full_msg, 0)
      puts 'Message sent'
    end
  end

rescue InvalidHttpRequestError => e
  puts e
rescue StandardError => e
  puts e
ensure
  socket.close
end

#!/usr/bin/ruby
require 'socket'
require 'optparse'

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

def parse_url
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

      client_socket.send(full_msg, 0)
      client_socket.flush
      puts 'Message sent'
    end
  end
  
  payload = 'Hello World!'
  server_header = <<-HEADER
HTTP/1.1 200 OK
Keep-Alive: timeout=600
Connection: Keep-Alive
Content-Type: text/plain
Content-Length: #{payload.bytesize}
Status: 200
Date: #{Time.now}

HEADER

  full_msg = server_header + payload
rescue StandardError => e
  puts e
ensure
  socket.close
end

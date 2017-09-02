require 'socket'

begin
  socket = Socket.new(:INET, :STREAM)
  status = socket.bind(Addrinfo.tcp('127.0.0.1', 3001))

  unless status.zero?
    puts "Error binding socket: #{status}"
    return status
  end

  status = socket.listen(5)

  unless status.zero?
    puts "Error listening: #{status}"
    return status
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
rescue StandardError => e
  puts e
ensure
  socket.close
end

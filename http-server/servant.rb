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

  server_msg = <<-MSG 
HTTP/1.1 200 OK
Content-Type: text/plain
Status: 200
Date: #{Time.now}

Hello World!

<html>
<head>
  <title>An Example Page</title>
</head>
<body>
  Hello World, this is a very simple HTML document.
</body>
</html>
MSG

  loop do
    puts "Listening..."
    client_socket, client_addrinfo = socket.accept
    puts "Accepted client connection: #{client_socket.inspect}"
    puts "Client information: #{client_addrinfo.inspect}"

    client_msg = client_socket.recv(4096)

    puts "Received from client: #{client_msg}"

    client_socket.send(server_msg, 0)
    client_socket.flush
    puts "Message sent"
    #client_socket.close
  end

rescue StandardError => e
  puts e
ensure
  socket.close
end

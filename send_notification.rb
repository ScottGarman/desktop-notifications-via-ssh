#!/usr/bin/ruby
#
# Send desktop notification messages to the companion receiver
# script, receive_notifications.rb, using a TCP socket.

require 'socket'

# Add a port number for each listening receiver you may have.
ports = [4180,4181]

if ARGV.length != 2
	puts "Usage: send_irc_notification.rb <summary> <body>"
	exit 1
end

summary = ARGV[0]
body = ARGV[1]
message = "#{summary}@@@#{body}"

ports.each do |port|
	# Skip this port if there are no servers listening
	begin
		client = TCPSocket.new('localhost', port)
	rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
		next
	end

	client.send(message,0)
	client.close
end

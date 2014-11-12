#!/usr/bin/ruby
#
# Create a TCP server which listens for messages sent from the
# compantion send_notification.rb script. The format of these
# messages are:
#
# <summary>@@@<body>

require 'socket'

# Change this to play a sound when notifications are received
alert_sound_cmd = "ogg123 /usr/share/sounds/KDE-Im-Nudge.ogg > /dev/null 2>&1"

if ARGV.length != 1
	puts "Usage: receive_irc_notifications.rb <listen-port>"
	exit 1
end

port = ARGV[0].to_i
if port <= 1024
	puts "Error: listen-port must be a number above 1024"
	exit 1
end

# This loop restarts the socket in case the client disconnects:
while true
	listener = TCPServer.new('localhost', port)
	session = listener.accept

	while message = session.gets
		# Ignore malformed messages
		if !message.include? "@@@"
			puts "Ignoring message, missing @@@ separator"
			next
		end

		summary, body = message.split("@@@")
		# Escape any double-quotes:
		summary.gsub!('"', '\"')
		body.gsub!('"', '\"')

		# Play a sound and send the desktop notification
		system(alert_sound_cmd)
		system("notify-send \"#{summary}\" \"#{body}\"")
	end
	listener.close
end

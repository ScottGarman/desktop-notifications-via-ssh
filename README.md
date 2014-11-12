desktop-notifications-via-ssh
=============================

I use IRC from multiple computers and prefer to stay connected to the server 24/7. My previous setup using a bouncer such as ZNC and xchat-gnome was getting boring, so I wanted to try something a bit simpler, and run a console IRC client (weechat) on a single server and connect to it via screen. This led to the problem of missing notifications when receiving messages.

To remedy this, I looked at some examples of sending desktop notification events over an ssh tunnel, especially this project:

https://github.com/itsamenathan/libnotify-over-ssh

This prompted me to write a variation of the concept in which the client can send notification messages to an arbitrary number of desktop machines, each connected via a different TCP port.

Thanks to itsamenathan for the initial concept. My variation of it is written in Ruby instead of Perl.

== Usage ==

== Desktop Machines ==

Edit receive_notifications.rb to customize the command line for playing an alert sound to your preferences.

* Add "receive_notifications.rb <listen-port> to your desktop's startup apps
* Edit .ssh/config and add "RemoteForward <listen-port> 127.0.0.1:<listen-port>" to your IRC machine's connection
* (From the command line you can alternately run ssh -R <listen-port>:127.0.0.1:<listen-port> user@host)

== IRC Machine ==

Edit the ports array in send_notification.rb to include which ports your desktop machines are listening on.

Copy send_notification.rb to the machine running IRC. Run the script from your IRC client with the following syntax:

  send_notification.rb "<summary-msg>" "<body-msg>"

The script will try to connect to each desktop machine to send the notification. Not all desktops have to be connected in order for it to work. If multiple desktops are connected, all of them will receive the notification. 

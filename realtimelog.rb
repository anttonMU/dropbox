#!/usr/bin/ruby
# dropbox status in console.
# http://dl.getdropbox.com/u/76825/dropbox_status.rb
# http://d.hatena.ne.jp/urekat/20081124/1227498262
# http://forums.getdropbox.com/tags.php?tag=cli

require "socket"
require "pathname"

#command_sock_path = File.expand_path("~/.dropbox/command_socket")
iface_sock_path   = File.expand_path("~/.dropbox/iface_socket")
#s_command = UNIXSocket.open(command_sock_path)
s_iface   = UNIXSocket.open(iface_sock_path)

def cmd_done(lines)
  case lines[0]
  when "change_to_menu"
    # "active\ttrue"
  when "change_state"
    # "new_state\t1"
  when "refresh_tray_menu"
    # "active\ttrue"
  when "shell_touch"
    puts "[#{Time.now.inspect}] "+lines[1].gsub(/^path\t/, "")
  when "bubble"
    s = "[#{Time.now.inspect}]--------"
    puts s
    lines[1,lines.size-2].each do |l|
      puts "    "+l
    end
    puts "-" * s.size
  else
    puts "unknown:"+lines.inspect
  end
end

lines = []
loop{
  l = s_iface.gets
  break unless l
  l.strip!
  lines << l
  if l=="done"
    cmd_done(lines)
    lines = []
  end
}

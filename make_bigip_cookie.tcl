set member_ip "10.1.1.100"
set member_port "8080"
puts member_ip:$member_ip
puts member_port:$member_port
set x [split $member_ip .]
set xl [llength $x]
for { set i [expr $xl -1] } { $i > -1 } { incr i -1 } {
	lappend reversed [lindex $x $i]
}
foreach rev $reversed {
	set hex_val [format %0*X 2 $rev]
	append big_hex_val $hex_val
}
set big_hex_val "0x$big_hex_val"

puts "Pool Member IP Encoded: [format %d $big_hex_val]"

if { $member_port < 256 } {
	set member_port "00$member_port"
}
set a [format %0*X 2 [string range $member_port 0 1 ]]
set b [format %0*X 2 [string range $member_port 2 end ]]

set hex_member_port 0x$b$a

puts "Port Encoded: [format %d $hex_member_port]"










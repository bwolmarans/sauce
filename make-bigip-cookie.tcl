#!/usr/bin/tclsh
#set member_ip "10.1.1.100"
#set member_port "8080"
if { $argc != 2 } {
	puts "The make_bigip_cookie.tcl script requires two command-line arguments."
	puts "Format: make-bigip-cookie <pool member IPv4 address> <pool member port>"
	puts "For example, make-bigip-cookie 10.1.1.100 8080"
	puts "\nPlease try again."
	exit
} else {
	set member_ip [lindex $argv 0]
	set member_port [lindex $argv 1]
}


puts "Pool Member IP:$member_ip"
puts "Pool Member Port:$member_port"
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

# encode in 2 byte hex
if { $member_port < 256 } {
	set member_port "00[format %x $member_port]"
} else {
	set member_port [format %0*X 2 $member_port]
}

set a [string range $member_port 0 1 ]
set b [string range $member_port 2 end ]
set hex_member_port 0x$b$a
puts "Pool Member Port Encoded: [format %d $hex_member_port]"










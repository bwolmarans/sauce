proc resolve_this { fqdn server {answer ""} } {
	#puts "resolving $fqdn at $server"
	set err [exec dig +short @$server $fqdn a > resolvv.txt]
	set fh [open resolvv.txt r]
	set l1 [split [string trim [read $fh]]]
	close $fh
	#puts l1:$l1
	foreach i $l1 {
			set i [string tolower $i]
			set x [regexp {[a-z]} $i]
			#puts " i:$i x:$x"
			#after 100
			if { $x } {
					#puts "  asking $i"
					resolve_this $i $server $answer
			} else {
					set answer "$answer\n$i"
					#puts "   answer:$i"
			}
	}
	return $answer
}

set final_answer [resolve_this [lindex $argv 0] [lindex $argv 1]]
puts "Final Answer\n-------------------"
puts [string trim $final_answer]

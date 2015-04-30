#b.wolmarans@f5.com

package require TclCurl

proc main { }  {
	global serverlist
	set serverlist ""
	global servercountarray
	set uri "http://www.f5.com"
	#puts "How many sessions do you want to spawn?"
	#gets stdin num_sessions
	#puts "How many times do you want each session to do the cURL?"
	#gets stdin manytimes
	#puts "OK, running, go look at the Dashboard"
set num_sessions 3
set manytimes 3

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		set h($x) [curl::init]
		$h($x) configure -followlocation 1
		$h($x) configure -writeproc eat_it
		$h($x) configure -verbose 0
		$h($x) configure -encoding all
	}

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		for { set i 1 } { $i <= $manytimes } { incr i } {
			$h($x) configure -url $uri
			$h($x) perform
			set r [$h($x) getinfo responsecode]
			if { ! [info exists codes] } {
				set codes($r) 1
			} else {
				array set codes [arrayUnique [array get codes] $r 1]
			}
			#exec >@ stdout cmd.exe /c wmic cpu get loadpercentage
		}
	}

	puts ""
	puts "Response Codes Counts"
	puts "----------------------------------"
	foreach {code count} [array get codes] {
		puts "Response Code:$code Count:$count"
	}
}

proc arrayUnique { arr index value } {
#usage:
#array set code {200 1 300 1}
#array set code [arrayUnique [array get code] 200 1]
#puts [array get code]

	array set r2d2 [split $arr]
	set s [array startsearch r2d2]
	while { [array anymore r2d2  $s] } {
		set n [array nextelement r2d2 $s]
		if {  $n == $index } {
			set x [expr $value + $r2d2($index)]
			set r2d2($index) $x
			#puts "r2d2($index):$r2d2($index)"
			break
		} else {
			set r2d2($index) $value
		}

	}
	return [array get r2d2]
}

proc lappendUnique { arr item } {
	upvar $arr localarr
	if { ! [info exists localarr] } {
	  lappend localarr $item
	} else {
	  if { 0 > [lsearch $localarr $item] } {
		 lappend localarr $item
	  }
	}
}

proc eat_it { a } { return 0 }

proc parse_it { a } {
	global serverlist
	global servercountarray
	foreach x [split $a <] {
		if { [string first "from Server" $x ] > -1 } {
			set s [lindex [split $x] end]
			lappendUnique serverlist $s
			if { ! [info exists servercountarray($s)] } {
				set servercountarray($s) 0
			}
			incr servercountarray($s) 1
			break
		}
	}
	return 0
}

main
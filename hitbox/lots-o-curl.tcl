#b.wolmarans@f5.com

# set your VIP here

set vip 198.18.64.10


package require TclCurl

proc main { }  {
	global serverlist
	set serverlist ""
	global servercountarray

	puts "How many sessions do you want to spawn?"
	gets stdin num_sessions
	puts "How many times do you want each session to do the cURL?"
	gets stdin manytimes

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		set h($x) [curl::init]
		$h($x) configure -followlocation 1
		$h($x) configure -writeproc parse_it
		$h($x) configure -verbose 0
	}

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		for { set i 1 } { $i <= $manytimes } { incr i } {
			$h($x) configure -url http://198.18.64.10/
			$h($x) perform
			$h($x) configure -url http://198.18.64.10/left.gif
			$h($x) perform
			#exec >@ stdout cmd.exe /c wmic cpu get loadpercentage
		}
	}

	puts ""
	puts "Server   |   Number of Hits"
	puts "----------------------------------"
	foreach server $serverlist {
		puts "Server $server |    $servercountarray($server)"
	}
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
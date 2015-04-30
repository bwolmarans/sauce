package require TclCurl
set serverlist ""
set verbose 0

proc main { }  {
	global serverlist
	global servercountarray
	global verbose
	puts "How many sessions do you want to spawn?"
	gets stdin num_sessions
	puts "How many times do you want each session to do the cURL?"
	gets stdin manytimes

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		set h($x) [curl::init]
		$h($x) configure -followlocation 1
		$h($x) configure -writeproc parse_it
		$h($x) configure -verbose $verbose
	}


	for { set i 1 } { $i <= $manytimes } { incr i } {
	for { set x 1 } { $x <= $num_sessions } { incr x } {
	$h($x) configure -url http://10.10.20.30/
	$h($x) perform
	$h($x) configure -url http://10.10.20.30/left.gif
	$h($x) perform
	#exec >@ stdout cmd.exe /c wmic cpu get loadpercentage
	#after 1
	#curl::transfer -url http://10.10.20.30
	#curl::transfer -url http://10.10.20.30/left.gif
	#curl::transfer -url http://10.10.20.30/right.gif
	}
	}

	puts "Server   |   Number of Requests"
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
			#puts $x
			#after 1
			lappendUnique serverlist $s
			if { ! [info exists servercountarray($s)] } { set servercountarray($s) 0 }
				incr servercountarray($s) 1
		}
	}
	return 0
}

main
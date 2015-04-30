#curl_demo_bw.tcl
#version: 1.0
#8/18/2012
#b.wolmarans@f5.com




set vip 198.18.64.10
set server1 198.18.96.100
set server2 198.18.96.110
set server3 198.18.96.120

set verbose 0




######### ANY CHANGES AFTER THIS LINE WILL BE UNSUPPORTED #########




package require TclCurl
set serverlist ""


proc main { }  {
	global serverlist
	global servercountarray
	global verbose
	puts "Do you want to go (D)irectly to the servers or go (A)ccelerated?"
	gets stdin way_to_go
	puts "How many sessions do you want to spawn?"
	gets stdin num_sessions
	puts "How many times do you want each session to do the cURL?"
	gets stdin manytimes

	for { set x 1 } { $x <= $num_sessions } { incr x } {
		set h($x) [curl::init]
		$h($x) configure -followlocation 1
		$h($x) configure -writeproc parse_it
		$h($x) configure -verbose $verbose
		$h($x) configure -encoding all
	}


	puts [timestamp]
	for { set x 1 } { $x <= $num_sessions } { incr x } {
		for { set i 1 } { $i <= $manytimes } { incr i } {

			if { $way_to_go == "a" } {

				$h($x) configure -url http://198.18.64.10/
				$h($x) perform
				$h($x) configure -url http://198.18.64.10/left.gif
				$h($x) perform
				$h($x) configure -url http://198.18.64.10/right.gif
				$h($x) perform

			} else {

				#puts [expr $x % 3 ]

				set u [expr (($x%3)*10)+100]
				$h($x) configure -url http://198.18.96.$u/
				$h($x) perform
				$h($x) configure -url http://198.18.96.$u/left.gif
				$h($x) perform
				$h($x) configure -url http://198.18.96.$u/right.gif
				$h($x) perform

			}

			#exec >@ stdout cmd.exe /c wmic cpu get loadpercentage
			#after 1
			#curl::transfer -url http://198.18.64.10
			#curl::transfer -url http://198.18.64.10/left.gif
			#curl::transfer -url http://198.18.64.10/right.gif
		}
	}

	puts [timestamp]
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
			if { ! [info exists servercountarray($s)] } {
				set servercountarray($s) 0
			}
			incr servercountarray($s) 1
			#break
		}
	}
	return 0
}

##########################################################################################
# timestamp: returns a timestamp
##########################################################################################
proc timestamp {{t 0}} { return [timeStamp] }
proc timeStamp {{ t 0 } } {
set i [clock format [clock seconds] -format %D]
set j [clock format [clock seconds] -format %T]
set k "$i, $j"
return $k
}


main
set myfh [open bigip.conf r]
set mylines [split [read $myfh] \n]
close $myfh
set looking_for_pool_flag 0
set looking_for_members_flag 0
set looking_for_monitors_flag 0
set vss ""
set pools ""
set members ""
set monitors ""
set vs_list ""
foreach line $mylines {
	set line [string trim $line]
	set line [regsub -all "{" $line @@OPEN_SESAME@@]
	set line [regsub -all "}" $line @@CLOSE_SESAME@@]
	lappend mylines2 $line
}
foreach line $mylines2 {
	if { [string first "ltm virtual " $line] > -1 } {
		set temp [string range $line 0 [expr [string length $line] -2]]
		set vs_name [lindex $temp 2]
		set vss "vs:$vs_name "
		set looking_for_pool_flag 1
	}
	if { $looking_for_pool_flag == 1 } {
		if { [string first "pool " $line] > -1 } {
			set temp [string range $line 0 [expr [string length $line] -1]]
			set pool [lindex $temp 1]
			set looking_for_pool_flag 2
			foreach line $mylines2 {
				if { $looking_for_pool_flag == 2 } {
					if { [string first "ltm pool " $line] > -1 } {
						set temp [string range $line 0 [expr [string length $line] -1]]
						if { $pool == [lindex $temp 2] } {
							set looking_for_pool_flag 0
							set looking_for_members_flag 1
							set vs_string "$vss\n\tpool:$pool"
						}
					}
				}
				if { $looking_for_members_flag } {
					if { [string first "/" $line] == 0 } {
						set member [string trim $line "@@OPEN_SESAME@@"]
						set members "$members\n\t\t$member"
					}
					if { [string first "monitor" $line] == 0} {
						set looking_for_members_flag 0
						set looking_for_monitors_flag 1
					}
				}
				if { $looking_for_monitors_flag } {
					if { [string first "@@CLOSE_SESAME@@" $line] == 0 } {
						set looking_for_monitors_flag 0
						set vs_string "$vs_string members:$members monitors:$monitors"
						lappend vs_list $vs_string
					} elseif { [string first "monitor" $line] == 0 } {
						set monitors "$monitors\n\t\t\t$line"
					}
				}
			}
		}
	}
}

foreach vs $vs_list { puts $vs }

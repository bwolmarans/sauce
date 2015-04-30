
proc getFeedback { question } {
   puts -nonewline $question
   flush stdout
   return [gets stdin]
}



set zonename [getFeedback "Enter zone name (default: example1.local ( 1 will be replaced in the loop)) :"]
set zone1 [getFeedback "Enter Starting Zone number (default:1) :"]
set zone2 [getFeedback "Enter ending zone number ( default:1000) :"]
set temp1 [split $zonename .]
set front [lindex $temp1 0]
set back [lindex [split $zonename $front] end]
puts $front
puts $back

proc arrayUnique { arr index value } {
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

array set code {200 1 300 1}
array set code [arrayUnique [array get code] 200 1]
puts [array get code]


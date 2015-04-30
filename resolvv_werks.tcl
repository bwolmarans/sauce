#	;; ANSWER SECTION:
#	www.yahoo.com.          116     IN      CNAME   fd-fp3.wg1.b.yahoo.com.
#	fd-fp3.wg1.b.yahoo.com. 262     IN      CNAME   ds-fp3.wg1.b.yahoo.com.
#	ds-fp3.wg1.b.yahoo.com. 22      IN      CNAME   ds-any-fp3-lfb.wa1.b.yahoo.com.
#	ds-any-fp3-lfb.wa1.b.yahoo.com. 262 IN  CNAME   ds-any-fp3-real.wa1.b.yahoo.com.
#	ds-any-fp3-real.wa1.b.yahoo.com. 22 IN  A       98.138.252.30
#	ds-any-fp3-real.wa1.b.yahoo.com. 22 IN  A       98.139.180.149
#	ds-any-fp3-real.wa1.b.yahoo.com. 22 IN  A       98.139.183.24

proc resolve_this { server fqdn {answer ""} } {
	#puts "resolving $fqdn"
	set l1 [exec dig +short @$server $fqdn]
	foreach i $l1 {
		set i [string tolower $i]
		set x [regexp {[a-z]} $i]
		if { $x } {
			resolve_this $server $i $answer
			#puts " asking $i"
		} else {
			lappend answer "$i\n"
			#puts "  answer:$i"
		}
	}
	return $answer
}

set a [resolve_this 8.8.8.8 www.yahoo.com]
puts a:$a
puts [llength $a]

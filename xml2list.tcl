proc xml2list xml {
    regsub -all {>\s*<} [string trim $xml " \n\t<>"] "\} \{" xml
    set xml [string map {> "\} \{#text \{" < "\}\} \{"}  $xml]

    set res ""   ;# string to collect the result
    set stack {} ;# track open tags
    set rest {}
    foreach item "{$xml}" {
        switch -regexp -- $item {
            ^# {append res "{[lrange $item 0 end]} " ; #text item}
            ^/ {
                regexp {/(.+)} $item -> tagname ;# end tag
                set expected [lindex $stack end]
                if {$tagname!=$expected} {error "$item != $expected"}
                set stack [lrange $stack 0 end-1]
                append res "\}\} "
        }
            /$ { # singleton - start and end in one <> group
                regexp {([^ ]+)( (.+))?/$} $item -> tagname - rest
                set rest [lrange [string map {= " "} $rest] 0 end]
                append res "{$tagname [list $rest] {}} "
            }
            default {
                set tagname [lindex $item 0] ;# start tag
                set rest [lrange [string map {= " "} $item] 1 end]
                lappend stack $tagname
                append res "\{$tagname [list $rest] \{"
            }
        }
        if {[llength $rest]%2} {error "att's not paired: $rest"}
    }
    if [llength $stack] {error "unresolved: $stack"}
    string map {"\} \}" "\}\}"} [lindex $res 0]
}

proc list2xml list {
    switch -- [llength $list] {
        2 {lindex $list 1}
        3 {
            foreach {tag attributes children} $list break
            set res <$tag
            foreach {name value} $attributes {
                append res " $name=\"$value\""
            }
            if [llength $children] {
                append res >
                foreach child $children {
                    append res [list2xml $child]
                }
                append res </$tag>
            } else {append res />}
        }
        default {error "could not parse $list"}
    }
}

#-------------------------------------------- now testing:
set my_xml {<foo a="b">bar and<grill x:c="d" e="f g"><baz x="y"/></grill><room/></foo>}
set my_xml {
	<html>
 <head>
 <title>XML Shallow Parsing with Regular Expressions</title>
 <meta http-equiv="Pragma" content="no-cache"></meta>
 <meta http-equiv="Expire" content="Mon, 04 Dec 1999 21:29:02 GMT"></meta>
 <link rel="stylesheet" href="http://wiki.tcl.tk/wikit.css" type="text/css"></link>
 <base href="http://wiki.tcl.tk/">
 </head>}

proc tdomlist x {[[dom parse $x] documentElement root] asList} ;# reference
proc lequal {a b} {
    if {[llength $a] != [llength $b]} {return 0}
    if {[lindex $a 0] == $a} {return [string equal $a $b]}
    foreach i $a j $b {if {![lequal $i $j]} {return 0}}
    return 1
}
proc try x {
    puts [set a [tdomlist $x]]
    puts [set b [xml2list $x]]
    puts list:[lequal $a $b],string:[string equal $a $b]
}
puts [set res [xml2list $my_xml]]

# REX/Perl 1.0
# Robert D. Cameron "REX: XML Shallow Parsing with Regular Expressions",
# Technical Report TR 1998-17, School of Computing Science, Simon Fraser
# University, November, 1998.
# Copyright (c) 1998, Robert D. Cameron.
# The following code may be freely used and distributed provided that
# this copyright and citation notice remains intact and that modifications
# or additions are clearly identified.
#
# 06Apr03 Brian Theado - Direct translation from Perl to Tcl

set TextSE "\[^<]+"
set UntilHyphen "\[^-]*-"
set Until2Hyphens "${UntilHyphen}(?:\[^-]$UntilHyphen)*-"
set CommentCE "${Until2Hyphens}>?"
set UntilRSBs "\[^\\]]*](?:\[^\\]]+])*]+"
set CDATA_CE "${UntilRSBs}(?:\[^\\]>]$UntilRSBs)*>"
set S "\[ \\n\\t\\r]+"
set NameStrt "\[A-Za-z_:]|\[^\\x00-\\x7F]"
set NameChar "\[A-Za-z0-9_:.-]|\[^\\x00-\\x7F]"
set Name "(?:$NameStrt)(?:$NameChar)*"
set QuoteSE "\"\[^\"]*\"|'\[^']*'"
set DT_IdentSE "$S${Name}(?:${S}(?:${Name}|$QuoteSE))*"
set MarkupDeclCE "(?:\[^\\]\"'><]+|$QuoteSE)*>"
set S1 "\[\\n\\r\\t ]"
set UntilQMs "\[^?]*\\?+"
set PI_Tail "\\?>|$S1${UntilQMs}(?:\[^>?]$UntilQMs)*>"
set DT_ItemSE  "<(?:!(?:--${Until2Hyphens}>|\[^-]$MarkupDeclCE)|\\?${Name}(?:$PI_Tail))|%$Name;|$S"
set DocTypeCE "${DT_IdentSE}(?:$S)?(?:\\\[(?:$DT_ItemSE)*](?:$S)?)?>?"
set DeclCE "--(?:$CommentCE)?|\\\[CDATA\\\[(?:$CDATA_CE)?|DOCTYPE(?:$DocTypeCE)?"
set PI_CE "${Name}(?:$PI_Tail)?"
set EndTagCE "${Name}(?:$S)?>?"
set AttValSE "\"\[^<\"]*\"|'\[^<']*'"
set ElemTagCE "${Name}(?:$S${Name}(?:$S)?=(?:$S)?(?:$AttValSE))*(?:$S)?/?>?"
set MarkupSPE "<(?:!(?:$DeclCE)?|\\?(?:$PI_CE)?|/(?:$EndTagCE)?|(?:$ElemTagCE)?)"
set XML_SPE "$TextSE|$MarkupSPE"


proc ShallowParse {xml} {
	global XML_SPE
	return [regexp -inline -all $XML_SPE $xml]
}

set my_xml {
	POST /InStock HTTP/1.1
	Host: www.example.org
	Content-Type: application/soap+xml; charset=utf-8
	Content-Length: nnn

	<?xml version="1.0"?>
	<soap:Envelope
	xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
	soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">

	<soap:Body xmlns:m="http://www.example.org/stock">
	  <m:GetStockPrice>
	    <m:StockName>ATEN</m:StockName>
	  </m:GetStockPrice>
	</soap:Body>

</soap:Envelope>
}

set found_element 0
set find_this_element "<m:StockName>"
set new_value "FFIV"

foreach item [ShallowParse $my_xml] {
	set item [string trim $item]
	if { $item == "" } { continue }
	lappend xml_list $item
}

set i 0
set found_element 0
foreach item $xml_list {
if { $found_element } {
	puts "$find_this_element = $item, replacing with $new_value"
	set xml_list [lreplace $xml_list $i $i $new_value]
	set found_element 0
}
if { $item == $find_this_element } {
	set found_element 1
}
incr i
}


set i 0
set found_element 0
foreach item $xml_list {
if { $found_element } {
	puts "$find_this_element = $item"
	set found_element 0
	exit
}
if { $item == $find_this_element } {
	set found_element 1
}
incr i
}



####	POST /InStock HTTP/1.1
####	Host: www.example.org
####	Content-Type: application/soap+xml; charset=utf-8
####	Content-Length: nnn
####		<?xml version="1.0"?>
####		<soap:Envelope
####		xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
####		soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">
####
####		<soap:Body xmlns:m="http://www.example.org/stock">
####		  <m:GetStockPrice>
####			<m:StockName>ATEN</m:StockName>
####		  </m:GetStockPrice>
####		</soap:Body>
####
####	</soap:Envelope>
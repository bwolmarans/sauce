set              biglibRev 57
if { [info exists ::SPIRENT_BL_ALL_SAUCED] } { return }
set SPIRENT_BL_ALL_SAUCED 1
if { ! [info exists bl::CORE_SOURCED] } {
###
# bl57-core.tcl
###
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#########                                                                           ##########
#########        brett.wolmarans@spirentcom.com                                     ##########
#########                                                                           ##########
#########        1. use tabsize of 4 to properly view this file                     ##########
#########                                                                           ##########
#########        2. this is made with the help of many scripters at Spirent         ##########
#########           special thanks to those who I have borred much code:            ##########
#########           Barry McGrath, Dan Acheff, Steve Larocca, Kurt Van Laar,        ##########
#########           Kurt Van Laar, and Todd Cool's ScriptCenter source code.        ##########
#########                                                                           ##########
#########        3. use namespace scope bl:: for any variables                      ##########
#########           or functions, or use bl::export <function> and then             ##########
#########           namespace import bl::<function> to use it outside of the bl     ##########
#########           namespace                                                       ##########
#########                                                                           ##########
#########        4. bl::driver will start this as an interactive command line       ##########
#########           smartbits application.                                          ##########
#########                                                                           ##########
namespace eval bl {;                                                                ##########
set              biglibRevdate "# BW 6/23/2007"
set              biglibSmartlibReq 4.00 ;#for 3321 cards, and more!
#puts "This script makes use of bl$biglibRev, $biglibRevdate, $biglibSmartlibReq"
#########                                                                           ##########
#########        Todo                                                               ##########
#########        ----
#########        # BW 2/2/2005 getlibhsp returns a list as far as HTSetStruc concerned, which is no good.
#########
#########        Change Log
#########        ----------
#########        # BW 6/23/2007 added centering to PP
#########        # BW 8/2/2005 added proc silkscreenslot
#########        # BW 4/27/2005 here's a sample usage:
#########
#########        tclsh
#########        set smartlib_file "d:/Program Files/SmartBits/SmartBits API/Bin/smartlib.tcl"
#########        namespace eval SMB { source $smartlib_file }
#########        source bl57.tcl
#########        set bl::SMARTLIB_FILE $smartlib_file
#########        set bl::VERBOSE 1
#########        set bl::USERDEBUG 1
#########        bl::version
#########        SMB::NSEnableAutoDefaults
#########        bl::link 10.6.1.213
#########        bl::group "add ports=1,2"
#########        bl::group reset
#########        bl::group clear
#########        bl::fibercopper "port=1,2 media=fiber"
#########        bl::streams "port=1 numStreams=5"
#########        bl::streams "port=2 numStreams=10"
#########        bl::enablestreamcounters "ports=1,2"
#########        bl::start "port=1,2"
#########        after 1000
#########        bl::groupstop
#########        after 1000
#########        bl::groupcounters
#########        bl::streamcounters "ports=1,2"
#########
#########        # BW 1/8/2006 added setparamsfromargvdashed
#########        # BW 4/27/2005 fixed counters, streamcounters, and debug flags
#########        # BW 2/2/2005  squashed huge bug: length was not subtracting -4 in streams proc
#########        # BW 1/6/2005  added in nslookup function
#########        # BW 12/3/2004  added in serial number of cards to inventory
#########        # BW 10/27/2004 put dots in pdms and psmc to print out macs in streams function
#########        # BW 6/29/2004 added in AT-3453 and AT-3451
#########        # BW 6/24/2004 for bl54, enhanced vfd3 in proc vfd for feli 38K source mac script with vlans
#########        # BW 3/3/2004  for bl54, added background_terametrics
#########        # BW 3/3/2004  for bl54, qputs changed proc: if $bl::AUTODEBUGFLAG { termmsg "$i\n" }
#########        # BW 2/23/2004 for bl53, changed default cap packets to 100
#########        # BW 2/23/2004 for bl53, added showcounters synonymn
#########        # BW 2/23/2004 for bl53, I found the macro2 andport loop in
#########                       streams was wrong place in bl57, different from bl51, and caused
#########                       a dmc error message.
#########        # BW 1/10/2004 12:29 PM added proc vfdl3vlan works great, even for multistream
#########        # BW 1/10/2004 12:28 PM fixed stream index for extension, because I must have broke this somewhere between version 50 and 51.
#########        # BW 1/10/2004 12:28 PM Tested vlan for UDP seems OK
#########        # BW 1/8/2004 12:38 PM Added (but not tested ) vlan to udp and tcp for streams
#########        # BW 1/7/2004 9:51 PM Changed stream index to 0 instead of 1.  3301 works ok.
#########        # BW 1/7/2004 12:52 PM Added in proc vfdl3 for vlan id ( not pri and c ) on stream
#########        # BW 11/29/2003 11:04 PM added vlan special for vfd
#########        # BW 11/29/2003 11:04 PM added udpbackground vlan.
#########        # BW 11/28/2003 1:10 AM changed getcardmodel to cached model
#########        # BW 11/28/2003 1:10 AM add in background
#########        # BW 11/28/2003 1:10 AM fixed vfd
#########        # BW 11/27/2003 10:33 AM added in capture ( thanks to mattlib )
#########        # BW 11/26/2003 11:21 PM add grouplist
#########        # BW 11/26/2003 11:21 PM fixed groupnuke, added groupdelete to group
#########        # BW 11/25/2003 9:11 PM added in cool binary functions
#########        # BW 11/25/2003 9:11 PM added tkputs
#########        # BW 11/25/2003 9:10 PM fixed get port
#########        # BW 11/21/2003 4:52 PM fixed check to decode babeltower better
#########                        2:57 PM added in set hub number
#########                        2:57 PM changed the macro to better handle hsp and group
#########        # BW 9/24/2003 3:04 PM fixed major issue with unlink - didn't unset the inventoried flag
#########        # BW 9/23/2003 3:41 PM fixed help for driver
#########        # BW 9/22/2003 7:00 PM fixed inventory - showed wrong number of ports
#########        # BW 9/22/2003 6:44 PM finally got around to fixing driver.  Cleaned up too much to mention.
#########        # BW 9/19/2003 11:38 AM added in ping and smblocator functions
#########        # BW 9/18/2003 11:17 AM made vputs the library version commands
#########        # BW 9/18/2003 11:04 AM added in inventory prints our lib version
#########        # BW 9/18/2003 10:34 AM added in fibercopper for 3325
#########        # BW 8/29/2003 3:07 PM added lan-3325 and new atm card, but only for inventory
#########        # BW 8/29/2003 12:10 PM  shortened debug flags took off "FLAG"
#########        # BW 8/29/2003 12:09 PM undid half-completed macro code for atm functions.  Added ATM-9015 and 9020.
#########        # BW 7/28/2003 2:23 PM attempted to add in smartlib ipforward commands
#########        # BW 7/24/2003 11:45 AM added in findhsp, findhub, findslot, findport
#########        # BW 7/25/2003 1:20 PM added in slot release to inventory HTSlotRelease
#########        # BW 7/23/2003 4:42 PM added in 3301, 3300, 3721, 3720 for proc stream
#########        # BW 7/7/2003 11:15 AM for bl43.tcl, add results to get results quickly
#########        # BW 7/7/2003 11:15 AM for bl43.tcl, added 0x0020 to gigAuto procedure.
#########        # BW 7/7/2003 11:48 AM  Also for bl43.tcl, set pureportindex to 1 and moved increment to bottom of loop
#########        # BW 7/3/2003 7:08 PM For bl42.tcl added readsocket function.  Also fixed quiet in proc se
#########        # BW 6/3/2003 11:17 AM for bl41.tcl, added the FC % to Gap function from Matt
#########        # BW 6/3/2003 3:51 PM found bugs in sixmac. re-wrote function
#########        # BW 2/24/2003 Changed proc telnet, proc Negotiat, and proc se to work under unix with 2007 term serv
#########        # BW 2/13/2003 3:03PM changed link and inventory so it won't inventory twice
#########        # BW 8/25/2002 9:52 PM put catch around all special puts so misc and/or core
#########                               wouldn't have to be sourced.
#########        # BW 8/16/2002 11:08 AM - moved pretty print to misc
#########        # BW 8/16/2002 11:08 AM - moved card definitions to bl36-firmware.tcl
#########        # BW 8/15/2002 3:38 PM - made into seperate files
#########        # BW 8/15/2002 2:27 PM - added in sn_telnet functions
#########        # BW 8/15/2002 2:27 PM - added in sn_fw functions
#########        # BW 7/2/2002 5:43 PM - fixed macros so you can have ports 1,2,3-5,7,8
#########
#########        # BW 7/1/2002 2:34 PM - fixed inventory when connecting to SMB-200 with double-width cards
#########                                see inventory function with this date as comment. It was to do with when
#########                                to set the bl::purePortIndex to 0. Could cause a problem with multi-chassis.
#########
#########        # BW 7/1/2002 11:17 AM NOTE: BL uses info array.  First index is pure or lib.
#########                                     So, $bl::info(lib.$libCh/$libSlot/$libPort.purePortIndex) is
#########                                     the pure port for that h/s/p.  See inventory function.
#########
#########        # BW 7/1/2002 11:03 AM -added in wn3445
#########        # BW 6/13/2002 1:42 PM  -in proc bputs, saved value of quietflag then reset it.
#########                                -changed PP to user bputs instead of qputs
#########                                -changed startfile to optionall do the version number
#########
#########        # BW 6/11/2002 12:56 PM  Added " " one space to sendexpect when waiting for expect ( to deal
#########                                 with Cisco "--more--" stuff )
#########
#########        # BW 6/10/2002 11:19 AM Added optional (Default is 23) port number to ciscopen and opentelnet
#########                                Changed name of bl to bl29.tcl
#########
#########        # BW 6/7/2002 10:18 PM  Added in the sendexpect functions and generaltelnet
#########
#########        # BW 5/31/2002 6:35 PM  Changed getL2counts to return the metrics
#########                                in the order
#########                                They were asked for. Saved as bl28.tcl
#########
#########        # BW 5/2/2002 3:49 PM   Changed the inventory so individual links work
#########        # BW 5/2/2002 2:00 PM   Fixing gig autonegotiation
#########        # BW 4/19/2002 8:48 AM  Fixed misc captilization bugs and de-underscored
#########                                using textpad regexp as follows
#########                                search expression: \(*\)_\([a-zA-Z0-9]\)
#########                                replacement      : \1\u\2
#########
#########        # BW 4/5/2002 9:45 AM  Added LAN-3301
#########                               Added "C2I function"
#########                               Added len into tcpipBackground for GX-1405 frames
#########
#########        # BW 3/21/2002 10:29 PM
#########        fixed cos parameter to proc fcStream
#########        # BW 2/18/2002 6:13 PM
#########        Changed all spaces to tabs.  Changed tabs to 4.
#########        Added macros 1 2 and 3.
#########        Organized hard coded into technology groups
#########        and removed redundant code
#########
#########        Changed puts chain to end with qputs, and addeda 3rd optional param (quiet)
#########        Added atm cards to streams command
#########        Added ss, gs, sc commands (probably useless)
#########        Added fiberchannel to streams command
#########        Added rputs, bputs,catch { eputs. catch { lputs and fputs do same thing. } }
#########        Changed wsLIBCMD to check
#########        Added fiberchannel functions from ws6.tcl
#########
#########        Added inventory that will go through a list of logical chassis
#########        ( not ip addresses ) and inventory them on a "pure" port numbering
#########        basis which is very much like the slot numbering in compatible mode
#########        but allows an unlimited (limited only by smartlib in native mode )
#########        number of ports per chassis.  Added bonus: defines counters for each
#########        element in HTGetCounters and zeroes them out.
#########
#########
#########        Added namespace bl:: to everything that was global (except for smartlib )
#########        I considered namespacing smartlib, but it seemed not worth it
#########        because the function calls are so very hard to use and so long to type
#########        as it is.  Also, the function names themselves are not able to put inside
#########        a namespace.
#########
#########        Removed speed param to streams, added MII check to find
#########        Added speed parameter to streams function
#########        Added check for h/s/p in hub for all functions
#########        modified debablerizer a bit
#########        Modified bl::check to use Dan's error debabelizer              ##########
#########        Added bl::check to all HTSet and HTGet except a few of the key atm   ##########
#########        Added LINKCMD to all link commands                     ##########
#########        Added check for $bl::ONEBASEDHSP to all bl::checks functions       ##########
#########        Added proc checkArgvForSwitches, proc reserveCard          ##########
#########        fixed proc showSmartbits                            ##########
#########        added proc showSmartlibVersion and proc linkToChassis        ##########
#########        Added proc stream, took out proc makeUdpStream ( must put back)  ##########
#########        Added proc getLibCardModel                          ##########
#########        Added procs plus and minus                           ##########
#########        Added 10 gig card, OC192 card for version 3.44                     ##########
#########                                                                           ##########
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################




######################## MACROS ########################


set macro1 "set stuff(h) -1; set stuff(s) -1; set stuff(p) -1; set stuff(port) -1; \
set stuff(ports) -1; \
bl::fillarray \$params stuff; foreach { par val } \[array get stuff\] { set \$par \$val };\
set retvalmacro 0;\
if { \$ports == -1 } { set ports \$port };\
if { \$ports == -1 && \[string first ort \$params\] == -1 && \[string first hsp \$params\] == -1 && \[llength \$params\] == 1 } { set ports \$params };\
if { \[string first \"group\" \$ports\] > -1 } { set ports -1 };\
if { \$h > -1 && \$s > -1 && \$p > -1 } {;\
  if { ! \[info exists bl::info(lib.\$h/\$s/\$p.purePortIndex)\] } {;\
    puts \"SMB port \$h/\$s/\$p not found in any chassis\";\
    return -1;\
  };\
  set ports \$bl::info(lib.\$h/\$s/\$p.purePortIndex);\
};\
if {  \[string first \"/\" \$ports\] > -1 } {;\
  set hsp \$ports;\
  set ports \"\";\
  set hsps \[split \$hsp ,\];\
  foreach hsp \$hsps {;\
    set temp \[split \$hsp /\];\
    set h \[lindex \$temp 0\];\
    set s \[lindex \$temp 1\];\
    set p \[lindex \$temp 2\];\
    if { ! \[info exists bl::info(lib.\$h/\$s/\$p.purePortIndex)\] } {;\
      puts \"SMB port \$h/\$s/\$p not found in any chassis\";\
      return -1;\
    };\
    lappend ports \$bl::info(lib.\$h/\$s/\$p.purePortIndex);\
  };\
};\
if { \$retvalmacro == -1 } { return -1 };\
if { \$ports == -1 } { set ports \[findgroup\] }; set portindex -1; set portcounter 0;\
set ports \[split \$ports ,+;\];\
if { \[llength \$ports\] == 1 } { set ports \[lindex \$ports 0 \] };\
foreach port \$ports {;\
  incr portindex; set gg \[split \$port -\];\
  if { \[llength \$gg\] > 1 } {;\
    set start \[lindex \$gg 0\];\
    set end \[lindex \$gg 1\];\
    set pports \"\";\
    for { set i \$start } { \$i <= \$end } { incr i } {;\
      set pports \"\$pports\$i,\";\
    };\
    set ports \[lreplace \$ports \$portindex \$portindex \$pports\];\
  };\
};\
set blah \[string length \$ports \];\
for { set i 0 } { \$i < \$blah } { incr i } {;\
  set x \[string index \$ports \$i\] ;\
  if { \$x == \",\" } {;\
    set ports \[string replace \$ports \$i \$i \" \"\];\
  };\
};\
set portslen \[llength \$ports\]"

set macro2 "set hh \[fixhsp \$h \$s \$p \$port\];\
    set h \[lindex \$hh 0\]; set s \[lindex \$hh 1\]; set p \[lindex \$hh 2\];\
    incr portcounter;"


#
# GLOBAL VARIABLES
# ---------------
# This section contains some Globals that are required by biglib.
set SHOW_STREAM_DETAILS 0
set TKFLAG 0
set AUTOHISTO 0
set BLGROUP ""
set QUIET 1
set NOISY 0
set PRINTABLEMETRICSLIST   { RX     TX     COLL      TRIG    RXB     CRC ALIGN OVER     UNDER     R-ppS      T-ppS      CRCpps  OVERpps      UNDERpps      COLLpps       ALpps     TRIGpps     RXBpps      }
set SMARTLIBMETRICSLIST    { RcvPkt TmtPkt Collision RcvTrig RcvByte CRC Align Oversize Undersize RcvPktRate TmtPktRate CRCRate OversizeRate UndersizeRate CollisionRate AlignRate RcvTrigRate RcvByteRate }
set ADVANCEDMETRICSLIST    { u64RxSignatureFrames.low u64TxSignatureFrames.low u64RxDataIntegrityErrors.low  }
set ADVANCEDPRINTLIST      { RX.TAG TX.TAG DIE }
set RUNLONG 0
set QUIETFLAG 0
set USERDEBUG 0
set PROCDEBUG 0
set USERDEBUGFLAG 0
set PROCDEBUGFLAG 0
set NOIPFLAG 0
set VERBOSE 1
set VERBOSEFLAG 1
set AUTODEBUGFLAG 0
set group 1
set DEBUG 0
set DEBUGFLAG 0
set LIBDEBUG 0
set LIBDEBUGFLAG 0
set STEPFLAG 0
set LOGFLAG 0
set LOGFILENAME log.txt
set REPORTFLAG 0
set ERRORFLAG 0
set ONEBASEDHSP 0
set GLOBALcatch { LPUTSLINENUMBER 0 }
set catch { LPUTSFLAG 0 }



###########################################################
# bl::check
# Outputs function name, arguments, and return value when
# function return code < 0.
###########################################################
proc check {args} {
  set iResponse [uplevel $args]
  if {$iResponse < 0 || $bl::LIBDEBUG || $bl::LIBDEBUGFLAG } {
    #puts args:$args
    set y [lindex $args 0]
    set stc [lindex $args 1]
    set rr [string first x $y]
    set x ""
#    puts rr:$rr
#    puts stc:$stc
    if { $rr == -1 && [string length $stc] > 3 } {
      set x [smartlibFunctionFinder $stc]
      #puts x:$x
    }
    bl::PP setDefaultScreenWidth 100
    bl::PP -topline
    if { $iResponse < 0 } {
      bl::PP "SMARTLIB ERROR" -underline
    }
    if { $x == "" } {
      bl::PP "Can't find function call for \"$stc\" because it is not unique."
      set args [lreplace $args 1 1 [lindex $x 0]]
    }
    if { [llength $x] == 1 } {
      bl::PP "[lindex $args 0] $x [lrange $args 2 end]"
    } else {
      bl::PP   "[lindex $args 0] (see below) [lrange $args 2 end]"
      foreach xx $x {
        bl::PP "                     $xx"
      }
    }
    if { $iResponse < 0 } {
      bl::PP "$iResponse = [errordebabler $iResponse]"
    }
    #bl::PP "Function: [lindex $args 0]"
    set args [lreplace $args 0 0]
    #bl::PP "Params  : $args "
    #bl::PP "Possibilites for $y:" -underline
#    set args [lreplace $args 0 0]
#    if { $rr == -1 } {
#      foreach item $x {
#        bl::PP "Error: $stc $item"
#      }
#    } else {
#      bl::PP "(Not possible to determine (or too many!))"
#    }
    struct_new err NSErrorEntry
    NSGetLastError err
    #bl::PP "Error code = [format 0x%X $err(uiErrorCode)]"
    bl::PP "NSGetLastError = $err(szErrorDescription._char_)"
    bl::PP -bottomline
  }
  return $iResponse
}

proc smartlibFunctionFinder { thing } {
  set thing [string trim $thing]
  set ::SMB::thing $thing
  #puts thing:$thing<--
  namespace eval ::SMB {
    set retval ""
    set vars [info vars]
    foreach var $vars {
      if { $var == "NS_COMMIT_CONFIG" } {
        #puts "vvvvvar:$var! shhhh"
      }
      if { $var == "NS_COMMIT_CONFIG" } {
        #puts tttttthing:$thing
      }
      set blah "failed"
      if { $var == "NS_HIST_ACTIVE_TEST_INFO" } {
        catch { set blah [subst $$SMB::var] } ddd
#        puts blah:$blah
#        puts ddd:$ddd
#        puts var:$var
#        puts thing:$thing
      } else {
        catch { set blah [subst $$SMB::var] } ddd
      }
      if { $thing == $blah && $var != "thing" } {
#        puts uuuuuuu:$var
        lappend retval $var
#        puts retval:$retval
      }
    }
  }
  if { $SMB::retval == "" } {
    set SMB::retval $thing
  }
  #puts retval:$SMB::retval
  return $SMB::retval
}

proc smartlibFunctionFinderold { thing } {
set poss ""
if { ! [info exists bl::SMARTLIB_FILE] } {
  puts error:$thing
  puts "set variable bl::SMARTLIB_FILE to your smartlib.tcl location to get better error messages"
  return
}
catch { set t [open $bl::SMARTLIB_FILE r] } err
if { [string first " " $err] > -1 } {
  puts err:$err
  return -1
}
foreach line [split [read $t] \n] {
  set blah [split $line]
  set y [expr [llength $blah] -1]
  set j [lindex $blah $y]
  if { [string trim $j \}\{ ]== $thing } {
#    puts "     got i!"
    set x [expr $y -1]
    lappend poss [lindex $blah $x]
  }
}
close $t
return $poss
}


############################################################################
#
# Dan Acheff's function
# De-babelizers the non-helpful smartlib error numbers
#
############################################################################
proc errordebabler { errornbr } {
set abserrornbr [expr abs($errornbr)]   ;# get absolute value
switch $abserrornbr {
0 {set ermsg "Fatal Error"}
1 {set ermsg "Unspecified Error"}
2 {set ermsg "Port Not Linked"}
3 {set ermsg "Unlink Failed"}
4 {set ermsg "Incorrect Mode"}
5 {set ermsg "Parameter Range"}
6 {set ermsg "Packet Not Available"}
7 {set ermsg "Serial Port Timeout (Trying to read streams but No streams on card?)"}
8 {set ermsg "ET1000 Out Of Sync"}
9 {set ermsg "Packet Not Found"}
10 {set ermsg "Function Abort"}
11 {set ermsg "Active Hub Not Initialized"}
12 {set ermsg "Active Hub Not Present"}
13 {set ermsg "Wrong Hub Card Type"}
14 {set ermsg "Memort Allocation Error"}
15 {set ermsg "Unsupported Interleave"}
16 {set ermsg "Port Already Linked"}
17 {set ermsg "Hub Slot Port Unavailable. (Use bl::reserve)"}
18 {set ermsg "Group Hub Slot Port Error"}
19 {set ermsg "Reentrant Error"}
20 {set ermsg "Device Not Found Error"}
21 {set ermsg "Port Relink Required"}
22 {set ermsg "Device Not Ready"}
23 {set ermsg "Group Not Homogeneous"}
24 {set ermsg "Invalid Group Command"}
25 {set ermsg "Error Smartcard Init Failed"}
26 {set ermsg "Socket Failed"}
27 {set ermsg "Socket Timeout (Are you linked to Smartbits?)"}
28 {set ermsg "Command Response Error"}
39 {set ermsg "CRC Error"}
30 {set ermsg "Invalid Link Port Type"}
31 {set ermsg "Invalid Sync Configuration"}
32 {set ermsg "High Density Controller Error"}
33 {set ermsg "HighDensity Err (wrong stream #/index,too fast/slow)"}
34 {set ermsg "Data Not Available"}
35 {set ermsg "Unsupported Platform"}
36 {set ermsg "File I/O Error"}
37 {set ermsg "Multi-User Conflict"}
98 {set ermsg "Serial Port Timeout"}
501 {set ermsg "NSCTL Parameter Type"}
502 {set ermsg "NSCTL Invalid Message Function (Wrong card type?)"}
default {set ermsg "UNKNOWN Error"}
}
return $ermsg
}


}

set bl::CORE_SOURCED 1
}



###
# bl57-argv.tcl
###

namespace eval bl {



##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
#
# ARGV FUNCTIONS
# --------------
# This section contains functions
# that do things with command line parameters
#
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################


#############################################################################
# proc checkArgvForSwitches
# --------------------------
# purpose: biglib depends on some GLOBALS.  These are always UPPER CAPS.
#          This checks the command line for certain switches, mainly to do
#          with debugging or verbose printout
#
# usage: checkArgvForSwitches $argv
#############################################################################
proc checkArgvForSwitches { argv } {
pputs "checkArgvForSwitches"
  if { [lsearch $argv "/userdebug"]   != -1 } { set bl::USERDEBUG 1 }
  if { [lsearch $argv "/superdebug"]    != -1 } { set bl::PROCDEBUG 1 }
  if { [lsearch $argv "/programmerdebug"]   != -1 } { set bl::PROCDEBUG 1 }
  if { [lsearch $argv "/noip"]    != -1 } { set bl::NOIPFLAG 1 }
  if { [lsearch $argv "/verbose"]   != -1 } { set bl::VERBOSE 1 }
  if { [lsearch $argv "/debug"]   != -1 } { set bl::USERDEBUG 1; set bl::DEBUG 1 }
  if { [lsearch $argv "/procdebug"] != -1 } { set bl::PROCDEBUG 1 }
  if { [lsearch $argv "/quiet"]   != -1 } { set bl::QUIETFLAG 1 }
  if { [lsearch $argv "/step"]    != -1 } { set bl::STEPFLAG 1 }
  if { [lsearch $argv "/log"]     != -1 } { set bl::LOGFLAG 1;  set bl::LOGFILEHANDLE [ startfile log.txt ]}
}

#############################################################################
# proc checkArgv
# --------------------------
# purpose: set see if the user puts something on the command line
# parameters:  the command line (argv) and a list of stuff to find.
# usage: checkArgv $argv "-ip -tos"
# returns:  1 if found, 0 if not
#############################################################################
proc checkArgv { argv { listofstufftofind "" } { setvals 0 } } {
pputs "checkArgv"
  set foundit ""
  if { $listofstufftofind != "" } {
  foreach thing $listofstufftofind {
    set position [lsearch $argv $thing]
    if { $position != -1 } {
      lappend foundit $thing
      set thing [string trim $thing -]
      set thing [string trim $thing /]
      set thing [string trim $thing \\]
    }
  }
  }
  if { $foundit != "" } { return 1 }
  return 0
}

proc setParamsFromArgvDashed {} {
    while { [string index [lindex $::argv 0] 0] == "-" } {
       set param [string range [lindex $::argv 0] 1 end]
       set ::argv [lrange $::argv 1 end]
       set value [string range [lindex $::argv 0] 0 end]
       set ::argv [lrange $::argv 1 end]
       set ::$param $value
    }
}

#############################################################################
# proc setParamsFromArgv
# --------------------------
# purpose: set things the user puts on the command line
# parameters:  the command line (argv)
# usage: setParamsFromArgv $argv
#        #command line: tclsh80 blah.tcl /debug one=1 two=2 /superdebug three=3
#        source biglib342.tcl
#        if { [checkArgv $argv /superdebug] } { puts "superdebug was found!" }
#        if { [checkArgv $argv /debug ] } { puts "debug was found!" }
#        setParamsFromArgv $argv
#        puts "$one $two $three"
#
# returns:  nothing
#############################################################################
proc setParamsFromArgv { argv } {
pputs "setParamsFromArgv"
  set alltheargs [split $argv]
  set value ""
  set longflag 0
  foreach arg $alltheargs {
    if { ! $longflag } {
      set param [lindex [split $arg =] 0]
      set value [lindex [split $arg =] 1]
    }
    if { $longflag } {
      if { [string range $arg end end] == "\}" } {

        set arg [string trim $arg "\}"]
        set longflag 0
      }
      set value "$value $arg"
    }
    if { [string range $arg 0 0] == "\{" } {
      set longflag 1
      set param [lindex [split $arg =] 0]
      set param [string range $param 1 end]
      set value [lindex [split $arg =] 1]
    }
    set ::$param $value
  }
}


}



###
# bl57-arp.tcl
###

namespace eval bl {


##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
#
#
#
# ARP FUNCTIONS
# -------------
#
#
#
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################



#############################################################################
# proc getArpResult
# ---------------------------------------
# purpose: get the arp result, what else?
# parameters: look and see
# returns: look and see
# notes:
#############################################################################
proc getArpResult { params } {
set ARPFAILED 0
puts "!!arp!"
pputs "getArpResult"
set stuff(numStreams) 5
set stuff(maxArpRetries 2)
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
for { set arptries 0 } { $arptries < $maxArpRetries } { incr arptries } {
puts "arp!"
bl::check HTSetCommand $SMB::L3_START_ARPS 0 0 0 "" $h $s $p
if { $numStreams < 50 && $numStreams > 10 } {
  fputs "waiting [expr $numStreams * 100 / 1000] seconds"
  after [expr $numStreams * 100]
} elseif { $numStreams > 50 } {
  lputs "waiting [expr $numStreams * 20 / 1000] seconds"
  after [expr $numStreams * 20]
} elseif { $numStreams < 20 } {
  lputs "waiting 1 second"
  after 1000
}
set cardinfo ""
set l3Counts [ getL3Counters "h=$h s=$s p=$p cardmodel=$bl::info(lib.$h.$s.$p.cardmodel)"]
set arpsSent [ lindex $l3Counts 3 ]
set arpsGot  [ lindex $l3Counts 2 ]
bl::check HTClearPort $h $s $p
if { $arpsGot == 0 } {
  return "$h/$s/$p: arp failed (sent $arpsSent)"
  set ARPFAILED 1
  break
} else {
  return "$h/$s/$p: ARP sent:$arpsSent got:$arpsGot"
}
};#endfor arptries
if { $ARPFAILED } { return "ARP failed!" }
}
}



proc grouparp { { params -1 } } { return [arpNCheck [findgroup]]; }
proc arp { params } { return [arpNCheck $params] }
proc startArps { params } { return [arpNCheck $params] }

proc arpNCheck { params } {
set ARPFAILED 0
pputs "arpNCheck"
set stuff(maxArpRetries) 1
eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    set ARPFAILED 0
    for { set arptries 0 } { $arptries < $maxArpRetries } { incr arptries } {
      bl::check HTSetCommand $SMB::L3_START_ARPS 0 0 0 "" $h $s $p
      set l3Counts [ getL3Counters "h=$h s=$s p=$p cardmodel=$bl::info(lib.$h.$s.$p.cardmodel)"]
      set arpsSent [ lindex $l3Counts 3 ]
      set arpsGot  [ lindex $l3Counts 2 ]
      #bl::check HTClearPort $h $s $p
      vputs "$h/$s/$p: ARP sent:$arpsSent got:$arpsGot"
    }
  };#endfor arptries
  if { $arpsGot == 0 } {
    vputs "$h/$s/$p: arp failed (sent $arpsSent)"
    set ARPFAILED 1
  }
if { $ARPFAILED } {  return -1 } else {   return 1 }
}

proc EXCheckArpResult { h s p {maxArpRetries 1 }} {
pputs "EXCheckArpResult"
eval $bl::macro2
set ARPFAILED 0
for { set arptries 0 } { $arptries < $maxArpRetries } { incr arptries } {
bl::check HTSetCommand $SMB::L3_START_ARPS 0 0 0 "" $h $s $p
after 500
set l3Counts [ EXReturnL3Counters $h $s $p ]
set arpsSent [ lindex $l3Counts 3 ]
set arpsGot  [ lindex $l3Counts 2 ]
bl::check HTClearPort $h $s $p
if { $arpsGot == 0 } {
return "$h/$s/$p: arp failed (sent $arpsSent)"
set ARPFAILED 1
break
} else {
return "$h/$s/$p: ARP sent:$arpsSent got:$arpsGot"
}
#};#endfor arptries
if { $ARPFAILED } {
return "ARP failed!"
}
}


}



###
# bl57-atm.tcl
###

namespace eval bl {


##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# ATM FUNCTIONS SECTION
# ---------------------
#
# Notes
# -----
# Many of the atm functions require the user to have an array in their script
# called ppsArray defined like this:
#
# ppsArray(<stream number>.rxPps)
# ppsArray(<stream number>.txPps)
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################

proc atmGetManyPvcTxRxTrigger { h s p numPvc results } {
pdputs "atmGetManyPvcTxRxTrigger"
#eval $bl::macro2
pdputs "Getting packet counts for $h/$s/$p"
upvar results res
catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
pdputs "ATM_STREAMDETAIL: [time {bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO 0 $numPvc 0 streamInfo 0 $h $s $p}]"
set maxconn 0
for {set i 0} {$i < $numPvc } {incr i} {
  set temp $streamInfo(status.$i.uiConnIndex)
  if {$maxconn < $temp && $temp < 65535 } {
    set maxconn $temp
  }
}
catch { unset vccInfo; unset triggerinfo }
struct_new vccInfo ATMVCCInfo
struct_new triggerinfo ATMConnTriggerInfo
pdputs "ATMVCCINFO: [time {bl::check HTGetStructure $SMB::ATM_VCC_INFO 0 [expr $maxconn+1] 0 vccInfo 0 $h $s $p}]"
pdputs "ATMVCCINFO: [time {bl::check HTGetStructure $SMB::ATM_VCC_INFO 0 [expr $maxconn+1] 0 vccInfo 0 $h $s $p}]"
set cardModel [getLibCardModel "h=$h s=$s p=$p"]
#puts cardmodel:$cardModel
if { $cardModel == "AT-9155" || $cardModel == "AT-9020" || $cardModel == "AT-9015" } {
  bl::check HTGetStructure $SMB::ATM_TRIGGER_INFO 0 0 0 triggerinfo 0 $h $s $p
} else {
  pdputs "ATM_CONN_TRIGGER_INFO: [time {bl::check HTGetStructure $SMB::ATM_CONN_TRIGGER_INFO 0 [expr $maxconn+1] 0  triggerinfo 0 $h $s $p}]"
}
for { set i 0 } { $i < $numPvc } { incr i } {
  set state $streamInfo(status.$i.ucStreamState)
  set cellheader $streamInfo(status.$i.ulCellHeader)
  set vpivci [atmDevpivci $cellheader]
  set vpi [lindex $vpivci 0]
  set vci [lindex $vpivci 1]
  set StreamIndex $streamInfo(status.$i.uiConnIndex)
  if { $StreamIndex < 65535 } {
    set res($h.$s.$p.$vpi.$vci.tx) $vccInfo(status.$StreamIndex.ulTxFrame)
    set res($h.$s.$p.$vpi.$vci.rx) $vccInfo(status.$StreamIndex.ulRxFrame)
    set res($h.$s.$p.$vpi.$vci.trigger) $triggerinfo(status.$StreamIndex.ulTrigger)
    pdputs "$h/$s/$p pvc:$vpi/$vci tx:$res($h.$s.$p.$vpi.$vci.tx) rx:$res($h.$s.$p.$vpi.$vci.rx) trigger:$res($h.$s.$p.$vpi.$vci.trigger)"
  }
}
}


#############################################################################
# Proc atmGetOnePvcTxRxTrigger
# --------------------------
# purpose: gets the tx,rx,trigger for all pvc's on a slot
# parameters:  - the target hub, slot, port
#              - the number of pvc's index
#              - an special results array to fill in
#                results($slot.$vpi.$vci.tx)
#           results($slot.$vpi.$vci.rx)
#           results($slot.$vpi.$vci.trigger)
#
# returns:  nothing, but fills in the results array
#############################################################################
proc atmGetOnePvcTxRxTrigger { h s p numPvc pvcToGet results } {
pdputs "atmGetOnePvcTxRxTrigger"
#eval $bl::macro2
#dputs "getting tx,rx, and trigger counts for $h/$s/$p $pvcToGet"

#proc i {j} {upvar j k; set k(1) 2; }
set vpiToGet [lindex [split $pvcToGet /] 0]
set vciToGet [lindex [split $pvcToGet /] 1]

upvar results res
catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
pdputs "ATM_STREAMDETAIL: [time {bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO 0 $numPvc 0 streamInfo 0 $h $s $p}]"
set maxconn 0
for {set i 0} {$i < $numPvc } {incr i} {
  if {$maxconn < $streamInfo(status.$i.uiConnIndex)} {
    set maxconn $streamInfo(status.$i.uiConnIndex)
  }
}

catch { unset vccInfo; unset triggerinfo }
struct_new vccInfo ATMVCCInfo
struct_new triggerinfo ATMConnTriggerInfo
pdputs "ATMVCCINFO: [time {bl::check HTGetStructure $SMB::ATM_VCC_INFO 0 [expr $maxconn+1] 0 vccInfo 0 $h $s $p}]"

set cardModel [getLibCardModel "h=$h s=$s p=$p"]
#puts cardmodel:$cardModel
if { $cardModel == "AT-9155" || $cardModel == "AT-9020" || $cardModel == "AT-9015" } {
  bl::check HTGetStructure $SMB::ATM_TRIGGER_INFO 0 0 0 triggerinfo 0 $h $s $p
} else {
  pdputs "ATM_CONN_TRIGGER_INFO: [time {bl::check HTGetStructure $SMB::ATM_CONN_TRIGGER_INFO 0 [expr $maxconn+1] 0  triggerinfo 0 $h $s $p}]"
}

for { set i 0 } { $i < $numPvc } { incr i } {
  set state $streamInfo(status.$i.ucStreamState)
  set cellheader $streamInfo(status.$i.ulCellHeader)
  set vpivci [atmDevpivci $cellheader]
  set vpi [lindex $vpivci 0]
  set vci [lindex $vpivci 1]
  if { $vpi == $vpiToGet && $vci == $vciToGet } {
    set StreamIndex $streamInfo(status.$i.uiConnIndex)
    set res($h.$s.$p.$vpi.$vci.tx) $vccInfo(status.$StreamIndex.ulTxFrame)
    set res($h.$s.$p.$vpi.$vci.rx) $vccInfo(status.$StreamIndex.ulRxFrame)
    set res($h.$s.$p.$vpi.$vci.trigger) $triggerinfo(status.$StreamIndex.ulTrigger)
    pdputs "$h/$s/$p pvc:$vpi/$vci tx:$res($h.$s.$p.$vpi.$vci.tx) rx:$res($h.$s.$p.$vpi.$vci.rx) trigger:$res($h.$s.$p.$vpi.$vci.trigger)"
  } else {
    pdputs "$vpi/$vci not matched $vpiToGet/$vciToGet"
  }
}
}


proc atmGetOnePvcTxRxTriggerOld { h s p numPvc pvcToGet results } {
pputs "atmGetOnePvcTxRxTriggerOld"
eval $bl::macro2
set vpiToGet [lindex [split $pvcToGet /] 0]
set vciToGet [lindex [split $pvcToGet /] 1]

struct_new streamInfo ATMStreamDetailedInfo
pdputs [time { bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO 0 $numPvc 0 streamInfo 0 $h $s $p }]
catch { unset vccInfo; unset triggerinfo }
struct_new vccInfo ATMVCCInfo
struct_new triggerinfo ATMConnTriggerInfo
pdputs [time {bl::check HTGetStructure $SMB::ATM_VCC_INFO $i 1 0 vccInfo 0 $h $s $p} ]
pdputs [time {bl::check HTGetStructure $SMB::ATM_CONN_TRIGGER_INFO $i 1 0 triggerinfo 0 $h $s $p} ]
set state $streamInfo(status.$i.ucStreamState)
set cellheader $streamInfo(status.$i.ulCellHeader)
set vpivci [atmDevpivci $cellheader]
set vpi [lindex $vpivci 0]
set vci [lindex $vpivci 1]
if { $vpi == $vpiToGet && $vci == $vciToGet } {
set StreamIndex $streamInfo(status.$i.uiConnIndex)
set tx $vccInfo(status.$i.ulTxFrame)
set rx $vccInfo(status.$i.ulRxFrame)
set trigger $triggerinfo(status.$i.ulTrigger)
set results($s.$vpi.$vci.tx) $tx
set results($s.$vpi.$vci.rx) $rx
set results($s.$vpi.$vci.trigger) $trigger
}
}

#############################################################################
# Proc atmGetVpivci
# --------------------------
# purpose: gets the vpi/vci numbers for a already configured stream
# parameters:  - the target hub, slot, port
#              - the pvc index ( the existing stream )
# returns:  vpi/vci
#############################################################################
proc atmGetVpivci { h s p pvc } {
pputs "atmGetVpivci"
eval $bl::macro2

catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO $pvc 1 0 streamInfo 0 $h $s $p
set cellheader $streamInfo(status.0.ulCellHeader)
#pdputs "atmGetVpivci: $h/$s/$p pvc:$pvc cellheader:[format %08x $cellheader]"
set vpivci [atmDevpivci $cellheader]
set vpi [lindex $vpivci 0]
set vci [lindex $vpivci 1]
return $vpi/$vci
}

#############################################################################
# Proc atmGetVpi
# --------------------------
# purpose: gets a vpi from a already configured stream
# parameters:  - the target hub, slot, port
#              - the pvc index ( the existing stream )
# returns:  the vpi
#############################################################################
proc atmGetVpi { h s p pvc } {
pputs "atmGetVpi"
eval $bl::macro2
catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO $pvc 1 0 streamInfo 0 $h $s $p
set cellheader $streamInfo(status.$pvc.ulCellHeader)
set vpivci [atmDevpivci $cellheader]
set vpi [lindex $vpivci 0]
set vci [lindex $vpivci 1]
return $vpi
}


#############################################################################
# Proc atmGetVci
# --------------------------
# purpose: gets a vci number from a already configured stream
# parameters:  - the target hub, slot, port
#              - the pvc index ( the existing stream )
# returns:  the vci
#############################################################################
proc atmGetVci { h s p pvc } {
pputs "atmGetVci"
eval $bl::macro2
catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO $pvc 1 0 streamInfo 0 $h $s $p
set cellheader $streamInfo(status.$pvc.ulCellHeader)
set vpivci [atmDevpivci $cellheader]
set vpi [lindex $vpivci 0]
set vci [lindex $vpivci 1]
return $vci
}

#############################################################################
# Proc atmStreamStart
# --------------------------
# purpose: start one atm stream
# parameters:  - hsp and stream info
# returns:  nothing
#############################################################################
proc atmStreamStart { h s p streamIndex numPvc } {
pputs "atmStreamStart"
eval $bl::macro2
struct_new atm ATMStreamControl
set atm(ulStreamIndex) $streamIndex
set atm(ulStreamCount) $numPvc
set atm(ucAction)      $SMB::ATM_STR_ACTION_START
udputs "Starting $numPvc pvc's on $h/$s/$p"
bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
unset atm
}


#############################################################################
# Proc atmClearAndStart
# --------------------------
# purpose: clear and start the atm ports
# parameters:  - the target hub, slot, port
# returns:  nothing
#############################################################################
proc atmClearAndStart { params } {
pputs "atmClearAndStart"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
bl::check HTClearPort $h $s $p
udputs ""
HTRun $SMB::HTRUN $h $s $p
#
#catch { unset atm }
#struct_new atm ATMStreamControl
#set atm(ulStreamIndex) 0
#set atm(ulStreamCount) $pvc(gen.$slot.numPvc)
#set atm(ucAction) $SMB::ATM_STR_ACTION_START
#for { set j 0 } { $j < $numGenSlots } { incr j } {
#set slot [lindex $genSlotList $j]
#bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $slot $p
#}
}
}

#############################################################################
# Proc atmStart
# --------------------------
# purpose: start all the streams on one atm port
# parameters:  - the target hub, slot, port
# returns:  nothing
#############################################################################
proc atmStart { params } {
pputs "atmStart"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
vputs "Starting ATM traffic on $h/$s/$p"
bl::check HTRun $SMB::HTRUN $h $s $p
#
#catch { unset atm }
#struct_new atm ATMStreamControl
#set atm(ulStreamIndex) 0
#set atm(ulStreamCount) $pvc(gen.$slot.numPvc)
#set atm(ucAction) $SMB::ATM_STR_ACTION_START
#for { set j 0 } { $j < $numGenSlots } { incr j } {
#set slot [lindex $genSlotList $j]
#bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $slot $p
#}
}
}

#############################################################################
# Proc atmStop
# --------------------------
# purpose: stop all the streams on an atm ports
#############################################################################
proc atmStop { params } {
pputs "atmStop"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
vputs "Stopping ATM traffic on $h/$s/$p"
HTRun $SMB::HTSTOP $h $s $p
#for { set j 0 } { $j < $numGenSs } { incr j } {
#set s [lindex $genSList $j]
#bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
#}
}
}

#############################################################################
# Proc atmStreamStop
# --------------------------
# purpose: stop the atm ports
#############################################################################
proc atmStreamStop { h s p streamIndex numPvc } {
pputs "atmStreamStop"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
#HTRun $SMB::HTSTOP $h $s $p
catch { unset atm }
struct_new atm ATMStreamControl
set atm(ulStreamIndex) $streamIndex
set atm(ulStreamCount) $numPvc
set atm(ucAction)      $SMB::ATMSTRACTIONSTOP
udputs "Stopping $numPvc pvc's on $h/$s/$p"
bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
unset atm
#for { set j 0 } { $j < $numGenSs } { incr j } {
#set s [lindex $genSList $j]
#bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
#}
}
}


#############################################################################
# Proc atmGetLcr
# --------------------------
# purpose: find the line cell rate
#
# parameters:  - the target hub, slot, port
#
# returns:  lcr
#############################################################################
proc atmGetLcr { params } {
pputs "atmGetLcr"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
catch { unset cardcap }
struct_new cardcap ATMCardCapabilities
bl::check HTGetStructure $SMB::ATM_CARD_CAPABILITY 0 0 0 cardcap 0 $h $s $p
set LCR $cardcap(ulLineCellRate)
unset cardcap
pdputs lcr:$LCR
return $LCR
}
}

#############################################################################
# Proc atmMakeManyBlankStream
# --------------------------
# purpose: create a "blank" stream.
#          has to be done before atmCreatAal5Frame
#          But, you must all atmCreateAal5Frame for this to do something
#
#
# parameters:  - the target hub, slot, port
#              - the vpi,vci
#              - the pvcIndex
#              - the pcr
# returns:    nothing
#############################################################################
proc atmMakeManyBlankStreams { h s p vpi vci pvcIndex qtyPvc pcr } {
pputs "atmMakeManyBlankStreams"
#eval $bl::macro2
dputs "Creating $qtyPvc blank streams on $h/$s/$p starting from $pvcIndex"
catch { unset pvcStruct }
struct_new pvcStruct ATMStream
set cellheader [atmVpivci $vpi $vci]
set pvcStruct(uiIndex) $pvcIndex
set pvcStruct(ucConnType) $SMB::ATM_PVC
set pvcStruct(ucEncapType) $SMB::STR_ENCAP_TYPE_NULL
set pvcStruct(ucGenRateClass)  $SMB::STR_RATE_CLASS_UBR
set pvcStruct(ulGenPCR) $pcr
set pvcStruct(ulCellHeader) $cellheader
udputs -nonewline "Creating blank stream $pvcStruct(uiIndex) $vpi/$vci "
udputs -nonewline " $h/$s/$p Cell Header [format "%08X" $pvcStruct(ulCellHeader)]"
udputs " - PCR $pvcStruct(ulGenPCR) cells/sec"
bl::check HTSetStructure $SMB::ATM_STREAM 0 0 0 pvcStruct 0 $h $s $p

if {$qtyPvc > 1} {
set yy [expr $qtyPvc - 1]
dputs "Copying stream 0 to $yy on  $h/$s/$p"

catch { unset StreamCopy }
struct_new StreamCopy   ATMStreamParamsCopy

set StreamCopy(uiSrcStrNum)   0
set StreamCopy(uiDstStrNum)   0
set StreamCopy(uiDstStrCount) $yy
set RtVal [HTSetStructure $SMB::ATM_STREAM_PARAMS_COPY 0 0 0 StreamCopy 0 $h $s $p]
if {$RtVal < 0} {
  puts "ATM_STREAM_PARAMS_COPY $h $s $p failed with code $RtVal"
  return [fatalerror $RtVal]
}

catch { unset StreamFill }
struct_new StreamFill ATMStreamParamsFill

set StreamFill(uiSrcStrNum)   0
set StreamFill(uiDstStrNum)   1
set StreamFill(uiDstStrCount) $yy
set StreamFill(uiParamItemID) $SMB::ATM_STR_PARAM_CELL_HEADER
set incrementcellheader [vpivci 0x00 0x01 ]
set StreamFill(ucDelta.0) [expr ($incrementcellheader >> 24) & 0xff] ;# cell header byte 1
set StreamFill(ucDelta.1) [expr ($incrementcellheader >> 16) & 0xff] ;# cell header byte 2
set StreamFill(ucDelta.2) [expr ($incrementcellheader >> 8) & 0xff]  ;# cell header byte 3
set StreamFill(ucDelta.3) [expr  $incrementcellheader & 0xff]        ;# cell header byte 4
set RtVal [HTSetStructure $SMB::ATM_STREAM_PARAMS_FILL 0 0 0 StreamFill 0 $h $s $p]
if {$RtVal < 0} {
  puts "ATM_STREAM_PARAMS_FILL $h $s $p failed with code $RtVal"
  return [fatalerror $RtVal]
  unset pvcStruct
}
}
}

#############################################################################
# Proc atmClock
# --------------------------
# purpose: set the clock to "loop" or "internal"
#
# parameters:  - the target hub, slot, port
#              - "loop" or "internal"
#
# returns:    nothing
#############################################################################
proc atmClock { h s p clock } {
pputs "atmClock"
eval $bl::macro2

struct_new myATMLineParams ATMLineParams
if { $clock == "loop" } {
set myATMLineParams(ucTXClockSource) $SMB::ATM_LOOP_TIMED_CLOCK
} elseif { $clock == "internal" } {
set myATMLineParams(ucTXClockSource) $SMB::ATM_INTERNAL_CLOCK
}
bl::check HTSetStructure $SMB::ATMLINE 0 0 0 myATMLineParams 0 0 $s 0
unset myATMLineParams
}


#############################################################################
# Proc atmCheckConnections
# --------------------------
# purpose: connect pvcs
#
# parameters:  - the target hub, slot, port
#              - the quantity of pvcs desired
#
# returns:     - the number of successfully connected pvcs
#              - side effects are prints out a bunch of stuff
#############################################################################
proc atmCheckConnections { h s p numPvcDesired { quiet 0 } } {
pputs "atmCheckConnections"
eval $bl::macro2

set numPvcSuccess 0

catch { unset streamInfo }
struct_new streamInfo ATMStreamDetailedInfo
bl::check HTGetStructure $SMB::ATM_STREAM_DETAIL_INFO 0 $numPvcDesired 0 streamInfo 0 $h $s $p
set ctlbrk 0
for { set i 0 } { $i < $numPvcDesired } { incr i } {
set state $streamInfo(status.$i.ucStreamState)
set cellheader $streamInfo(status.$i.ulCellHeader)
set vpivci [atmDevpivci $cellheader]
set vpi [lindex $vpivci 0]
set vci [lindex $vpivci 1]
if {$state == $SMB::ATM_STR_STATE_CONN_ESTABLISHED || $state == $SMB::ATM_STR_STATE_IDLE} {
if { ! $quiet } {
if { !$ctlbrk } {
      udputs ""; udputs -nonewline "0/$s/$p "; set ctlbrk 1;
} else {  udputs -nonewline "       " }
  udputs -nonewline  "pvc: $vpi/$vci---->"
  udputs -nonewline \
"[format %08x $streamInfo(status.$i.ulCellHeader)] $streamInfo(status.$i.uiConnIndex)"
flush stdout
udputs " OK"; flush stdout
};#endif ! quiet mode

incr numPvcSuccess
} else {
puts "ERROR:stream $i failed to connect";
}
}
return $numPvcSuccess
}



#############################################################################
# Proc atmConnectPvcs
# -----------------------
# purpose: connect pvcs
#
# parameters:  - the target hub, slot, port
#              - the quantity of pvcs
#
# returns: nothing
#############################################################################
proc atmConnectPvcs { h s p pvcIndex numPvc } {
pputs "atmConnectPvcs"
#eval $bl::macro2

dputs "Connecting $numPvc pvc's on $h/$s/$p starting from $pvcIndex pvc."
struct_new atmm ATMStreamControl
set atmm(ulStreamIndex) $pvcIndex
set atmm(ulStreamCount) [expr $numPvc -1]
set atmm(ucAction)      $SMB::ATM_STR_ACTION_CONNECT
bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atmm 0 $h $s $p
unset atmm
}

#############################################################################
# Proc atmPerStreamBurst
# -----------------------
# purpose: set the burst PER STREAM
#
# parameters:  - the target hub, slot, port
#              - pvc index ( where this stream is )
#              - the quantity of packets
#
# returns: nothing, but sets the atm frame
#############################################################################
proc atmPerStreamBurst { h s p pvcIndex qtyPvc burst } {
pputs "atmPerStreamBurst"
#eval $bl::macro2

catch { unset burststruct }
struct_new burststruct ATMPerConnBurstCount
set burststruct(uiStartConnIdx) $pvcIndex
set burststruct(uiConnCount) $qtyPvc
set burststruct(ucFunction) $SMB::ATM_BURST_ENABLE
set burststruct(ulFrameBurstSize) $burst
bl::check HTSetStructure $SMB::ATM_PER_STREAM_BURST 0 0 0 burststruct 0 $h $s $p
unset burststruct
}


#############################################################################
# Proc atmGlobalTriggerForAal5
# -----------------------
# purpose: set a global trigger for the whole slot, for mux, clip. not snap.
#
# parameters:  - the target hub, slot, port
#              - optional pattern ( 0x55555555 = default )
#
# returns: nothing, but sets the atm frame
#############################################################################
proc atmGlobalTriggerForAal5 { h s p { pattern 0x55555555 } } {
pputs "atmGlobalTriggerForAal5"
#eval $bl::macro2
dputs "Setting trigger $pattern on ATM card $h/$s/$p"
set cardModel [getLibCardModel "h=$h s=$s p=$p"]
if { $cardModel == "AT-9155" || $cardModel == "AT-9020" || $cardModel == "AT-9015" } {
 struct_new trig          ATMTrigger
 set trig(ucEnable)           1
 set trig(ucMode)             $SMB::ATM_TRIGGER_MODE_AAL5
 set trig(ucDirection)        $SMB::ATM_TRIGGER_DIR_RX
 set trig(ucCompCombo)        $SMB::ATM_COMP1_ONLY
 set trig(ucHeaderNoMatch)    0
 set trig(ucComp1NoMatch)     0
 set trig(ucComp2NoMatch)     0
 set trig(ulHeaderPattern)    0
 set trig(ulHeaderMask)       0 ;# ignore all header bits
 set trigoffset 36
 set trig(uiComp1Offset)      $trigoffset
 set trig(uiComp1Range)       6
 set trig(ucComp1Pattern)     { 0x00 0x00 0x4e 0x45 0x54 0x43 }
 set pattern { 0x55 0x55 0x55 0x55 0x55 0x55 }
 #set trig(ucComp1Pattern)     $pattern
 set trig(ucComp1Mask)        { 0xff 0xff 0xff 0xff 0xff 0xff }
 set RtVal [HTSetStructure $SMB::ATM_TRIGGER 0 0 0 trig 0 $h $s $p]
 if {$RtVal < 0} {
    putrep "ATM_TRIGGER $hub $slot $port failed with code $RtVal"
    return [showerror $RtVal]
 }
} else {
struct_new atmtrigger ATMGlobalTrigger
set atmtrigger(ucEnable) 0x01
set atmtrigger(ucCompCombo) 0x01
set atmtrigger(uiComp2Offset) 0x40
#set atmtrigger(ulComp2Pattern) 0x0A000001
set atmtrigger(ulComp2Pattern)  $pattern
bl::check HTSetStructure $SMB::ATM_GLOBAL_TRIGGER_PARAMS 0 0 0 atmtrigger 0 $h $s $p
unset atmtrigger
}
}


###########################################################################################################################################################################################
# Brett-Documenation
#
# proc vpivci
# --------------
# purpose: create a cell header using vpi/vci
# paramaters: the desired vpi/vci
# returns: the cellheader
# usage: vpivci 0 9
#############################################################################################
proc vpivci { vpi vci } {
pputs "vpivci"
set vpi [expr $vpi * 0x00100000]
set vci [expr $vci * 0x00000010]
set cellheader [expr $vpi + $vci]
dputs "The Cell Header is [format %08X $cellheader]"
return $cellheader
}


#############################################################################
# Proc atmMakeAal5Frame
# -----------------------
# purpose: create an AAL5 CLIP, SNAP, or MUX frame, including checksum
# note: have to MAKE the atm stream first!
#
# parameters: - the target hub, slot, port
#             - length
#             - encoding type ( clip, snap, mux )
#             - source, dest ip's
#             - source, dest MAC's
#             - pvc index ( where you want this stream created )
#
#
#
# returns: offset, and sets the atm frame
#############################################################################
proc atmMakeAal5Frame { h slot p len enc sip dip smc dmc pvcIndex } {
pputs "atmMakeAal5Frame"
set s $slot
set sip [join $sip .]
set dip [join $dip .]
set smc [join $smc .]
set dmc [join $dmc .]

#eval $bl::macro2

dputs "Making AAL5 frame on $h/$slot/$p sip:$sip dip:$dip smc:$smc dmc:$dmc enc:$enc len:$len"

struct_new atmFrame ATMFrameDefinition
set atmFrame(uiStreamIndex) $pvcIndex
set atmFrame(ulFrameFlags) 00
set offset 8

set hexSip [split [hexit $sip] .]
set hexDip [split [hexit $dip] .]

switch $enc {
"clip" { ;# LLC/SNAP Routed 1483
set offset 8
set atmFrame(ucFrameData.0) 0xAA           ;# DSAP
set atmFrame(ucFrameData.1) 0xAA           ;# SSAP
set atmFrame(ucFrameData.2) 0x03           ;# Ctrl
set atmFrame(ucFrameData.3) 0x00           ;# OUI
set atmFrame(ucFrameData.4) 0x00           ;# OUI
set atmFrame(ucFrameData.5) 0x00           ;# OUI
set atmFrame(ucFrameData.6) 0x08           ;# PID
set atmFrame(ucFrameData.7) 0x00           ;# PID
}
"snap" { ;# LLC/SNAP Bridged 1483
set offset 24
set atmFrame(ucFrameData.0) 0xAA           ;# DSAP
set atmFrame(ucFrameData.1) 0xAA           ;# SSAP
set atmFrame(ucFrameData.2) 0x03           ;# Ctrl
set atmFrame(ucFrameData.3) 0x00           ;# OUI
set atmFrame(ucFrameData.4) 0x80           ;# OUI
set atmFrame(ucFrameData.5) 0xC2           ;# OUI
set atmFrame(ucFrameData.6) 0x00           ;# PID
set atmFrame(ucFrameData.7) 0x07           ;# PID
set atmFrame(ucFrameData.8) 0x00           ;# Pad
set atmFrame(ucFrameData.9) 0x00           ;# Pad

if {[llength $dmc] < 6 } {set dmcSplit [split $dmc .] }
if {[llength $smc] < 6 } {set smcSplit [split $smc .] }
for {set i 0} {$i < 6} {incr i} {
  set atmFrame(ucFrameData.[expr 10+$i]) [lindex $dmcSplit $i]
  set atmFrame(ucFrameData.[expr 16+$i]) [lindex $smcSplit $i]
}

set atmFrame(ucFrameData.22) 0x08      ;# Type
set atmFrame(ucFrameData.23) 0x00      ;# Type
}
"mux" { ;# Null encapsulated Routed 1483
set offset 0
}
} ;# end switch

set atmFrame(uiFrameLength) [expr ($len + $offset)]
set atmFrame(uiDataLength)  [expr ([expr (20 + $offset)] + 4)]      ;# +4 for Netcom signature field

# IP portion of frame
set atmFrame(ucFrameData.[expr $offset+0]) 0x45        ;# ver/len
set atmFrame(ucFrameData.[expr $offset+1]) 0x00        ;# ToS
set atmFrame(ucFrameData.[expr $offset+4]) 0x00        ;# ID
set atmFrame(ucFrameData.[expr $offset+5]) 0x00        ;# ID
set atmFrame(ucFrameData.[expr $offset+6]) 0x00        ;# flags/frag
set atmFrame(ucFrameData.[expr $offset+7]) 0x00        ;# frag
set atmFrame(ucFrameData.[expr $offset+8]) 0x40        ;# TTL
set atmFrame(ucFrameData.[expr $offset+9]) 0x04        ;# prot

# Set tot field
set b $len
set a [expr $b % 256]
set  atmFrame(ucFrameData.[expr $offset + 3]) $a
set b [expr $b >> 8]
set a [expr $b % 256]
set atmFrame(ucFrameData.[expr $offset + 2]) $a

#Source IP
for {set temp 0} {$temp < 4} {incr temp} {
  set atmFrame(ucFrameData.[expr [expr $offset+12] + $temp]) [lindex $hexSip $temp]
}

#Destination IP
for {set temp 0} {$temp < 4} {incr temp} {
  set atmFrame(ucFrameData.[expr [expr $offset+16] + $temp]) [lindex $hexDip $temp]
}


#Initialize the 2 byte Checksum to 0
set atmFrame(ucFrameData.[expr $offset+10]) 0x00
set atmFrame(ucFrameData.[expr $offset+11]) 0x00
# insert NETCOM tag for triggering on the receive side
set atmFrame(ucFrameData.36)     0x4e   ;# N  "tag" byte 1
set atmFrame(ucFrameData.37)     0x45   ;# E  "tag" byte 2
set atmFrame(ucFrameData.38)     0x54   ;# T  "tag" byte 3
set atmFrame(ucFrameData.39)     0x43   ;# C  "tag" byte 4
set atmFrame(ucFrameData.40)     0x4f   ;# O  "tag" byte 3
set atmFrame(ucFrameData.41)     0x4d   ;# M  "tag" byte 4

# Fill rest of frame with 5555 This is what to TRIGGER ON
set atmFrame(uiFrameFillPattern) 0x5555

calcChecksum atmFrame $offset [expr $offset + 19] [expr $offset + 10]
bl::check HTSetStructure $SMB::ATM_FRAME_DEF 0 0 0 atmFrame 0 $h $slot $p


pdputs -nonewline "0/$slot/0: sip:"
#Source IP
for {set temp 0} {$temp < 4} {incr temp} {
  pdputs -nonewline "[format %02d $atmFrame(ucFrameData.[expr $offset+12+$temp])]."
}


set yy $atmFrame(ucFrameData.[expr $offset + 10]); set pp $atmFrame(ucFrameData.[expr $offset + 11])

pdputs -nonewline " dip:"
#Destination IP
for {set temp 0} {$temp < 4} {incr temp} {
  pdputs -nonewline "[format %02d $atmFrame(ucFrameData.[expr $offset+16+$temp])]."
}

pdputs " chk:[format %02x $yy][format %02x $pp] enc:$enc"; flush stdout
return $offset
}


proc atmResetCard { params } {
pputs "atmResetCard"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
dputs "Resetting ATM card and disconnecting all streams on $h/$s/$p"
bl::check HTClearPort $h $s $p
bl::check HTResetPort $SMB::RESET_FULL $h $s $p
catch { unset cardcap }
struct_new cardcap ATMCardCapabilities
bl::check HTGetStructure $SMB::ATM_CARD_CAPABILITY 0 0 0 cardcap 0 $h $s $p
set MAXSTREAMS $cardcap(uiMaxStream)
unset cardcap
catch { unset atm }
struct_new atm ATMStreamControl
set atm(ulStreamIndex)  0
set atm(ulStreamCount)  $MAXSTREAMS
set atm(ucAction)       $SMB::ATMSTRACTIONDISCONNECT
bl::check HTSetStructure $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
set atm(ucAction)       $SMB::ATM_STR_ACTION_RESET
set atm(ulStreamIndex)  0
set atm(ulStreamCount)  $MAXSTREAMS
bl::check HTSetStructure   $SMB::ATM_STREAM_CONTROL 0 0 0 atm 0 $h $s $p
unset atm
}
}


proc atmSetLine { params } {
pputs "atmResetCard"
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set cardModel [getLibCardModel "h=$h s=$s p=$p"]
  if { $cardModel == "AT-9015" || $cardModel == "AT-9020" } {
    struct_new line ATMDS1E1LineParams
    set line(ucFramingMode)    $SMB::ATM_E1_CELL_FRAMING
    set line(ucTxClockSource)  $SMB::ATM_INTERNAL_CLOCK
    set line(ucCellScrambling) 0
    set line(ucHecCoset)       0
    set line(ucRxErroredCells) $SMB::ATM_DROP_ERRORED_CELLS
    set line(ucLoopbackEnable) $SMB::ATM_LOOPBACK_DISABLED
    set line(ucLineBuildout)   $SMB::ATM_DS1_0_TO_133_BUILDOUT
    bl::check HTSetStructure   $SMB::ATM_DS1_E1_LINE_PARAM 0 0 0 line 0 $h $s $p
    unset line
  }
}
}

proc atmResetPort { params } { atmResetCard $params }

#############################################################################
# Proc atmConvertTxRate
# ------------------
# purpose: Converts tx rate into PCR
# parameters: TxRate     ( any valid integer,considering the UnitTxRate )
#             UnitTxRate ( "CellPerSec", "Percent", "pps" )
#             EncapType  ( "clip", "snapr", "snap", "mux" )
#             FrameSize  ( any valid frame size )
#             LCR        ( Line Cell Rate of this card )
# returns: transmit rate in cells per second
#############################################################################
proc atmConvertTxRate {quantity units encaptype framesize lcr} {
pputs "atmConvertTxRate"
set b 0
switch $units {
"cellpersec" { set b $quantity }
"percent" {
  set a [expr $quantity * $lcr]
  set b [expr $a / 100 ]
  }
"pps" {
  switch [string tolower $encaptype] {
    "vcMultiplexedPpp" { set overhead 2 }
    "llcPpp" { set overhead 6 }
    "vcMultiplexedPppoe" { set overhead 24 }
    "llcPppoe" { set overhead 32 }
    "clip" -
    "snapr" { set overhead 8 }
    "snap"  { set overhead 24 }
    "mux"   { set overhead 0 }
  }
  set totalFramesize [expr $framesize + $overhead + 8]
  pdputs tof:$totalFramesize
  set cellsperframe  [expr ($totalFramesize / 48) + 1]
  pdputs cpf:$cellsperframe
  pdputs qty:$quantity
  #set cellsperframe  [expr ([expr ([expr ([expr ($framesize + $overhead + 8)] - 1)] / 48.0) ]+)]
  set b [expr $cellsperframe * $quantity]
  pdputs b:$b
  }
}
if {$b > $lcr } {
  udputs "user has requested a pcr of $b, which is greater than line rate of $lcr"
  udputs "setting the pcr to line rate."
  set b $lcr
}
return [expr round($b)]
}



###############################################################################
#
# proc atmGetStreamRangeRxPpsCustom
# ---------------------
# Must be run with custom.so by Matt Jefferson.
# This is a custom .so for Solaris 2.6 that does a speeded-up version
# of getATMRXCountInfo.
#
# Purpose: to fill in the ppsArray with the rxPps per stream QUICKLY
#
###############################################################################
proc atmGetStreamRangeRxPpsCustom { h s p atmPpsArray { streamIndex 0 }  {numStreams 1 } } {
pputs "atmGetStreamRangeRxPpsCustom"
  upvar $atmPpsArray localPpsArray
  set converter 10000000.0
  struct_new pvcResults ATMExtVCCInfo
  set address [structInfo object pvcResults addr]
  if { [getATMRXCountInfo $streamIndex $numStreams $address $h $s] < 0 } {
    puts "fatal error in getATMRXCountInfo"; exit
  }

  for {set i 0} {$i < $numStreams} {incr i} {
  set startRxPkt($i) $pvcResults(status.$i.ulRxTriggerCt)
  set startTime($i)   $pvcResults(status.$i.ulTimeStamp)
  }

  unset pvcResults
  struct_new pvcResults ATMExtVCCInfo
  set address [structInfo object pvcResults addr]

  if { [getATMRXCountInfo $streamIndex $numStreams $address $h $s] < 0 } {
    puts "getATMRXCountInfo failed. exitting."; exit
  }


  for {set i 0} {$i < $numStreams} {incr i} {
  set stopRxPkt($i)  $pvcResults(status.$i.ulRxTriggerCt)
  set stopTime($i)    $pvcResults(status.$i.ulTimeStamp)
  set deltaRxPkt($i) [expr $stopRxPkt($i)- $startRxPkt($i)]
  set deltaTime($i)   [expr $stopTime($i) - $startTime($i) ]
  set deltaTime($i)   [expr $deltaTime($i) / $converter]
  set rxPps($i)       [expr round($deltaRxPkt($i)  / $deltaTime($i)) ]
  set localPpsArray($i.rxPps) $rxPps($i)
  }
  unset pvcResults
}

###############################################################################
#
# proc atmGetStreamRangeRxPps
# ---------------------
# Purpose: to fill in the ppsArray with the rxPps per stream
#
###############################################################################
proc atmGetStreamRangeRxPps  { h s p atmPpsArray { streamIndex 0 }  {numStreams 1 } } {
pputs "atmGetStreamRangeRxPps"
eval $bl::macro2

  upvar $atmPpsArray localPpsArray
  set converter 10000000.0

  struct_new pvcResults ATMExtVCCInfo
  if { [HTGetStructure $SMB::ATM_STREAM_EXT_VCC_INFO $streamIndex $numStreams 0 pvcResults 0 $h $s $p] < 0 } {
    puts "ATM_STREAM_EXT_VCC_INFO failed. exitting"; exit
  }
  for {set i 0} {$i < $numStreams} {incr i} {
  set startRxPkt($i) $pvcResults(status.$i.ulRxTriggerCt)
  set startTime($i)   $pvcResults(status.$i.ulTimeStamp)
  }

  unset pvcResults
  struct_new pvcResults ATMExtVCCInfo
  if { [HTGetStructure $SMB::ATM_STREAM_EXT_VCC_INFO $streamIndex $numStreams 0 pvcResults 0 $h $s $p] < 0 } {
    puts "ATM_STREAM_EXT_VCC_INFO failed. exitting"; exit
  }

  for {set i 0} {$i < $numStreams} {incr i} {
  set stopRxPkt($i)  $pvcResults(status.$i.ulRxTriggerCt)
  set stopTime($i)    $pvcResults(status.$i.ulTimeStamp)
  set deltaRxPkt($i) [expr $stopRxPkt($i)- $startRxPkt($i)]
  set deltaTime($i)   [expr $stopTime($i) - $startTime($i) ]
  set deltaTime($i)   [expr $deltaTime($i) / $converter]
  set rxPps($i)       [expr round($deltaRxPkt($i)  / $deltaTime($i)) ]
  set localPpsArray($i.rxPps) $rxPps($i)
  }
  unset pvcResults
}

proc atmGetTxPps { params } {
pputs "atmGetTxPps"

eval $bl::macro1
eval $bl::macro2

  struct_new AAL5Info ATMAAL5LayerInfo
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set startTime $AAL5Info(ulTimeStamp)
  set startTxPkt $AAL5Info(ulTxFrame)
  after 500
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set stopTime $AAL5Info(ulTimeStamp)
  set stopTxPkt $AAL5Info(ulTxFrame)
  set deltaTxPkt [expr ( $stopTxPkt / 1.0 )- ( $startTxPkt / 1.0 ) ]
  set converter 10000000.0
  set converter 10004000.0
  set deltaTime   [expr ( $stopTime / $converter )  - ( $startTime / $converter) ]
  set txPps [expr $deltaTxPkt / $deltaTime ]
  unset AAL5Info
  set blah [expr round($txPps) + 0]
  return $blah
}


###############################################################################
#
# proc atmGetRxPps
# ---------------------
# Purpose: return rx pps for one whole atm port
#
###############################################################################
proc atmGetRxPps { params } {
pputs "atmGetRxPps"

eval $bl::macro1
eval $bl::macro2
  struct_new AAL5Info ATMAAL5LayerInfo
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set startTime $AAL5Info(ulTimeStamp)
  set startRxPkt $AAL5Info(ulRxFrame)
  after 500
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set stopTime $AAL5Info(ulTimeStamp)
  set stopRxPkt $AAL5Info(ulRxFrame)
  set deltaRxPkt [expr ( $stopRxPkt / 1.0 )- ( $startRxPkt / 1.0 ) ]
  set converter 10000000.0
  set converter 10004000.0
  set deltaTime [expr ( $stopTime / $converter )  - ( $startTime / $converter) ]
  set rxPps [expr $deltaRxPkt / $deltaTime ]
  unset AAL5Info
  set blah [expr round($rxPps) + 0]
  return $blah
}




###############################################################################
#
# proc atmGetRxPpsold
# ---------------------
# Purpose: return rx pps for one whole atm port
#
###############################################################################
proc atmGetRxPpsold { params } {
pputs "atmGetRxPps"

eval $bl::macro1
eval $bl::macro2

  struct_new AAL5Info ATMAAL5LayerInfo
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set startTime $AAL5Info(ulTimeStamp)
  set startRxPkt $AAL5Info(ulRxFrame)
  after 500
  bl::check HTGetStructure $SMB::ATM_AAL5_INFO 0 0 0 AAL5Info 0 $h $s $p
  set stopTime $AAL5Info(ulTimeStamp)
  set stopRxPkt $AAL5Info(ulRxFrame)
  set deltaRxPkt [expr $stopRxPkt - $startRxPkt]
  set converter 10000000.0
  set converter 10004000.0
  set deltaTime [expr ( $stopTime / $converter )  - ( $startTime / $converter) ]
  set rxPps [expr $deltaRxPkt / $deltaTime ]
  unset AAL5Info
  return [expr round($rxPps) + 0]
}




###################################################################
# proc atmVpivci
# --------------
# purpose: create a cell header using vpi/vci
# paramaters: the desired vpi/vci
# returns: the cellheader
# usage: vpivci 0 9
#
####################################################################
proc atmVpivci { vpi vci } {
pputs "atmVpivci"
set vpi [expr $vpi * 0x00100000]
set vci [expr $vci * 0x00000010]
set cellheader [expr $vpi + $vci]
#pdputs "The Cell Header is [format %08X $cellheader]"
return $cellheader
}

###################################################################
# proc atmDevpivci
# --------------
# purpose: to find the vpi and vci out of the cell header
# paramaters: the cellheader
# returns: a list, first element is vpi, second is vpi
#
####################################################################
proc atmDevpivci { cellheader } {
pputs "atmDevpivci"
set vpi [expr $cellheader / 0x00100000]
set temp [expr $vpi * 0x00100000]
set cellheader [expr $cellheader - $temp ]
set vci [expr $cellheader / 0x00000010]
lappend retval $vpi
lappend retval $vci
return $retval
}



}



###
# bl57-backplane.tcl
###

namespace eval bl {


###########
# BACKPLANE FUNCTIONS
###########
#!/home/bwolmarans/ats3.5.0/bin/tclsh

proc IPForwardUnLink { h s  } {
  bl::check HTIpForwardUnLink $h $s
}

proc IPForwardLink { h s sip gtw msk } {
  struct_new ipf IPForwardConfig
  set cardip [split $sip . ]
  for { set i 0 } { $i < 4 } { incr i } {
    set ipf(ucIPAddress.$i) [lindex $cardip $i]
  }
  set smbmsk [split $msk . ]
  for { set i 0 } { $i < 4 } { incr i } {
    set ipf(ucNetmask.$i) [lindex $smbmsk $i]
  }
  set smbgtw [split $gtw . ]
  for { set i 0 } { $i < 4 } { incr i } {
    set ipf(ucGateway.$i) [lindex $smbgtw $i]
  }
  bl::check HTIPForwardLink ipf $h $s
}



proc oldIPForwardUnLink {H S} {

 #Config IP Forwarding on Controller
 struct_new IPFW_CONFIG UChar*1024
 struct_new IPFW_DATA UChar*1024

 set IPFW_CONFIG(0) 1
 set IPFW_CONFIG(29) $S
 set IPFW_CONFIG(31) 1
 set IPFW_CONFIG(38) 1
 #done with setting up IPFW_DATA
 set iRsp [SMBFunction 0x8824 0x02 $H $S 0 IPFW_CONFIG 40 "" 0]

}



proc oldIPForwardLink {H S IP GW NM} {
set IP [split $IP .]
set GW [split $GW .]
set NM [split $NM .]

vputs "Setting ip fowarding on $H/$S/* sip=$IP gtw=$GW msk=$NM"
struct_new recv UChar*1024

IPForwardUnLink $H $S
set iRsp [SMBFunction 0x8005 0x02 $H $S 0 "" 0 recv 1024]
if {$iRsp < 0} {
 unset recv
 return -1
}
 #store mac address
 for {set i 0} {$i < 6} {incr i} {
  set mac($i) $recv([expr 14+$i])
 }

 #Config IP Forwarding on Controller
 struct_new IPFW_CONFIG UChar*1024
 struct_new IPFW_DATA UChar*1024


 #set new mac ( start from 1 , not 0 )
 # BW 7/23/2003 5:05 PM
 set mac(5) [expr $mac(5) +1]
 for {set i 0} {$i < 6} {incr i} {
  set IPFW_DATA($i) $mac($i)
 }

 for {set i 0} {$i < 4} {incr i} {
  set index [expr $i+8]
  set IPFW_DATA($index) [lindex $IP $i]
 }
 for {set i 0} {$i < 4} {incr i} {
  set index [expr $i+12]
  set IPFW_DATA($index) [lindex $NM $i]
 }
 for {set i 0} {$i < 4} {incr i} {
  set index [expr $i+16]
  set IPFW_DATA($index) [lindex $GW $i]
 }
 set IPFW_DATA(25) $S
 set IPFW_DATA(27) 1
 set IPFW_DATA(34) 1
 #done with setting up IPFW_DATA

 #Combine IPFW_CONFIG and IPFW_DATA
 set IPFW_CONFIG(0) 1
 for {set i 0} {$i < 36} {incr i} {
  set index [expr $i+4]
  set IPFW_CONFIG($index.uc) $IPFW_DATA($i)
 }
 SMBFunction 0x8824 0x02 $H $S 0 IPFW_CONFIG 40 "" 0
 SMBFunction 0x6020 0x01 $H $S 0 IPFW_DATA 36 "" 0
 return 0
}


#set smartlibpath /home/bwolmarans/smartbits/smartlib/include/smartlib.tcl
#puts "Sourcing smartlibrary from $smartlibpath"
#source $smartlibpath
#set smbip 10.6.1.38
#puts "Linking to chassis on $smbip"
#NSSocketLink $smbip 16385 $::RESERVE_ALL
#IPForwardLink 0 0 "10 6 1 39" "10 6 1 1" "255 255 255 0"
#IPForwardLink 0 1 "10 6 1 40" "10 6 1 1" "255 255 255 0"
#puts "PRESS ENTER"; gets stdin in
#puts "\nScript $argv0 is done!"
#

}



###
# bl57-checksum.tcl
###

namespace eval bl {



##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# CHECKSUM FUNCTIONS
# ----------------
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################

###################################################################
# proc calcChecksum
# -------------------
# Note: Dan Acheff's function
#
# purpose: to make an IP checksum and put it into the frame
# paramaters: the frame, start, and end of frame and offset
# returns: nothing, but modifies the frame
# usage: calcChecksum atmFrame $offset [expr $offset + 19] [expr $offset + 10]
#
####################################################################
proc calcChecksum {frame start end offset} {
pputs "calcChecksum"
# calculate an IP checksum for the IP header from frame(ucFrameData.$start) to
# frame(ucFrameData.$end) and put the checksum value in frame(ucFrameData.$offset)
upvar $frame fd
#puts "Here is named $frame"
#puts "-----------"
#parray fd

set sum 0
for {set k $start; set j [expr $start + 1]} {$k < $end} {incr k 2; incr j 2} {
set nextShort [expr  (($fd(ucFrameData.$k) << 8) & 0xff00) | \
($fd(ucFrameData.$j) & 0xff)]
set sum [expr $sum + $nextShort]
}
set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry
set sum [expr ($sum & 0xffff) + $carry] ;# add back carry to 16 but value
set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry again
set sum [expr $sum + $carry]            ;# add back carry again
set sum [expr ~ $sum]                   ;# invert
set fd(ucFrameData.$offset) [expr ($sum >> 8) & 0xff]     ;# high order byte
set fd(ucFrameData.[expr $offset + 1]) [expr $sum & 0xff] ;# low order byte
#pdputs [format "debug: checksum is %04x" [expr $sum & 0xffff]]
}

proc calcChecksum2 {frame start end offset} {
  pputs "calcChecksum2"
  upvar $frame framedata
  set sum 0
  for {set k $start; set j [expr $start + 1]} {$k < $end} {incr k 2; incr j 2} {
    set nextShort [expr  (($framedata($k) << 8) & 0xff00) | ($framedata($j) & 0xff)]
    set sum [expr $sum + $nextShort]
  }
  set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry
  set sum [expr ($sum & 0xffff) + $carry] ;# add back carry to 16 but value
  set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry again
  set sum [expr $sum + $carry]            ;# add back carry again
  set sum [expr ~ $sum]                   ;# invert
  set framedata($offset) [expr ($sum >> 8) & 0xff]     ;# high order byte
  set framedata([expr $offset + 1]) [expr $sum & 0xff] ;# low order byte
  #pdputs [format "debug: checksum is %04x" [expr $sum & 0xffff]]
}

proc calcTCPChecksum { tcpdata } {
set sum 0
set start 0
set end [llength $tcpdata]
for {set k $start; set j [expr $start + 1]} {$k < $end} {incr k 2; incr j 2} {
set nextShort [expr  (([lindex $tcpdata $k] << 8) & 0xff00) | \
([lindex $tcpdata $j] & 0xff)]
set sum [expr $sum + $nextShort]
}
set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry
set sum [expr ($sum & 0xffff) + $carry] ;# add back carry to 16 but value
set carry [expr ($sum >> 16) & 0xffff]  ;# isolate carry again
set sum [expr $sum + $carry]            ;# add back carry again
set sum [expr ~ $sum]                   ;# invert
set highorderbyte [expr ($sum >> 8) & 0xff]     ;# high order byte
set loworderbyte  [expr $sum & 0xff] ;# low order byte
puts [format "debug: checksum is %04x" [expr $sum & 0xffff]]
return [list $highorderbyte $loworderbyte]
}




################################################################################
# Proc CalcIPCheckSum
# -------------------
# purpose: This procedure calculates the IP Checksum and stores the results in the ATM Frame
# parameters: the frame ( a struct ATM ) and the offset into the frame for the checksum
# returns: nothing, but modifies the frame
#
################################################################################
proc CalcIPCheckSum { frame offset } {
pputs "CalcIPCheckSum"
upvar atmFrame $frame
set sum 0

for {set i 0} {$i < 10} {incr i} {
  if {$i !=  5} {
    set a $atmFrame(ucFrameData.[expr $offset + (2*$i)])
    set b $atmFrame(ucFrameData.[expr $offset + ((2*$i)+1)])
    set a [expr $a << 8]
    set a [expr $a | $b]
    set sum [expr $sum + $a]
  }
}

set sum [expr [expr ($sum >> 16)] + [expr ($sum % 65536)]]
set sum [expr [expr ($sum >> 16)] + [expr ($sum % 65536)]]

set sum [expr ~$sum]
set a [expr $sum % 256]
set atmFrame(ucFrameData.[expr $offset + 11]) $a


set sum [expr $sum >> 8]
set a [expr $sum % 256]
set atmFrame(ucFrameData.[expr $offset + 10]) $a
}








};#end of checksum



###
# bl57-configfile.tcl
###

namespace eval bl {


#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#
#
# CONFIG FILE FUNCTIONS
# -------------------
#
#
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################



#############################################################################
# proc smartbitsReadTableishConfigFile
# ---------------------------------------
# purpose: read in a config file that looks like this:
#smartbitsIp  10.26.1.99
#testTimeInSeconds 10
#tos 5
#mcPercent 10
#tosPercent 10
#
##
##################################################################################################################################
#T  224.5.5.5 0/0/1  1000 F  1000000 100 3000  33.1.1.2  255.255.255.252     33.1.1.1  { 100.1.1.2 100.1.1.6 100.1.1.10 100.1.1.14 100.1.1.18 100.1.1.22 }
##T  224.5.5.5 0/0/1  1000 F  1000000 128 3000   33.1.1.2  255.255.255.252     33.1.1.1  { 100.1.1.2 }
#R  224.5.5.5 0/1/0  100  F  1000  128 500      100.1.1.2  255.255.255.252    100.1.1.1  33.1.1.2
#R  224.5.5.5 0/1/1  100  F  1000  128 500      100.1.1.6  255.255.255.252    100.1.1.5  33.1.1.2
#R  224.5.5.5 0/1/2  100  F  1000  128 500     100.1.1.10  255.255.255.252    100.1.1.9  33.1.1.2
#R  224.5.5.5 0/1/3  100  F  1000  128 500     100.1.1.14  255.255.255.252   100.1.1.13  33.1.1.2
#R  224.5.5.5 0/1/4  100  F  1000  128 500     100.1.1.18  255.255.255.252   100.1.1.17  33.1.1.2
#R  224.5.5.5 0/1/5  100  F  1000  128 500     100.1.1.22  255.255.255.252   100.1.1.21  33.1.1.2
#
#
# parameters:
# returns:
# notes:
#############################################################################
proc smartbitsReadTableishConfigFile { configfile paramlist } {
pputs "smartbitsReadTableishConfigFile"
global info
set filehandle [ open $configfile r ]
if {$filehandle == "" } {
puts "Error: Opening file $thefile for read"
exit
}

fconfigure $filehandle -blocking 0
fconfigure $filehandle -buffering line
set paramlistlen [llength $paramlist]

foreach line [split [read $filehandle ] \n] {
  if { [string length $line] > 1 } {
  set itsnotacomment [string first # $line]
  set itsnotasection [string first \[ $line]
    if { $itsnotacomment && $itsnotasection } {
      set numwords [llength $line]
      if { $numwords == 2 } {
        set param [lindex $line 0]
        set value [lindex $line 1]
        set bl::$param $value
      } else {
        set hsp [lindex $line 2]
        lappend ::info(hsplist) $hsp
        for { set i 0 } { $i < $numwords } { incr i } {
          set param [lindex $paramlist $i]
          set value [lindex $line $i]
          set bl::info($hsp.$param) $value
        }
      }
    }
  }
}
}


#end config file

}



###
# bl57-counter.tcl
###

namespace eval bl {

##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
#
#
# COUNTER FUNCTIONS
# ---------------
# This sections contains functions that
# get l2, l3 counters and some which display these to the screen
#
#
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################

#############################################################################
# proc getL3Counters
# ---------------------------------------
# purpose: get the layer3 counters, what else?
# parameters: look and see
# returns: look and see
# notes:
#############################################################################
proc getL3Counters { params } {
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
pputs "getL3Counters"

set returnList {0 0 0 0 0 0 0}
switch $cardmodel {
"LAN-3201" -
"LAN-6310" -
"LAN-6311" -
"LAN-3310" -
"LAN-3311" -
"LAN-6310A" -
"LAN-6311A" -
"LAN-3300" -
"LAN-3301" -
"LAN-3325" -
"XLW-3721" -
"XLW-3720" -
"LAN-3300A" -
"LAN-3301A" -
"LAN-3310A" -
"LAN-3311A" -
"LAN-6311A/3311A" -
"LAN-3710" -
"LAN-3710AL" {
struct_new statInfo ETHExtendedCounterInfo
bl::check HTGetStructure $SMB::ETH_EXTENDED_COUNTER_INFO 0 0 0 statInfo 0 $h $s $p
set returnList [lreplace $returnList 2 2 $statInfo(ulRxARPReplies)]
set returnList [lreplace $returnList 3 3 $statInfo(ulTxARPRequests)]
set returnList [lreplace $returnList 4 4 $statInfo(ulRxPingReplies)]
set returnList [lreplace $returnList 5 5 $statInfo(ulTxPingRequests)]
set returnList [lreplace $returnList 6 6 $statInfo(ulRxPingRequests)]
unset statInfo
}
"LAN-6101A/3101A" -
"LAN-6101" -
"LAN-3101" -
"LAN-3101A" -
"LAN-3101B" -
"ML-7710" -
"ML-5710" {
struct_new statInfo EnhancedCounterStructure
set statInfo(ulMask2) [expr $SMB::L3_TX_STACK | $SMB::L3_RX_STACK | $SMB::L3_ARP_REQ | \
$SMB::L3_ARP_SEND | $SMB::L3_ARP_REPLIES | $SMB::L3_PINGREP_SENT | \
$SMB::L3_PINGREQ_SENT | $SMB::L3_PINGREQ_RECV]
bl::check HTGetEnhancedCounters statInfo $h $s $p
set returnList [lreplace $returnList 0 0 $statInfo(ulData.38)]
set returnList [lreplace $returnList 1 1 $statInfo(ulData.37)]
set returnList [lreplace $returnList 2 2 $statInfo(ulData.41)]
set returnList [lreplace $returnList 3 3 $statInfo(ulData.39)]
set returnList [lreplace $returnList 4 4 $statInfo(ulData.42)]
set returnList [lreplace $returnList 5 5 $statInfo(ulData.43)]
set returnList [lreplace $returnList 6 6 $statInfo(ulData.44)]
unset statInfo
}
default {
struct_new statInfo L3StatsInfo
bl::check HTGetStructure $SMB::L3_READ_COUNTERS 0 0 0 statInfo 0 $h $s $p
set returnList [lreplace $returnList 0 0 $statInfo(ulRxStackCount)]
set returnList [lreplace $returnList 1 1 $statInfo(ulTxStackCount)]
set returnList [lreplace $returnList 2 2 $statInfo(ulArpReplyRecv)]
set returnList [lreplace $returnList 3 3 $statInfo(ulArpRequestSent)]
set returnList [lreplace $returnList 4 4 $statInfo(ulPingReplySent)]
set returnList [lreplace $returnList 5 5 $statInfo(ulPingRequestSent)]
set returnList [lreplace $returnList 6 6 $statInfo(ulPingRequestRecv)]
unset statInfo
}
}
return $returnList
}
}

proc getTxPps { l2counts } { return [lindex $l2counts 10] }
proc getRxPps { l2counts } { return [lindex $l2counts 9] }
proc getTxRxPps { l2counts } { return [list [lindex $l2counts 10] [lindex $l2counts 9]] }

proc showPps { params } {

eval $bl::macro1
eval $bl::macro2
set i [getTxRxPps [getL2Counts $h $s $p]]
vputs "$h/$s/$p tx:[lindex $i 0]pps rx:[lindex $i 1]pps"
}

proc EXGetTxPps { l2counts } { return [lindex $l2counts 10] }
proc EXGetRxPps { l2counts } { return [lindex $l2counts 9] }

proc decodeThoseL2Counters { l2counts } {
set returnList ""
set descriptionList [list \
"Received Packets     " \
"Transmitted Packets  " \
"Collisions           " \
"Received Triggers    " \
"Received Bytes       " \
"CRC's                " \
"Align Errors         " \
"Oversize packets     " \
"Undersize packets    " \
"Receive Packet Rate  " \
"Transmit packet rate " \
"CRC Rate             " \
"Oversize packet rate " \
"undersize packet rate" \
"Collision rate       " \
"Alignment error rate " \
"Recieve trigger rate " \
"Receive Byte Rate    " ]
set len [llength $l2counts]
for { set i 0 } { $i < $len } { incr i } {
  set counter [lindex $l2counts $i]
  set description [lindex $descriptionList $i]
  set returnList "$returnList$description:$counter\n"
}
return $returnList
}

proc showL2Counters { params } {
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  vputs ""
  vputs "Layer2 Counters for $h/$s/$p"
  vputs "------------------------------"
  set l2counts [getL2Counters "h=$h s=$s p=$p"]
  vputs [decodeThoseL2Counters $l2counts]
  vputs ""
}
}

proc perStreamCounts { params } { showPerStreamCounters $params }
proc showPerStreamCounts { params } { showPerStreamCounters $params }
proc showPerStreamResults { params } { showPerStreamCounters $params }
proc streamcounters { params } { showPerStreamCounters $params }
proc NSstreamcounters { params } { NSshowPerStreamCounters $params }

proc showPerStreamCounters { params } {
pputs "showPerStreamCounters $params"

eval $bl::macro1

  foreach port $ports {
    eval $bl::macro2
    vputs "$h/$s/$p"
    vputs "--------"
    set cardModel [getLibCardModel "h=$h s=$s p=$p"]
    set totalpak 0
    switch $cardModel {
      "AT-9622" -
      "AT-9015" -
      "AT-9020" -
      "AT-9155C" -
      "AT-9155" -
      "AT-9155CS" {
        puts "ATM Cards are special"
      }
      default {
        foreach stream [getPerStreamCounts "h=$h s=$s p=$p"] {
          vputs $stream
          incr totalpak [lindex [split $stream :] end]
        }
      }
    }
    puts "                          ------"
    puts "                          $totalpak"
  }
  if { $bl::AUTOHISTO } {
    bl::enablestreamcounts $params
  }
}

proc NSshowPerStreamCounters { params } {
pputs "showPerStreamCounters $params"

eval $bl::macro1

  foreach port $ports {
    eval $bl::macro2
    vputs "$h/$s/$p"
    vputs "--------"
    set cardModel [getLibCardModel "h=$h s=$s p=$p"]
    set totalpak 0
    switch $cardModel {
      "AT-9622" -
      "AT-9015" -
      "AT-9020" -
      "AT-9155C" -
      "AT-9155" -
      "AT-9155CS" {
        puts "ATM Cards are special"
      }
      default {
        foreach stream [NSgetPerStreamCounts "h=$h s=$s p=$p"] {
          puts $stream
          incr totalpak [lindex [split [lindex [split $stream :] end]] end]
        }
      }
    }
    puts "                          ------"
    puts "                          $totalpak"
  }
  if { $bl::AUTOHISTO } {
    bl::enablestreamcounts $params
  }
}

proc clearcounters { params } { clearCounters $params }
proc clearCounters { params } {
pputs "clearCounters"

eval $bl::macro1
  foreach port $ports {
  eval $bl::macro2
  vputs "Clearing counters on port $port"
  bl::check HTClearPort $h $s $p
  }
}


#############################################################################
# proc superCounters
# ---------------------------------------
# purpose: wait a while, and display tx rate and rx rate while waiting
# parameters:  infamous "info" structure and testTimeInSeconds
# returns: nothing.
# notes: relies on PP function..blah..blah
#############################################################################
proc superCounters { info testTimeInSeconds } {
pputs "superCounters"
upvar $info blah
set totalSecondsSoFar 0
for { set temp 0 } { $temp < $testTimeInSeconds } { incr temp } {
  set tickTime [expr 100 * $testTimeInSeconds]
  after $tickTime
  incr totalMilliSecondsSoFar [expr $tickTime]
  foreach hsp $blah(hsplist) {
    set h [lindex [split $hsp /] 0]
    set s [lindex [split $hsp /] 1]
    set p [lindex [split $hsp /] 2]
    if {  [string first $blah($hsp.direction) T] > -1 } {
      PP "Elapsed Time:$totalMillisecondsSoFar\ms TX pps $hsp:[EXGetTxPps [EXReturnL2Counters $h $s $p]]"
    }
    if {  [string first $blah($hsp.direction) R] > -1 } {
      PP "                            rx pps $hsp:[EXGetRxPps [EXReturnL2Counters $h $s $p]]"
    }
  }
}
}



##########################################################################################
# print counters: prints out scriptcenter counters
##########################################################################################
proc printCounters { h s p count } {
if { $bl::ONEBASEDHSP } {set h [minus $h]; set s [minus $s]; set p [minus $p]}
set counterfield { RcvPkt TmtPkt Collision RcvTrig RcvByte CRC Align Oversize Undersize RcvPktRate TmtPktRate CRCRate OversizeRate UndersizeRate CollisionRate AlignRate RcvTrigRate RcvByteRate RxStack TxStack ArpReplyRcv ArpReqSent PingReplySent PingReqSent PingReqRcv }
lputs "$h/$s/$p"
lputs "--------"
lputs "TX Packets    : [lindex $count [lsearch $counterfield TmtPkt]]"
lputs "RX Packets    : [lindex $count [lsearch $counterfield RcvPkt]]"
lputs "RX Triggers   : [lindex $count [lsearch $counterfield RcvTrig]]"
#puts "Lost Packets  : [expr $TmtPkt - $RcvPkt]"
#puts "Lost Triggers : [expr $TmtPkt - $RcvTrig]"
lputs "CRC Errors    : [lindex $count [lsearch $counterfield CRC]]"
lputs "TX Rate (P/s) : [lindex $count [lsearch $counterfield TmtPktRate]]"
}


proc getL2Counts { params } { return [getL2Counters $params] }

proc results { params } {
puts [getL2Counters $params]
#showL2Counters $params
}

proc counters { params } {
   foreach port [getL2Counters $params] {
      puts "[lindex $port 0]"
      puts "----------------"
      set i 0
      foreach counter $port {
         incr i
         if { $i > 1 } {
            puts $counter
         }
      }
      puts ""
   }
}
#proc counters { params } { bl::group showcounters }

#############################################################################
# proc getL2Counters
# --------------------------
# purpose: get the l2 counters
# parameters:  hsp counters=
# returns:  a list of counters
#############################################################################
proc getL2Counters { params } {
set stuff(counters) "TmtPkt,RcvPkt"
eval $bl::macro1
foreach port $ports {
  eval $bl::macro2
  set metrics [list "RcvPkt" "TmtPkt" "Collision" "RcvTrig" "RcvByte"         \
  "CRC" "Align" "Oversize" "Undersize" "RcvPktRate"          \
  "TmtPktRate" "CRCRate" "OversizeRate" "UndersizeRate"     \
  "CollisionRate" "AlignRate" "RcvTrigRate" "RcvByteRate"  ]
  catch { unset ccounters }
  set counterss [split $counters ,]
  struct_new ccounters HTCountStructure
  bl::check HTGetCounters ccounters $h $s $p
  foreach mymetric $counterss {
    set yy [lsearch $metrics $mymetric]
      if {  $yy > -1 } {
         if { ! [info exists returnstring($port)] } {
            set returnstring($port) ""
         }
        lappend returnstring($port) [format %-15s $mymetric]$ccounters([lindex $metrics $yy])
      }
  }
}
foreach port $ports {
   lappend returnstringg "port:$port $returnstring($port)"
}
return $returnstringg
}


proc groupcounters32 { { params -1 } } {
set stuff(mymetrics) "TmtPkt,RcvPkt"
eval $bl::macro1
set metrics [list "RcvPkt" "TmtPkt" "Collision" "RcvTrig" "RcvByte"         \
"CRC" "Align" "Oversize" "Undersize" "RcvPktRate" "TmtPktRate" ]

set columnheaders [list "Port#" "RcvPkt" "TmtPkt" "Collision" "RcvTrig" "RcvByte"         \
"CRC" "Align" "Oversize" "Undersize" "RcvPktRate" "TmtPktRate" ]
#verticalwords $columnheaders
set columnheaders "#,$mymetrics"
set columnheaders [split $columnheaders ,-+;]
#lappend gg "#"
foreach met [split $mymetrics ,-:;] {
  set rr  [lsearch $bl::SMARTLIBMETRICSLIST $met]
  lappend gg [lindex $bl::PRINTABLEMETRICSLIST $rr ]
}
verticalmetrics $gg
#verticalmetrics $columnheaders
set mymetrics [split $mymetrics ,-+;]
catch { unset counters }
struct_new counters HTCountStructure
set retval ""
foreach port [split $ports ,+;] {
  eval $bl::macro2
  set cardModel [getLibCardModel "h=$h s=$s p=$p"]
  switch $cardModel {
  "AT-9622" -
  "AT-9015" -
  "AT-9020" -
  "AT-9155C" -
  "AT-9155" -
  "AT-9155CS" {
    #puts "ATM Cards are special...we can only show you per stream rates and counts"
    set i -1
    qputs -nonewline "[format %-6s $port]  "
    set bogus 0
    foreach metric $mymetrics {
      #set formatlen [expr 2 + [string length $counters([lindex $metrics $i])]]
      switch $metric  {
      "RcvPktRate" {
        set counters(RcvPktRate) [atmGetRxPps $port]
      }
      "TmtPktRate" {
        set counters(TmtPktRate) [atmGetTxPps $port]
      }
      "TmtPkt" {
        set results(999) 999
        set numPvc 1; set pvcToGet 0
        set vpi 0; set vci 100
        atmGetManyPvcTxRxTrigger $h $s $p $numPvc results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000  2.0.100.rx 100000
        set temp2 [lindex $temp1 2]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set counters(TmtPkt) $results($h.$s.$p.$vpi.$vci.tx)
      }
      "RcvPkt" {
        set results(999) 999
        set numPvc 1; set pvcToGet 1
        atmGetOnePvcTxRxTrigger $h $s $p $numPvc $pvcToGet results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000 2.0.100.rx 100000
        set temp2 [lindex $temp1 4]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set counters(RcvPkt) $results($h.$s.$p.$vpi.$vci.rx)
        put array get counters
        exit
      }
      "RcvTrig" {
        set results(999) 999
        set numPvc 1; set pvcToGet 1
        set vpi 0; set vci 100
        atmGetOnePvcTxRxTrigger $h $s $p $numPvc $pvcToGet results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000 2.0.100.rx 100000
        set temp2 [lindex $temp1 0]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set counters(RcvPkt) $results($h.$s.$p.$vpi.$vci.rx)
        set counters(RcvTrig) $results($h.$s.$p.$vpi.$vci.trigger)
      }
      default { set bogus 1 }
      }
      if { ! $bogus } {
        set formatlen 14
        qputs -nonewline "[format %-$formatlen\s $counters($metric)]"
      }
    }
    qputs ""
  }
  default {
    bl::check HTGetCounters counters $h $s $p
    set i -1
    qputs -nonewline "[format %-6s $port]  "
    set retval "$retval[format %-6s $port]  "
    foreach metric $mymetrics {
      #set formatlen [expr 2 + [string length $counters([lindex $metrics $i])]]
      set formatlen 14
      qputs -nonewline "[format %-$formatlen\s $counters($metric)]"
      set retval $retval[format %-$formatlen\s $counters($metric)]
    }
    set retval $retval\n
    qputs ""
  }
  }
}
return $retval
}

#USAGE: bl::group "counters counters=u64TxSignatureFrames.low,u64RxSignatureFrames.low"

proc groupcounters { { params -1 } } {
#puts params:$params
set stuff(counters) "TmtPkt,RcvPkt,u64TxSignatureFrames.low,u64RxSignatureFrames.low,CRC,Oversize"
eval $bl::macro1
set metrics [list "RcvPkt" "TmtPkt" "Collision" "RcvTrig" "RcvByte"         \
"CRC" "Align" "Oversize" "Undersize" "RcvPktRate" "TmtPktRate RxSig TxSig RXDIE" ]

set columnheaders [list "Port#" "RcvPkt" "TmtPkt" "Collision" "RcvTrig" "RcvByte"         \
"CRC" "Align" "Oversize" "Undersize" "RcvPktRate" "TmtPktRate RxSig TxSig RxDIE" ]
#verticalwords $columnheaders
set columnheaders "#,$counters"
set columnheaders [split $columnheaders ,-+;]
lappend rgg "#"
foreach met [split $counters ,-:;] {
  set rr  [lsearch $bl::SMARTLIBMETRICSLIST $met]
  if { $rr > -1 } {
    lappend rgg [lindex $bl::PRINTABLEMETRICSLIST $rr ]
  }
  set rr [lsearch $bl::ADVANCEDMETRICSLIST $met]
  if { $rr > -1 } {
    lappend rgg [lindex $bl::ADVANCEDPRINTLIST $rr]
  }
}
#verticalmetrics $rgg 16
verticalmetrics $rgg 10
#verticalmetrics $columnheaders
set counters [split $counters ,-+;]
catch { unset ccounters }
struct_new ccounters HTCountStructure
struct_new ec ETHExtendedCounterInfo
set retval ""
set bl::QUIETFLAG 0

foreach port $ports {
  eval $bl::macro2
  set cardModel [getLibCardModel "h=$h s=$s p=$p"]
  switch $cardModel {
  "AT-9622" -
  "AT-9015" -
  "AT-9020" -
  "AT-9155C" -
  "AT-9155" -
  "AT-9155CS" {
    #puts "ATM Cards are special...we can only show you per stream rates and counts"
    set i -1
    qputs -nonewline "[format %-6s $port]  "
    set bogus 0
    foreach metric $counters {
      #set formatlen [expr 2 + [string length $ccounters([lindex $metrics $i])]]
      switch $metric  {
      "RcvPktRate" {
        set ccounters(RcvPktRate) [atmGetRxPps $port]
      }
      "TmtPktRate" {
        set ccounters(TmtPktRate) [atmGetTxPps $port]
      }
      "TmtPkt" {
        set results(999) 999
        set numPvc 1; set pvcToGet 0
        set vpi 0; set vci 100
        atmGetManyPvcTxRxTrigger $h $s $p $numPvc results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000  2.0.100.rx 100000
        set temp2 [lindex $temp1 2]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set ccounters(TmtPkt) $results($h.$s.$p.$vpi.$vci.tx)
      }
      "RcvPkt" {
        set results(999) 999
        set numPvc 1; set pvcToGet 1
        atmGetOnePvcTxRxTrigger $h $s $p $numPvc $pvcToGet results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000 2.0.100.rx 100000
        set temp2 [lindex $temp1 4]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set ccounters(RcvPkt) $results($h.$s.$p.$vpi.$vci.rx)
        #puts [array get ccounters]
        #exit
      }
      "RcvTrig" {
        set results(999) 999
        set numPvc 1; set pvcToGet 1
        set vpi 0; set vci 100
        atmGetOnePvcTxRxTrigger $h $s $p $numPvc $pvcToGet results
        set temp1 [array get results]
        #2.0.100.trigger 100000 2.0.100.tx 100000 2.0.100.rx 100000
        set temp2 [lindex $temp1 0]
        set temp3 [split $temp2 .]
        set vpi [lindex $temp3 3]
        set vci [lindex $temp3 4]
        set ccounters(RcvPkt) $results($h.$s.$p.$vpi.$vci.rx)
        set ccounters(RcvTrig) $results($h.$s.$p.$vpi.$vci.trigger)
      }
      default { set bogus 1 }
      }
      if { ! $bogus } {
        set formatlen 10
        qputs -nonewline "[format %-$formatlen\s $ccounters($metric)]"
      }
    }
    qputs ""
  }
  default {
    bl::check HTGetCounters ccounters $h $s $p
    bl::check HTGetStructure $SMB::ETH_EXTENDED_COUNTER_INFO 0 0 0 ec 0 $h $s $p
    set di  $ec(u64RxDataIntegrityErrors.low)
    set rxTag $ec(u64RxSignatureFrames.low)
    set txTag $ec(u64TxSignatureFrames.low)
    #puts "$h/$s/$p: tx=$txTag rx=$rxTag di=$di"
    set i -1
    set formatlen 10
    qputs -nonewline "[format %-$formatlen\s $port]"
    set retval "$retval[format %-$formatlen\s $port]"
    foreach metric $counters {
      ##set formatlen [expr 2 + [string length $ccounters([lindex $metrics $i])]]
      set formatlen 10
      if { [lsearch $bl::ADVANCEDMETRICSLIST $metric] == -1 } {
        qputs -nonewline "[format %-$formatlen\s $ccounters($metric)]"
        set retval $retval[format %-$formatlen\s $ccounters($metric)]
      } else {
        qputs -nonewline "[format %-$formatlen\s $ec($metric)]"
        set retval $retval[format %-$formatlen\s $ec($metric)]
      }
    }
    set retval $retval\n
    qputs ""
  }
  }
}
#puts retval:$retvalf
#return $retval
}



proc enable_jumbo_stream_counters { params } {
eval $bl::macro1
struct_new gm GIGMacConfig;
set gm(ucEnableJumboFrame) 1
foreach port $ports {
eval $bl::macro2
puts "Enabling jumbo frame stream counts on $h/$s/$p"
bl::check HTSetStructure $SMB::GIG_STRUC_MAC_CONFIG_INFO 0 0 0 gm 0 $h $s $p
}
}


#############################################################################
# proc enablePerStreamCounters
# ---------------------------------------
#############################################################################
proc smartmetricsEnablePktPerStream { params } {
pputs "smartmetricsEnablePktPerStream"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
bl::check HTSetCommand $SMB::L3_HIST_SEQUENCE 0 0 0 "" $h $s $p
bl::check HTSetCommand $SMB::L3_HIST_START 0 0 0 "" $h $s $p
}
}

#############################################################################
proc NSsmartmetricsEnablePktPerStream { params } {
pputs "smartmetricsEnablePktPerStream"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
bl::check HTSetCommand $SMB::NS_HIST_SEQUENCE_PER_STREAM 0 0 0 "" $h $s $p
bl::check HTSetCommand $SMB::NS_HIST_START 0 0 0 "" $h $s $p
}
}


proc smartmetricsZeroOutPerStreamCounters { params } {
pputs "smartmetricsZeroOutPerStreamCounters"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
bl::check HTSetCommand $SMB::L3_HIST_SEQUENCE_INFO 0 0 0 "" $h $s $p
}
}

#############################################################################
# proc enablePerStreamCounters
# ---------------------------------------
#############################################################################

proc smartmetricsEnablePerStreamCounters { params } {
pputs "smartmetricsEnablePerStreamCounters"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
bl::check HTSetCommand $SMB::NS_HIST_SEQUENCE 0 0 0 "" $h $s $p
bl::check HTSetCommand $SMB::NS_HIST_START 0 0 0 "" $h $s $p
}
}

proc restartstreamcounts { params } {
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
#bl::check HTSetCommand $SMB::L3_HIST_SEQUENCE 0 0 0 "" $h $s $p
bl::check HTSetCommand $SMB::L3_HIST_START 0 0 0 "" $h $s $p
}
}

proc enable { { params streamcounters } {arglist -1 } } {
  set thingtoenable [lindex $params 0]
  set arglist [lindex $params 1]
  if { $arglist != "" \
    && \
    $arglist != " " \
    && \
    [string length $arglist] < 3 \
    && \
    -1 == [string first = $arglist] } {
    set arglist "port=$arglist"
  }
  switch $thingtoenable {
    streamcounters { smartmetricsEnablePerStreamCounters $arglist }
  }
}

proc enablestreamcounters { params } { smartmetricsEnablePerStreamCounters $params }
proc enablestreamscounters { params } { smartmetricsEnablePerStreamCounters $params }
proc enablestreamcounts { params } { smartmetricsEnablePerStreamCounters $params }
proc simpleSmartmetricsPacketPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc getPacketPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc getPacketsPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc smartmetricsGetPacketPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc smartmetricsGetPacketsPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc packetPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }
proc getPerStreamCounts { params } { return [simpleSmartmetricsPktPerStream $params] }
proc NSgetPerStreamCounts { params } { return [NSsimpleSmartmetricsPktPerStream $params] }

proc getPerStreamCounters { params } { return [simpleSmartmetricsPktPerStream $params] }
proc smartmetricsGetPktPerStream { params } { return [simpleSmartmetricsPktPerStream $params] }

proc smartmetricsEnableLatOverTime { params } {
pputs "smartmetricsEnableLatOverTime $params"
set stuff(timeslotInterval) 1000

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
catch {unset lot}
struct_new lot Layer3HistLatency
set lot(ulInterval) $timeslotInterval
bl::check HTSetCommand $SMB::L3_HIST_V2_LATENCY 0 0 0 lot $h $s $p
}
}


proc smartmetricsGetLatOverTime { h s p latArray { timeslotsToGet 30 } } {
pputs "smartmetricsGetLatOverTime"
  upvar $latArray localLatArray
  eval $bl::macro2
  struct_new lot Layer3LongLatencyInfo
  for { set timeSlot 0 } { $timeSlot < $timeslotsToGet } { incr timeSlot } {
    dputs [time { set x [HTGetStructure $SMB::L3_HIST_V2_LATENCY_INFO $timeSlot 0 0 lot 0 $h $s $p] } ]
    if { $x > 0 } {
      set localLatArray($timeSlot) $lot(ulFrames)
    } else {
      catch {  udputs "no record found for time slot:$timeSlot" }
      set localLatArray($timeSlot) "no record found"
    }
  }
}

proc simpleSmartmetricsPktPerStream { params } {
pputs "simpleSmartmetricsPktPerStream"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
set numOfRecords 1
catch { unset l3_test_info }
struct_new l3_test_info Layer3HistActiveTest
set iErr [HTGetStructure $SMB::L3_HIST_ACTIVE_TEST_INFO 0 0 0 l3_test_info "" $h $s $p]
if {$iErr > -1} {
  set numOfRecords $l3_test_info(ulRecords)
}
unset l3_test_info

if {$numOfRecords < 1} {
  return -1
}

set latList {}

#Make the list from the records
for {set i 0} {$i < $numOfRecords} {incr i} {
  catch { unset seq }
  struct_new seq Layer3SequenceInfo
  bl::check HTGetStructure $SMB::L3_HIST_SEQUENCE_INFO $i 0 0 seq "" $h $s $p
  set maskedStreamNumber 0
  #set STREAM [expr $L3StrmInfo($i.ulStream) & 0x0000FFFF]
  set maskedStreamNumber [expr $seq(ulStream) % 0x10000]
  set record "$maskedStreamNumber $seq(ulFrames) $seq(ulSequenced) $seq(ulDuplicate) $seq(ulLost)"
  set brett1 [binary format s1 $seq(ulStream)]
  #set sendingH1  [expr ($seq(ulStream) & 0x0F000000) / 0x010000000]
  #set sendingH1 [expr ($seq(ulStream) & 0x0E000000) / 0x010000000 >> 1]    ;#barry's modification
  set blah [format %x [expr ($seq(ulStream) & 0x0F000000)]]
  set sendingH1 [string index $blah 0] ;#brett's modification
  ###################################### 0xF0000000
  #set sendingS1  [expr ($seq(ulStream) & 0x00FF0000) / 0x00010000]
  set sendingS1 [expr ($seq(ulStream) & 0x001F0000) / 0x00010000]         ;#barry's modification
  set sendingPort   [expr ($seq(ulStream) & 0x00E00000) >> 21]
  set sendingStream [expr $seq(ulStream) & 0x0000FFFF]

  set pkt $seq(ulFrames)
  if { $bl::ONEBASEDHSP } {
    set temp "[plus $sendingH1]/[plus $sendingS1]/[plus $sendingPort]"
  } else {
    set temp "$sendingH1/$sendingS1/$sendingPort"
  }
  set simplerecord "stream:$sendingStream from:$temp RxPkt:$pkt"
  lappend simpleList $simplerecord
  catch {unset seq}
  }
catch {unset LatencyInfo}
return $simpleList
}
}

proc NSsimpleSmartmetricsPktPerStream { params } {
pputs "simpleSmartmetricsPktPerStream"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
set numOfRecords 1
catch { unset l3_test_info }
struct_new l3_test_info Layer3HistActiveTest
set iErr [HTGetStructure $SMB::NS_HIST_ACTIVE_TEST_INFO 0 0 0 l3_test_info "" $h $s $p]
if {$iErr > -1} {
  set numOfRecords $l3_test_info(ulRecords)
}
unset l3_test_info
puts numrec:$numOfRecords
if {$numOfRecords < 1} {
  return -1
}

set latList {}


#Make the list from the records
  catch { unset seq }
  struct_new seq NSHistSequencePerStreamInfo;

for {set i 0} {$i < $numOfRecords} {incr i} {
  bl::check HTGetStructure $SMB::NS_HIST_SEQUENCE_PER_STREAM_INFO $i 0 0 seq "" $h $s $p
  set maskedStreamNumber 0
  #set STREAM [expr $L3StrmInfo($i.ulStream) & 0x0000FFFF]
  set maskedStreamNumber [expr $seq(ulStream) % 0x10000]
  set record "$maskedStreamNumber $seq(u64TotalFrames) $seq(u64InSequence) $seq(u64OutOfSequence)"
  set brett1 [binary format s1 $seq(ulStream)]
  #set sendingH1  [expr ($seq(ulStream) & 0x0F000000) / 0x010000000]
  #set sendingH1 [expr ($seq(ulStream) & 0x0E000000) / 0x010000000 >> 1]    ;#barry's modification
  set blah [format %x [expr ($seq(ulStream) & 0x0F000000)]]
  set sendingH1 [string index $blah 0] ;#brett's modification
  ###################################### 0xF0000000
  #set sendingS1  [expr ($seq(ulStream) & 0x00FF0000) / 0x00010000]
  set sendingS1 [expr ($seq(ulStream) & 0x001F0000) / 0x00010000]         ;#barry's modification
  set sendingPort   [expr ($seq(ulStream) & 0x00E00000) >> 21]
  set sendingStream [expr $seq(ulStream) & 0x0000FFFF]

  set pkt $seq(u64InSequence)
  if { $bl::ONEBASEDHSP } {
    set temp "[plus $sendingH1]/[plus $sendingS1]/[plus $sendingPort]"
  } else {
    set temp "$sendingH1/$sendingS1/$sendingPort"
  }
  set simplerecord "stream:$sendingStream from:$temp RxPkt:$pkt"
  lappend simpleList $simplerecord
}
return $simpleList
}
}



#end counters section
}


###
# bl57-debug.tcl
###

namespace eval bl {

############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
#
# DEBUGGING AND ERROR FUNCTIONS
# -------------
# This section has function for debugging and error handling
#
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################

#NOTE: bl::check, smartlibfunctionfinder, and errordebabler moved to core


###############################################################################
# proc breakpoint
# ----------------
# purpose: Just gets a return key from stdin
###############################################################################
proc breakpoint {} { puts "press \[enter\] to continue"; gets stdin in }

###############################################################################
# proc watchpoint
# ----------------
# purpose: put "watchpoint" anywhere in your script, it will prompt you for
#          variables to watch
###############################################################################
proc watchpoint { { i -1 } } {
  variable BRETTLIBWATCHLIST
  if { $i != -1 } {
    lappendUnique BRETTLIBWATCHLIST $i
  } else {
    if { ! [info exists BRETTLIBWATCHLIST] } {
      set BRETTLIBWATCHLIST ""
    }
  }

  puts "\nwatchlist"
  puts "---------"
  foreach thingToWatch $BRETTLIBWATCHLIST {
    upvar $thingToWatch blah;
    if { [ puts "$thingToWatch:$blah" } ] } { puts "<variable $thingToWatch not found>"
  }
  set in qqqq
  while { $in != "" } {
    puts -nonewline "\[enter\] to keep running, 'save', 'load', or name a variable to add:"
    flush stdout
    gets stdin in
    if { $in != "" && $in != "save" && $in != "load" } {
      lappendUnique BRETTLIBWATCHLIST $in
      puts "\nwatchlist"
      puts "---------"
      foreach thingToWatch $BRETTLIBWATCHLIST {
        upvar $thingToWatch blah;
        if { [ puts "$thingToWatch:$blah" } ] } { puts "<variable $thingToWatch not found>"
      }
    } elseif { $in == "save" } {
      puts [open BRETTLIBWATCHLIST.txt w] $BRETTLIBWATCHLIST
    } elseif { $in == "load" } {
      if { [ catch { gets [open BRETTLIBWATCHLIST.txt r] temp } ] } {
        puts "no watchlist found"
      } else {
        foreach thing [split $temp] { lappendUnique BRETTLIBWATCHLIST $thing }
        puts "\nwatchlist"
        puts "---------"
        foreach thingToWatch $BRETTLIBWATCHLIST {
          upvar $thingToWatch blah;
          if { [ puts "$thingToWatch:$blah" } ] } { puts "<variable $thingToWatch not found>"
        }
      }
    } else {
      break
    }
  }

}

###############################################################################
# proc triggerbreakpoint
# ----------------
# purpose: prompts for enter key if a variables gets set to a particular value
###############################################################################
proc triggerbreakpoint { i j } {
  upvar $i blah2
  if { $blah2 != $j } {
    return 0
  } else {
    return 1
  }
}

###############################################################################
#
# proc whereami
# --------------
# purpose: to print out a number, which shows you were you are! Then it increments it for you.
# parameters: the number to print out
# returns: incr of the param
# usage: set a 0
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#############################################################################################
proc whereami { a } { puts "*$a*"; flush stdout; after 200; flush stdout; incr a; return $a }


############################################################################################
#
# proc errordumper
# --------------
# purpose: to dump a catastrophic error message to the file, and keep the program going
# parameters: the error string, from catch
# returns: nothing
# usage:
#
# catch { BUGGYPROC buggyparams } theerrorholderstring
#        if { [string length $theerrorholderstring] > 3 } {
#            errordumper $theerrorholderstring
#        }
#############################################################################################
proc errordumper { i } {
set errorFile [open error.txt "a+"]
set line "------------------------------------------------------------"
puts $errorFile $line
puts -nonewline $errorFile [clock format [clock seconds] -format %D]
puts -nonewline $errorFile ","
puts -nonewline $errorFile [clock format [clock seconds] -format %T]
puts -nonewline $errorFile ","
puts $errorFile $i
close $errorFile
puts ""
puts "************************"
puts "*    ERRORS OCCURED    *"
puts "* check file error.txt *"
puts "************************"
}

###############################################################################
# proc catchError
# ----------------
# purpose: if there is an error in bit of code call errordumper
# parameters: the piece of code
# returns: nothing useful
# usage: catchError { "puts $nonExistantVariable" }
###############################################################################
proc catchError { i } {
catch { eval $i } temp
if { [string length $temp] > 3 } {
set line "------------------------------------------------------------"
errordumper "\n$line\nPHRASE:\"$i\"\n$temp\n$line\n"
}
}


##########################################################################################
# Proc startfile log.txt
# --------------
# purpose: to open a log file and timestamp it.
# parameters: the filename you want to use
# returns: the handle
#
#############################################################################################
proc startfile { { filename error.txt } { versionNumbering 1 } } {
  set seconds [split [clock format [clock seconds] -format %T] :]
  set seconds [join $seconds _]
  set date [split [clock format [clock seconds] -format %D] /]
  set date [join $date _]
  set hh [lindex [split $filename .] 0]
  set gg $hh\*
  set globular [glob -nocomplain $gg\*]
  set g [lrange $globular end end]
# BW 2/9/2002 2:23 PM
#   This is a way to get unprintable ascii: puts \1\2\3\4\5\6\f\v
  if { $g == "" } {
     set g "[subst $hh]0.txt"
  }
  set jj [split $g .]
  set prefix [lindex $jj 0 ]
  set suffix [lindex $jj 1 ]
  set blah [bl::extractnums $prefix]
  if { [regexp \[0-9\] $prefix hh] } {
    set blahh [expr $hh +1 ]
  }
  set prefix [string range $prefix 0 [expr -1 + [string first $blah $prefix]]]
  set blah [expr $blah + 1]
  if { $versionNumbering } {
    set filename $prefix$blah.$suffix
  }
  #set filename $filename\_$date\_$seconds\.txt
  set fileHandle [open $filename  "a+"]
  puts -nonewline $fileHandle "reported @:"
  puts -nonewline $fileHandle [clock format [clock seconds] -format %D]
  puts -nonewline $fileHandle ","
  puts $fileHandle [clock format [clock seconds] -format %T]
  return $fileHandle
}



#################################################################################################
# Proc Watchthis
# --------------
# purpose: to send to stdout some debug messages
# parameters: two strings, the first one typically a var and the second the var value
# returns: nothing
#
#############################################################################################
proc watchthis { one two } { puts -nonewline $one; puts -nonewline ":"; puts -nonewline $two; puts -nonewline ";" }


#end debug watch section
}



###
# bl57-decode.tcl
###

namespace eval bl {





##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
#
#
# DECODE FUNCTIONS
# ----------------
#
#
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################

proc showcapture { params } {
set stuff(numframes) 100
set stuff(numbytes) 256
set stuff(raw) 0
eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    struct_new nsci NSCaptureCountInfo;
    bl::check HTSetCommand $SMB::NS_CAPTURE_STOP 0 0 0 "" $h $s $p
    bl::check HTGetStructure $SMB::NS_CAPTURE_COUNT_INFO 0 0 0 nsci 0 $h $s $p
    dputs "Capture count on port $port = $nsci(ulCount)"
    struct_new nscdi NSCaptureDataInfo;
    set nscdi(ulRequestedLength) $numbytes
    set capfileh [open capfile.txt w+]
    if { $numframes > $nsci(ulCount) } {
      set numframes $nsci(ulCount)
    }
    set rawlines ""
    for {set i 0} { $i < $numframes } {incr i} {
      set temp2 0
      set temp3 "000000"
      set nscdi(ulFrameIndex) $i
      bl::check HTGetStructure $SMB::NS_CAPTURE_DATA_INFO 0 0 0 nscdi 0 $h $s $p
      set numbytes $nscdi(ulRetrievedLength)
      set pak($i) ""
      puts -nonewline $capfileh "$temp3 "
      set temp4 0
      set rawline ""
      for {set j 0} {$j < $numbytes } {incr j} {
        incr temp4
        set pak($i) "$pak($i).$nscdi(ucData.$j)"
        set temp [format %x $nscdi(ucData.$j)]
        if { [string length $temp] < 2 } { set temp "0$temp" }
        set rawline "$rawline$temp "
        puts -nonewline $capfileh "$temp "
        if { ! [expr (1 + $j) % 12] } {
          while { $temp4 > 0 } {
            puts -nonewline $capfileh "."
            set temp4 [expr $temp4 -1]
          }
          puts $capfileh ""
          set temp2 [expr $j + 1]
          set temp3 [format %x $temp2]
          while { [string length $temp3] < 6 } {
            set temp3 0$temp3
          }
          puts -nonewline $capfileh "$temp3 "
        }
      }
      puts -nonewline $capfileh " "
      while { $temp4 > -1 } {
        puts -nonewline $capfileh "."
        set temp4 [expr $temp4 -1]
      }
      puts $capfileh "\n\n"
      set pak($i) [string trim $pak($i) .]
      #puts $pak($i)
      lappend rawlines $rawline
    }
    close $capfileh
    set caplines ""
    for {set j 0} {$j < $numframes } {incr j} {
      lappend caplines [bl::decode $pak($j)]
    }
  }
  if { $raw } { set caplines $rawlines }
  return $caplines
}

proc reallyshowcapture { params } { set lines [showcapture $params]; foreach line $lines { puts $line } }


proc capturestart { params } { startcapture $params }
proc startcapture { params } {
set stuff(capstuff) "all"

eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
#   bl::check HTRun $SMB::HTRUN $h $s $p
    catch { unset nsc }
    struct_new nsc NSCaptureSetup
    set nsc(ulCaptureMode) $SMB::CAPTURE_MODE_FILTER_ON_EVENTS
    set nsc(ulCaptureLength) $SMB::CAPTURE_LENGTH_ENTIRE_FRAME
    if { $capstuff == "all" } {
      set nsc(ulCaptureEvents) $SMB::CAPTURE_EVENTS_ALL_FRAMES
    }
    if { $capstuff == "crc" } {
      set nsc(ulCaptureEvents) $SMB::CAPTURE_EVENTS_CRC_ERRORS
    }
    bl::check HTSetStructure $SMB::NS_CAPTURE_SETUP 0 0 0 nsc 0 $h $s $p
    bl::check HTSetCommand $SMB::NS_CAPTURE_START 0 0 0 "" $h $s $p
    #bl::check HTSetStructure $SMB::NS_CAPTURE_SETUP 0 0 0 nsc 0 $h $s $p
    #bl::check HTSetCommand $SMB::L3_CAPTURE_OFF_TYPE 0 0 0 "" $h $s $p
    #bl::check HTSetCommand $SMB::L3_CAPTURE_ALL_TYPE 0 0 0 "" $h $s $p
  }
}


proc showcaptureoldcards { params } {
eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
#   bl::check HTRun $SMB::HTRUN $h $s $p
    struct_new capCount Layer3CaptureCountInfo
    struct_new capData Layer3CaptureData
#NSCaptureCountInfo;
    bl::check HTGetStructure $SMB::L3_CAPTURE_COUNT_INFO 0 0 0 capCount 0 $h $s $p
    dputs "Capture count = $capCount(ulCount)"
    set see 10
    for {set i 0} { $i < $see } {incr i} {
      bl::check HTGetStructure $SMB::L3_CAPTURE_PACKET_DATA_INFO $i 0 0 capData 0 $h $s $p
      for {set j 0} {$j < 30} {incr j} {
    #   set iData [ConvertCtoI $capData(cData.$j.c)]  ;# use function in misc.tcl
    #   puts -nonewline [format " %02X" $iData]
        puts -nonewline $capData(cData.$j)
      }
      puts ""
    }
  }
}
proc startcaptureoldcards { params } {
eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
#   bl::check HTRun $SMB::HTRUN $h $s $p
    struct_new nsc NSCaptureSetup
    set nsc(ulCaptureMode) $SMB::CAPTURE_MODE_START_ON_EVENTS
    set nsc(ulCaptureLength) $SMB::CAPTURE_LENGTH_1ST_64_BYTES
    set nsc(ulCaptureEvents) $SMB::CAPTURE_EVENTS_ALL_FRAMES
    bl::check HTSetCommand $SMB::L3_CAPTURE_OFF_TYPE 0 0 0 "" $h $s $p
    bl::check HTSetCommand $SMB::L3_CAPTURE_ALL_TYPE 0 0 0 "" $h $s $p
  }
}

##########################################################################################
# decode
# --------------
# purpose: to bputs the MAC and IP and TOS decode of some hex data
# paramaters: the pkt, as read from a file. NOTE: Format must be EXReturnCapturePacket
# returns: nix
# usage: decode $pkt
##########################################################################################
proc decode { pkt } {
set spacer "  "
set capline ""
if { $pkt == "" } { return "" }
set pkt [split $pkt .]
set capline $capline$spacer
for { set i 0 } { $i <= 5 } { incr i } {
  set j [format %X [lindex $pkt $i]]
  if { [string length $j] == 1 } { set j 0$j   }
  set capline $capline$j
  if { $i < 5 } { set capline $capline\. }
}
set capline $capline$spacer
for { set i 6 } { $i <= 11 } { incr i } {
  set j [format %X [lindex $pkt $i]]
  if { [string length $j] == 1 } { set j 0$j   }
  set capline $capline$j
  if { $i < 11} { set capline $capline\. }
}
set capline $capline$spacer
set type ""
for { set i 12 } { $i <= 13 } { incr i } {
  set j [format %X [lindex $pkt $i]]
  if { [string length $j] == 1 } { set j 0$j   }
  set capline $capline$j
  set type $type$j
  #if { [expr $i+1] < 12} { bputs  -nonewline "." }
}
#puts type:$type<--
set capline $capline$spacer
set ipoffset 26
if { $type == "8100" } {
#  set leftbyte   [expr [lindex $pkt 14] << 8]
#  set oldleftbyte $leftbyte
#  set vlanid [expr [expr $leftbyte & 0x3F] + $rightbyte]
#  set leftbyte $oldleftbyte
#  set vp [expr ($leftbyte & 0xC0) >> 5]
#  set vc [expr ($leftbyte & 0x10) >> 4]

  #set vlantag $leftbyte$rightbyte
  set leftbyte [lindex $pkt 14]
  set oldleftbyte $leftbyte
  set rightbyte  [lindex $pkt 15]
  set vlanid [expr (($leftbyte & 0x0f) << 8) + $rightbyte]
  set leftbyte $oldleftbyte
  set vp [expr ($leftbyte & 0xE0) >> 5]
  set vc [expr ($leftbyte & 0x10) >> 4]
#  puts "VLAN:$vlanid VP:$vp vc:$vc"
  append capline "VLAN:$vlanid VP:$vp vc:$vc$spacer"
  set ipoffset 30
}
set capline $capline$spacer
for { set i $ipoffset } { $i < [expr $ipoffset + 4]} { incr i } {
  set j [lindex $pkt $i]
  set capline $capline$j
  if { $i < [expr $ipoffset + 3] } { set capline $capline\. }
}
set capline $capline$spacer
for { set i [expr $ipoffset +4] } { $i < [expr $ipoffset + 8] } { incr i } {
  set j [lindex $pkt $i]
  set capline $capline$j
  if { $i  < [expr $ipoffset+ 7] } { set capline $capline\. }
}
#bputs $capline
return $capline
}



#end decode section

}



###
# bl57-etherip.tcl
###

namespace eval bl {

#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#
#
# ETHERNET ADDRESS AND IP ADDRESS FUNCTIONS
# -------------------
#
#
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################


proc incIp { sip { validhost 1 } } { incrementIp $sip $validhost }
proc incrIp { sip { validhost 1 } } { incrementIp $sip $validhost }
proc incip { sip { validhost 1 } } { incrementIp $sip $validhost }
proc incrip { sip { validhost 1 } } { incrementIp $sip $validhost }

#############################################################################
# proc incrementIp
# --------------------------
# usage:
# purpose: wrapper function for dottedquad. makes for nicer looking code.
# parameters:  the ip address ( see dottedquad )
# returns:  nothing, but changes the value of the parameter
#############################################################################
proc incrementIp { sip { validhost 1 } } {
pputs "incrementIp"
upvar 0 $sip sip2
if { $validhost } {
set sip2 [dottedquad $sip2 1]
} else {
set sip2 [dottedquad $sip2]
}
}


#############################################################################
# proc incrementMac
# --------------------------
# purpose: wrapper function for sixmac. makes for nicer looking code.
# parameters:  the mac address ( see sixmac )
# returns:  nothing, but changes the value of the parameter
#############################################################################
proc incrementMac { smc } {
pputs "incrementMac"
upvar $smc smc2
set smc2 [sixmac $smc2]
}

proc incr_ip { ip mask { blah 0 } } {
	set lip [split $ip .]
	set lmask [split $mask .]
	set carry 0
	set l2 { 0 0 0 0 }
	for { set i 3 } { $i > -1 } { incr i -1 } {
		set l [lindex $lip $i]
		set m [lindex $lmask $i]
		set n [expr $l + $m + $carry]
		if { $n > 255 } {
			set carry 1
			set n [expr $n - 255 ]
		} else {
			set carry 0
		}
		set l2 [lreplace $l2 [expr 3-$i] [expr 3-$i] $n]
	}
	for { set i 0 } { $i < 4 } { incr i } {
		lappend l3 [lindex $l2 [expr 3-$i]]
	}
	return [join $l3 .]
}

###########################################
# Proc DottedQuad
# -----------------
# purpose: to take an ip address and add 1 to it, handling rollover
# parameters: aaa, the ip address as a string in the format 192.168.11.232
# returns: the same string, incremented by 1
#
############################################
proc dottedquad { aaa { validhostaddressonly 0 } } {
pputs "dottedquad"
if { $validhostaddressonly } {
  set upperlimit 254
  set lowerlimit 1
} else {
  set upperlimit 255
  set lowerlimit 0
}
set dottedquad [split $aaa "."]
for { set iii 3 } { $iii >= 0 } {incr iii -1} {
  if { $iii == 3 } {
    if { [lindex $dottedquad 3] < $upperlimit } {
      set blah [lreplace $dottedquad 3 3 [expr [lindex $dottedquad 3] + 1]]
      set aaa [join $blah .]
      break
    } else {
      set dottedquad [lreplace $dottedquad 3 3 $lowerlimit]
    };#endif we don't want to broadcast to all ip in last octet
  } else {
    if { [lindex $dottedquad $iii] < 255 } {
      set blah [lreplace $dottedquad $iii $iii [expr [lindex $dottedquad $iii] + 1]]
      if { $iii == 3 } {
        set blah [lreplace $blah [expr $iii + 1] [expr $iii + 1] $lowerlimit]
      } else {
        for { set jjj [expr $iii+1] } { $jjj <= 3 } { incr jjj } {
          if { [expr $jjj] == 3 } {
            set blah [lreplace $blah $jjj $jjj $lowerlimit]
          } else {
            set blah [lreplace $blah $jjj $jjj 0]
          }
        }
      }
      set aaa [join $blah "."]
      break
    }
  }
} ;#end loop of dotted quads
return $aaa
};#endproc dottedquad


###########################################
# Proc DottedQuadMask
# -----------------
# purpose: to take an ip address and add a Mask to it, handling rollover
# parameters: aaa, the ip address as a string in the format 192.168.11.232, the mask in 0.0.0.1 format
# returns: the same string, incremented by 1
#
############################################
proc dottedquadMask { aaa {mask 0.0.0.1 } { validhostaddressonly 0 } } {
pputs "dottedquadMask"
if { $validhostaddressonly } {
  set upperlimit 254
  set lowerlimit 1
} else {
  set upperlimit 255
  set lowerlimit 0
}
set dottedquad [split $aaa "."]
set masksplit [split $mask "."]
set carry 0

for { set iii 3 } { $iii >= 0 } {incr iii -1} {
  set maskinc [lindex $masksplit $iii]
  if { $iii == 3 } {
    set total [expr [lindex $dottedquad $iii] + $maskinc]
    if { $total <= $upperlimit } {
      set dottedquad [lreplace $dottedquad $iii $iii $total]
      set carry 0
    } else {
      set dottedquad [lreplace $dottedquad 3 3 $lowerlimit]
      set carry [expr $total - $upperlimit]
    };#endif we don't want to broadcast to all ip in last octet
  } else {
    set total [expr [lindex $dottedquad $iii] + $maskinc + $carry]
    #puts dottedquadwouldbe:[lreplace $dottedquad $iii $iii $total]
    if { $total <= 255 } {
      set dottedquad [lreplace $dottedquad $iii $iii $total]
      set carry 0
    } else {
      set dottedquad [lreplace $dottedquad $iii $iii 0]
      set carry [expr $total - 255]
    }
  }
} ;#end loop of dotted quads
return [join $dottedquad .]
};#endproc dottedquadMask



proc sixmac { smc } {
  set smc [split $smc .-]
  set smc2 ""
  foreach m $smc {
    #set m [string trim $m 0x]
    if { [string length $m] == 1 } {
      set m "0$m"
    }
    set smc2 $smc2$m
  }
  puts "smc2:$smc2 and in decimal [format %d $smc2]"
  set d [expr 0x$smc +1]
  #puts d:$d
  set d [format %0x $d]
  set l [expr [string length $d] -1]
  for { set i $l } { $i > -1 } { incr i -2 } {
    set m [string range $d [expr $i-1] $i]
    if { [string length $m] == 1 } {
      set m "0$m"
    }
    lappend r $m
  }
  while { [llength $r] < 6 } {
    lappend r 0
  }
  #puts r:$r
  set l [expr [llength $r] -1]
  for { set i $l } { $i > -1 } { incr i -1 } {
    lappend t [lindex $r $i]
  }
  #puts t:$t
  return [join $t .]
}


##############################################################################################
# Proc Sixmac
# -----------
# purpose: to take a mac address and add 1 to it, handling rollover
# parameters: aaa, the mac address as a string in the format 255.255.255.255.255.255
# returns: the same string, incremented by 1
#
##############################################################################################
proc sixmac_old_with_bugs { aaa } {
pputs "sixmac"
set 6mac [split $aaa "."]
foreach item $6mac {
  lappend 6mac2 [format %d 0x$item]
}
set 6mac $6mac2
for { set iii 5 } { $iii >= 0 } {incr iii -1} {
  if { $iii == 5 } {
    if { [lindex $6mac $iii] < 255 } {
      set blah [lreplace $6mac $iii $iii [expr [lindex $6mac $iii] + 1]]
      set aaa [join $blah "."]
      break
    } ;#end we are done with the last "mac-tet"
  } elseif { [lindex $6mac $iii] < 255 } {
    set blah [lreplace $6mac $iii $iii [expr [lindex $6mac $iii] + 1]]
    set blah [lreplace $blah 5 5 0]
    set aaa [join $blah "."]
    break
  };#endif we are under 254 and not on last octet ( 3 being last octet!)
} ;#end loop of macs
foreach item [split $aaa .] {
  lappend 6mac3 [format %x $item]
}
return [join $6mac3 .]
};#endproc sixmac


################################################################################
# Proc Hexit
# ----------
# purpose: convert a decimal ip address to hex
# parameters: the ip address in 10.0.0.1 format
# returns: the ip address in 0x0A.0x0.0x0.0x01 format
#
################################################################################
proc hexit { ipadd } {
pputs "hexit"
set ipadd [split $ipadd .]
for { set i 0 } { $i < [llength $ipadd ] } { incr i } {
#if { ![regexp ^0x [lindex $destmac $i]] } {
set ipadd [lreplace $ipadd $i $i 0x[format %02X [lindex $ipadd $i]]]
#}
}
return [join $ipadd .]
}


#############################################################################
# proc makeMcMac
# ---------------------------------------
# purpose: make a valid multicast mac
# parameters: the multicast group
# returns: the multicast mac
# notes:
#############################################################################
proc makeMcMac { grp2 } {
pputs "makeMcMac"
set temp [split $grp2 .]
set temp3 [lreplace $temp 0 0]
set temp4 [format 0x0%x [lindex $temp3 0]]
set temp5 [format 0x0%x [lindex $temp3 1]]
set temp6 [format 0x0%x [lindex $temp3 2]]
set temp2 "0x01.0x00.0x5e.$temp4.$temp5.$temp6"
return $temp2
}

#############################################################################
# proc makesip
# ---------------------------------------
# purpose: make a valid mac address given the hsp, using the hsp
# parameters: hsp
# returns: the mac
# notes:
#############################################################################
proc makesip { params } {
pputs "makesip"
set stuff(numStreams) 5
set stuff(maxArpRetries 2)

eval $bl::macro1
eval $bl::macro2
set retval "[expr $h + 10].$s.$p.2"
return $retval
}

#############################################################################
# proc makegtw
# ---------------------------------------
# purpose: make a valid mac address given the hsp, using the hsp
# parameters: hsp
# returns: the mac
# notes:
#############################################################################
proc makegtw { params } {
pputs "makegtw"

eval $bl::macro1
eval $bl::macro2

set retval "[expr $h + 10].$s.$p.1"
return $retval
}

#############################################################################
# proc makedip
# ---------------------------------------
# purpose: make a valid mac address given the hsp, using the hsp
# parameters: hsp
# returns: the mac
# notes:
#############################################################################
proc makedip { params } {
pputs "makedip"

eval $bl::macro1
eval $bl::macro2
incr h 10
incr p
set retval "$h.$s.$p.2"
return $retval
}

#############################################################################
# proc makemac
# ---------------------------------------
# purpose: make a valid mac address given the hsp, using the hsp
# parameters: hsp
# returns: the mac
# notes:
#############################################################################
proc makemac { params } {
pputs "makemac"
eval $bl::macro1
eval $bl::macro2
incr h 10
#if { $p == 0 } { set p 1 }
set blah "0x00.0x00.0x00.0x$h.0x$s.0x$p"
return $blah
}

#############################################################################
# proc setL3Address
# ---------------------------------------
# purpose: sets the layer3 address on a card.
# parameters: hsp, source mac, source ip, gateway
# returns: nothing
# notes:
#############################################################################
proc setL3Address { h s p smc sip gtw } {
pputs "setL3Address $h/$s/$p $smc $sip $gtw"
vputs "Setting layer3 address for card $h/$s/$p mac:$smc sip:$sip gtw:$gtw"
if { [string first . $smc] > -1 } {
   set smc [split $smc .]
} else  {
   set smc [split $smc :]
}
set realsmc ""
foreach thing $smc {
  set newthing [string trim $thing "0"]
  if { $newthing == "" } { set newthing 0 }
  set newthing [scan $newthing %x]
  lappend realsmc $newthing
}
set smc $realsmc

catch {unset L3Addr}
struct_new L3Addr Layer3Address
set L3Addr(szMACAddress) $smc
set L3Addr(IP) [split $sip .]
set L3Addr(Gateway) [split $gtw .]
set L3Addr(PingTargetAddress) {0 0 0 0}
set L3Addr(Netmask) {0 0 0 0}
set L3Addr(iControl)  0
set L3Addr(iPingTime) 0
set L3Addr(iSNMPTime) 0
set L3Addr(iRIPTime)  0
HTLayer3SetAddress L3Addr $h $s $p
unset L3Addr
}


};#end EtherIP Section



###
# bl57-example.tcl
###

namespace eval bl {


##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
#
# BRETTLIB USAGE EXAMPLE SCRIPT
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################



#############################################################################
# proc basic
# --------------------------
# purpose: a basic 1 pair script example using biglib
#
#############################################################################
proc basic { linkIP h1 s1 p1 h2 s2 p2 { testTimeInSeconds 5 } { bidirectional 0 } } {
pputs "basic"


######################
#
#         config.txt
#         **********
#         Goes with basic.tcl, you could make this a seperate file
#         Uncomment out linkIP, h1,s1,p1 and h2,s2,p2 if calling
#         basic without parameters
#
######################


#General Parameters
#set bidirectional 0                                ;# 0=card1--->card2, 1=card1<--->card2
set multicast 0                                    ;# 0=no multicast, 1=multicast

#set testTimeInSeconds 10                        ;# traffic will run for this amount of time
#set linkIP 10.6.1.37
#set linkIP "10.6.1.32"                             ;# smartbits chassis IP
#set linkIP "10.26.1.62"                            ;# smartbits chassis IP

set filename "results.txt"                         ;# the filename for the results
set delay 2                                        ;# how often to write to the file
set iterations 10                                  ;# the number of iterations to run


############################################
#                 CARD 1                   #
#                                          #
############################################

#Layer1 Parameters
#set h1 0                                           ;# first card h/s/p
#set s1 0
#set p1 0
set cardtype1 GIG-E
set dup1 FULL                                      ;#HALF or FULL
set speed1 100                                     ;#10 or 100

#Layer 2 Parameters
set smc1 0x00.0x00.0x00.0x00.0x00.0x08            ;# the source MAC
set l3smc1 $smc1                                   ;# the "l3 setup" source MAC
set dmc1 0x00.0x00.0x00.0x05.0x05.0x05             ;# the destination MAC address ( ARP overrites anyway )
set dmc1 0x00.0x01.0x30.0xF0.0xBA.0x00             ;# the destination MAC address ( ARP overrites anyway )
#00:01:30:F0:BA:00 is the Summit1i
set smc1msk 0x00.0x00.0x00.0x00.0x03.0x01      ;# set to all zeroes to not increment
set dmc1msk 0x00.0x00.0x00.0x00.0x03.0x01      ;# set to all zeroes to not increment

#Layer 3 Parameters
set sip1 17.1.1.2                                  ;# the source IP address
set l3sip1 $sip1                                   ;# the "l3 setup" source IP address
set msk1 255.255.0.0                               ;# the regular IP mask
set dip1 12.1.1.2                                  ;# the destination IP address
set gtw1 17.1.1.1                                  ;# the gateway
set sip1msk 0.0.0.1                            ;# set to all zeroes to not increment
set dip1msk 0.0.0.1                            ;# set to all zeroes to not increment

#Traffic Parameters
set burst1 51000                                   ;# how many packets to send
set len1 64                                       ;# the packet length
set numStreams1 2                               ;# how many streams ( at least 1 )
set pps1 10                                      ;# the packets per second

#Multicast Parameters
set grp1 224.5.5.5
set mc1Percent 10

############################################
#                                          #
#                                          #
#                 CARD 2                   #
#                                          #
#                                          #
############################################

#Layer 1 Parameters
#set h2 0                                           ;# card 2 h/s/p
#set s2 0
#set p2 1
set cardtype2 GIG-E
set dup2 FULL                                      ;#HALF or FULL
set speed2 100                                    ;#10 or 100

#Layer 2 Parameters
set smc2 0x00.0x00.0x00.0x03.0x03.0x01             ;# the source MAC
set l3smc2 $smc2                                   ;# the "l3 setup" source MAC
set dmc2 0x00.0x00.0x00.0x04.0x04.0x02             ;# the destination MAC address ( ARP overrites anyway )
set smc2msk 0x00.0x00.0x00.0x00.0x03.0x01      ;# set to all zeroes to not increment
set dmc2msk 0x00.0x00.0x00.0x00.0x03.0x01      ;# set to all zeroes to not increment

#Layer 3 Parameters
set sip2 12.1.1.2                                  ;# the source IP address
set l3sip2 $sip2                                   ;# the "l3 setup" source IP address
set msk2 255.255.0.0                               ;# the regular IP mask
set dip2 11.1.1.2                                  ;# the destination IP address
set gtw2 12.1.1.1                                  ;# the gateway
set dip2msk 0.0.0.1                            ;# set to all zeroes to not increment
set sip2msk 0.0.0.1                            ;# set to all zeroes to not increment

#Traffic Parameters
set burst2 10000                                   ;# how many packets to send
set len2 1024                                      ;# the packet length
set numStreams2 2                                 ;# how many streams ( at least 1 )
set pps2 1                                      ;# the packets per second

#Multicast Parameters
set grp2 224.5.5.5
set mc2Percent 10


########### void main(void) #########

qputs "Smartbits Script"
qputs "----------------"
qputs "Opening config.txt"
qputs ""
qputs "General Parameters"
qputs "------------------"
qputs "bidirectional:$bidirectional"
qputs "test time in seconds:$testTimeInSeconds"
qputs "results filename:$filename"
qputs "delay:$delay"
qputs "iterations:10"
qputs "multicast:$multicast"
qputs ""
qputs "( for other test parameters, please see the file config.txt )"
qputs ""
qputs "-------------------------------------------------------------------"
qputs "Opening report file for APPEND..."
qputs ""
set filehandle [open $filename "a+"]
qputs ""
qputs "Linking to Smartbits Chassis on IP: $linkIP"
LINKCMD NSSocketLink $linkIP 16385 $SMB::RESERVE_NONE
qputs [firmwareOneChassis]
doit $h1 $s1 $p1 $dup1 $speed1 $len1 \
     $dmc1 $smc1 $sip1 $dip1 $msk1 $gtw1 \
     $pps1 $burst1 $cardtype1 $numStreams1 \
     $dmc1msk \
     $smc1msk \
     $sip1msk \
     $dip1msk

doit $h2 $s2 $p2 $dup2 $speed2 $len2 \
     $dmc2 $smc2 $sip2 $dip2 $msk2 $gtw2 \
     $pps2 $burst2 $cardtype2 $numStreams2 \
     $dmc2msk \
     $smc2msk \
     $sip2msk \
     $dip2msk

after 1000
qputs [getArpResult $h1 $s1 $p1 $numStreams1]
qputs [getArpResult $h2 $s2 $p2 $numStreams2]
qputs ""
qputs "Enabling SmartMetric: PER-STREAM COUNTERS"
qputs ""
if { $bidirectional } { smartmetricsEnablePktPerStream "h=$h1 s=$s1 p=$p1" }
smartmetricsEnablePktPerStream "h=$h2 s=$s2 p=$p2"
qputs "NOW SENDING PACKETS FOR $testTimeInSeconds seconds..."
qputs "Clearing counters"
bl::check HTClearPort $h1 $s1 $p1
bl::check HTClearPort $h2 $s2 $p2
start $h1 $s1 $p1
if { $bidirectional } { start $h2 $s2 $p2 }
#after [expr 1000 * $testTimeInSeconds]
for { set iii 0 } { $iii < 5 } { incr iii } {
after 1000
#if { $bidirectional } { puts "$h1/$s1/$p1: [simpleSmartmetricsPktPerStream $h1 $s1 $p1]" }
#puts "$h2/$s2/$p2: [simpleSmartmetricsPktPerStream $h2 $s2 $p2]"
}
qputs "Finished, shutting down all generator ports."
stop $h1 $s1 $p1
after 1000
if { $bidirectional } { stop $h2 $s2 $p2 }
if { $bidirectional } { set seq1 [simpleSmartmetricsPktPerStream $h1 $s1 $p1] }
set seq2 [simpleSmartmetricsPktPerStream $h2 $s2 $p2]
qputs "Results"
qputs "-------"
qputs "$h2/$s2/$p2"
qputs "---------"
qputs $seq2
qputs ""
if { $bidirectional } {
qputs "$h1/$s1/$p1"
qputs "----------"
qputs $seq1
}

qputs "Closing socket to $linkIP"
LINKCMD ETUnLink
}



#############################################################################
# proc doit
# --------------------------
# purpose: sets streams and speed and duplex for cards
#############################################################################
proc doit { h s p duplex speed len dmc smc sip dip msk gtw pps burst \
      { cardtype "GIG-E" } \
      { numStreams 1 } \
      { dmcmsk 0x00.0x00.0x00.0x00.0x00.0x01 } \
      { smcmsk 0x00.0x00.0x00.0x00.0x00.0x01 } \
      { sipmsk 0.0.0.1 } \
      { dipmsk 0.0.0.1 } } {
pputs "doit"
qputs ""
qputs "Interface $h/$s/$p"
qputs "*********************"
reserveCard $h $s $p
firmwareOneCard $h $s $p]
resetPort $h $s $p
ethernetLayer1Setup $h $s $p $duplex $speed
streams $h $s $p $numStreams $burst UDP $dmc $smc $sip $dip $gtw $msk $len $pps
setL3Address $h $s $p $smc $sip $gtw
}

#end example section

}



###
# bl57-fiberchannel.tcl
###

namespace eval bl {

###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
#
#
# FIBERCHANNEL FIBER CHANNEL FC FUNCTIONS
# ---------------------------------------
#
#
#
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################

proc setFcPortConfig {H S P fcTopology fcSpeed fcBbcredit } {
  struct_new fcPort  FCPortConfig
  #puts "Enter Topology -> 0 for Point to Point - 1 for Loop"
  set fcPort(ucTopology) $fcTopology
  if {$fcSpeed < 2} {
    set fcSpeed 0x40
  } else {
    set fcSpeed 0x80
  }
  set fcPort(ucSpeed) $fcSpeed
  #puts "Enter BB Credit to advertise"
  set fcPort(uiBBCreditConfigRx) $fcBbcredit
  bl::check  HTSetStructure $SMB::FC_PORT_CONFIG 0 0 0 fcPort 0 $H $S $P
}


proc fcStream { H S P swwn dwwn fcMode classOfService fcFramesize numStreams } {
  set fcLocal   0
  set fcRemote  1
  set cCtl  0
  set rCtl  0
  set fCtl  0
  set csCtl 0
  set dfCtl 0
  set enableSeq 1
  set seqID 1
  set seqCount  0
  set sof   0
  set eof   0
  set fcType  0
  set halfDuplex  0
  set rxID  0
  set oxID  0
  set parameter 0
  set verALPD 1
  set verALPS 1
  set signature 1
  set active  1
  set random  0
  # two WWN wndpoints for each stream
  struct_new  wwnConfig   FCWWN*[expr $numStreams * 2]
  struct_new stream StreamSmartBits*$numStreams
  struct_new  fcHeader  FCConfig*$numStreams

  # Loop through and populate arrays for stream, FC header and WWN endpoints
  for {set i 0} {$i < $numStreams} {incr i} {
    dputs "Configuring stream [expr $i + 1]"
    set stream($i.uiFrameLength)  $fcFramesize
    set stream($i.ucActive)     $active
    set stream($i.ucProtocolType) $SMB::STREAM_PROTOCOL_SMARTBITS
    set stream($i.ucTagField)   $signature
    set stream($i.ucRandomData)   $random
    dputs -nonewline "Setting stream $i Source WWN $swwn and "
    set fcHeader($i.u64SourceWWN.high)    [expr $swwn / 0x010000]
    set fcHeader($i.u64SourceWWN.low)   [expr $swwn & 0x0FFFF]
    dputs "Dest WWN $dwwn"
    set fcHeader($i.u64DestWWN.high)    [expr $dwwn / 0x010000]
    set fcHeader($i.u64DestWWN.low)     [expr $dwwn & 0x0FFFF]
    set fcHeader($i.ucCOS) $classOfService
    set fcHeader($i.ucR_CTL)     $rCtl
    set fcHeader($i.ulF_CTL)     $fCtl
    set fcHeader($i.uiCS_CTL)    $csCtl
    set fcHeader($i.ucDF_CTL)    $dfCtl
    set fcHeader($i.ucEnableSeqCnt)  $enableSeq
    set fcHeader($i.ucHalfDuplex)  $halfDuplex
    set fcHeader($i.ucVerifyAL_PD)   $verALPD
    set fcHeader($i.ucVerifyAL_PS)   $verALPS
    set fcHeader($i.ulSOF)       $sof
    set fcHeader($i.ucFCType)    $fcType
    set fcHeader($i.uiSeqCnt)    $seqCount
    set fcHeader($i.uiOX_ID)     $oxID
    set fcHeader($i.uiRX_ID)     $rxID
    set fcHeader($i.ulParameter)   $parameter
    set fcHeader($i.ulEOF)       $eof
    set fcHeader($i.ucSeqID)     $seqID
    if {$fcHeader($i.ucCOS) == 3} {
       set wwnCos 1
    }
    # Create ENDPOINTS - first the source (LOCAL) WWN is source UcRemote = local (0)
    set pMode $fcMode
    set wwnConfig([expr $i * 2].u64WWN.high)    [expr $swwn / 0x10000]
    set wwnConfig([expr $i * 2].u64WWN.low)     [expr $swwn & 0x0FFFF]
    set wwnConfig([expr $i * 2].ucRemote)     $fcLocal
    set wwnConfig([expr $i * 2].ucSupportedCOS)   $wwnCos
    set wwnConfig([expr $i * 2].ucResponseCOS)    $wwnCos
    set wwnConfig([expr $i * 2].ucPublic)     $pMode
    # second create the opposite (REMOTE) ENDPOINT WWN is source UcRemote = local (0)
    set wwnConfig([expr ($i * 2) + 1].u64WWN.high)    [expr $dwwn / 0x10000]
    set wwnConfig([expr ($i * 2) + 1].u64WWN.low)   [expr $dwwn & 0x0FFFF]
    set wwnConfig([expr ($i * 2) + 1].ucRemote)     $fcRemote
    set wwnConfig([expr ($i * 2) + 1].ucSupportedCOS) $wwnCos
    set wwnConfig([expr ($i * 2) + 1].ucResponseCOS)  $wwnCos
    set wwnConfig([expr ($i * 2) + 1].ucPublic)     $pMode
    # increment the WWNs for automode
    incr swwn
    incr dwwn
  };#end for each stream

  # Now we send the three arrays to each of the configuring functions
  dputs "Configuring $numStreams FC Headers"
  bl::check HTSetStructure $SMB::FC_WWN 0 0 0 wwnConfig  0 $H $S $P
  bl::check HTSetStructure $SMB::L3_DEFINE_SMARTBITS_STREAM 0 0 0 stream 0 $H $S $P
  bl::check HTSetStructure $SMB::FC_DEFINE_HEADER 0 0 0 fcHeader 0 $H $S $P
};# eop fcStream


proc fcLink {H S P} {

set maxLinkWait 5
set linkWait 0

bl::check HTSetCommand $SMB::FC_LINKUP 0 0 0 "" $H $S $P
after 500
struct_new status  FCStatus
bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
while {! [expr ($status(ulState) & 0x04)]} {
  after 500
  bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
  incr linkWait 1
  if {$linkWait > $maxLinkWait} {
    dputs "\nERROR $H $S $P DID NOT LINK!!  STATUS ==> 0x[format %X $status(ulState)]\n"
    #showPortStatus $H $S $P
    break
  }
}
}


proc fcDiscoverPrivate {H S P} {

set maxLinkWait 5
bl::check  HTSetCommand $SMB::FC_PRIVATE_DISCOVERY 0 0 0 "" $H $S $P
after 500
set linkWait 0
struct_new status  FCStatus
bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
while {! [expr ($status(ulState) & $SMB::PORT_PRIVATE_DISCOVERY_COMPLETE)]} {
  after 500
  bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
  incr linkWait 1
  if {$linkWait > $maxLinkWait} {
  dputs "\nERROR $H $S $P DISCOVERY TIMEOUT!! STATUS ==> 0x[format %X $status(ulState)]\n"
  #showPortStatus $H $S $P
  break
  }
}
}


proc discoverFCPub {H S P} {
set maxLinkWait 5
bl::check  HTSetCommand $SMB::FCPUBLICDISCOVERY  0 0 0 "" $H $S $P
after 500
set linkWait 0
struct_new status  FCStatus
bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
while {[expr (! $status(ulState) & $SMB::PORTPUBLICDISCOVERYCOMPLETE)]} {
  after 500
  bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
  incr linkWait 1
  if {$linkWait > $maxLinkWait} {
    dputs "\nERROR $H $S $P DISCOVERY TIMEOUT!!  STATUS ==> 0x[format %X $status(ulState)]\n"
    #showPortStatus $H $S $P
    break
  }
}
}


proc fcLogin {H S P} {
  bl::check HTSetCommand $SMB::FC_WWN_LOGIN 0 0 0 "" $H $S $P
}

proc fcCommit {H S P} {

  set maxLinkWait 10
  bl::check  HTSetCommand $SMB::FC_COMMIT   0 0 0 "" $H $S $P
  after 500
  set linkWait 0
  struct_new status  FCStatus
  bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
  while  {! [expr ($status(ulState) & 0x200)]} {
    after 500
    bl::check  HTGetStructure $SMB::FC_STATUS_INFO 0 0 0 status 0 $H $S $P
    incr linkWait 1
    if {$linkWait > $maxLinkWait} {
      dputs "\nERROR $H $S $P READY TO TEST TIMEOUT!!  STATUS ==> 0x[format %X $status(ulState)]\n"
      #showPortStatus $H $S $P
      break
    }
  }
}



#end fiber chann section
}



###
# bl57-gap.tcl
###

namespace eval bl {

##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# GAP FUNCTIONS
# ----------------
# This sections contains function to calculate the gap for HTGap and HTGapAndScale commands
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################

###############################################################################
# NSFCFPSToGap
#
# Description: Calculates the Fibre Channel gap for a specified frame rate.
# Parameters:
#   speed - Can be SPEED_1GHZ (0x0040) or SPEED_2GHZ (0x0080)
#   framesize - Without the CRC, but including the SOF and EOF.
#   fps - The desired frames per second.
# Returns:
#   Gap bits. Can also be considered to be gap in nanoseconds.
#
###############################################################################
proc NSFCFPSToGap { speed framesize fps } {
    set CRC_BITS 32

    # Process the input parameterss.
    switch $speed {
        0x0040 { set available_bw [format %.1f [expr 1062500000.0 * 8.0 / 10.0]] }
        0x0080 { set available_bw [format %.1f [expr 2125000000.0 * 8.0 / 10.0]] }
        default { return "-1" }
    }
    set fps [format %.1f $fps]          ;# Turn fps into a floating point number.
    set data_bits      [expr $framesize * 8.0]

    set total_bits     [expr ($data_bits + $CRC_BITS) * $fps]
    set total_gap_bits [expr $available_bw - $total_bits]
    set gap            [format %.0f [expr $total_gap_bits / $fps]]

    # The smallest allowable gap is 96 bits.
    # The smallest legal gap is 192 bits, but the hardware is capable
    # of trasmitting at faster than linerate.
    if { $gap < 96 } { set gap 96 }
    return $gap
}

###############################################################################
# NSFCLoadToGap
#
# Description: Calculates the Fibre Channel gap for a specified utilization.
# Parameters:
#   speed - Can be SPEED_1GHZ (0x0040) or SPEED_2GHZ (0x0080)
#   framesize - Without the CRC, but including the SOF and EOF.
#   load - The desired utilization in percent. NOTE: The hardware supports
#          loads greater than 100%.
# Returns:
#   Gap bits. Can also be considered to be gap in nanoseconds.
#   This value can be plugged directly into the HTGap command.
#
###############################################################################
proc NSFCLoadToGap { speed framesize load } {
    set CRC_BITS     32
    set MIN_IFG_BITS 192

    # Process the input parameters.
    switch $speed {
        0x0040 { set available_bw [format %.1f [expr 1062500000 * 8.0 / 10.0]] }
        0x0080 { set available_bw [format %.1f [expr 2125000000 * 8.0 / 10.0]] }
        default { return "-1" }
    }
    set data_bits    [expr $framesize * 8.0]

    set max_fps     [expr $available_bw / ($data_bits + $CRC_BITS + $MIN_IFG_BITS)]
    set desired_fps [expr $max_fps * $load / 100.0]

    # This command is only to set a global variable so I know what the FPS of the test is.
    set ::fps $desired_fps

    set gap         [NSFCFPSToGap $speed $framesize $desired_fps]
    return $gap
}



#PPS = wire rate in b/s / packet size in bits
#For Fe, min packet , it is 148809.
#Calc: 64B(Min Ether Packet)+(8B for preamble )+(12B for Gap)=672b
#100Mb/s/672b/p=148809pps.
# Brett-Documenation
#
# Proc gapNanoseconds
# --------------------
# purpose: to return the gap in nanoseconds for ethernet, given the load (% of linerate)
#          requires the function "round"
# parameters: the %load as a real number
# returns: the gap in nanoseconds
#
##############################################################################################
proc gapNanoseconds { load } {
pputs "gapNanoseconds"
set maxFastEFramerate 148810  ;#Legal limit of fast-e frames/s
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set crcBytes 4                  ;#this is the crc bytes for all ethernet types
set preambleBits 64             ;#For all ethernet types, this is the preamble bits
set fastEBits 100000000        ;#b/s for fast-e
set linerateBits $fastEBits   ;#just some indirection
set minGapBits 96              ;#All ethernet flavours, 96 bits!
set frameBytes 60               ;#Minimum legal Ethernet frame size ( without the CRC)
#the next few lines do some math to derive the gap in microseconds
set totalLengthBits [expr 8*($frameBytes + $crcBytes)+$preambleBits]
set maxFramesPerSec [round [expr $linerateBits.0/($totalLengthBits + $minGapBits)]]
set gapBits [round [expr ($linerateBits/($maxFramesPerSec * $load / 100.0 )) - $totalLengthBits]]
set gapNano [expr ($nano * $gapBits)/$linerateBits.0]
return $gapNano
}



#
# This function returns the GAP in MICROSECONDS to use
# with the HTSetGapAndScale function later on in
# the program.  It is tested good.
#
proc gapMicro { maxBps packsize pps } {
pputs "gapMicro"
set preamble 8.0
set overhead  [expr $preamble * 8.0]
set databits  [expr $packsize * 8.0]
set totalbits [expr $overhead + $databits]
set rawgap    [expr $maxBps / $pps ]
set gapbits   [expr ($rawgap - $totalbits) * 1000000 ]
set gap       [expr $gapbits  / $maxBps ]
return $gap
}


##############################################################################################
# Brett-Documenation
#
# Proc gapBits
# -----------
# purpose: Tested accurate! to return the gap in bits
# parameters: the %load as a real number
# returns: the gap in bits
#
##############################################################################################
proc gapBitsFromPercent { load } {
pputs "gapBitsFromPercent"
set maxFastEFramerate 148810  ;#Legal limit of fast-e frames/s
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set crcBytes 4                  ;#this is the crc bytes for all ethernet types
set preambleBits 64             ;#For all ethernet types, this is the preamble bits
set fastEBits 100000000        ;#b/s for fast-e
set linerateBits $fastEBits   ;#just some indirection
set minGapBits 96              ;#All ethernet flavours, 96 bits!
set frameBytes 60
#Larocca Method
set frameBytes [expr $frameBytes + 4]
set gapInBytes [expr int([expr (($frameBytes + 20)/($load / 100.0))-$frameBytes-8])]
set gapInBits [expr int([expr $gapInBytes * 8])]
#set gapNano [expr ($gapInBits * $nano)/$linerateBits.0]
return $gapBits
}

##############################################################################################
# Brett-Documenation
#
# Proc gapNanoFromBits
# -----------
# purpose: Tested Accurate!
#          Return the gap in nanoseconds for ethernet, given the load (% of linerate)
#          this one uses a shorter, possibly more accurate method than gapNanoseconds
# parameters: the %load as a real number
# returns: the gap in nanoseconds
#
##############################################################################################
proc gapNanoFromPercent { load } {
pputs "gapNanoFromPercent"
#Larocca Method
set frameBytes [expr $frameBytes + 4]
set gapInBytes [expr int([expr (($frameBytes + 20)/($load / 100.0))-$frameBytes-8])]
set gapInBits [expr int([expr $gapInBytes * 8])]
set gapNano [expr ($gapInBits * $nano)/$linerateBits.0]
return $gapNano
}

proc pps { params } { setPps $params }

#############################################################################
# proc setPps
# --------------------------
# purpose: Accurate!
#          set the pps using the HTGap command. Works for 10/100/1000 Ethernet.
# usage: setPps $h $s $p 1000 128 1000
# returns:  nothing
#############################################################################
proc setPps { params } {
pputs "setPps"
set stuff(speed) 10000000
set stuff(len) 64
set stuff(pps) 1000
set stuff(percent) 100

eval $bl::macro1
eval $bl::macro2
set preamble 8.0
set overheadbitswithoutgap [expr $preamble * 8.0]
set databits [expr $len * 8.0]
set linerateslashpps [expr $speed / $pps]
set totalbits [expr $databits + $overheadbitswithoutgap]
set gap [expr $linerateslashpps - $totalbits]
udputs "setPps, $h/$s/$p wirerate:$speed packsize:$len pps:$pps gap:$gap"
set nanogap [expr $gap * 10]
#bl::check HTGapAndScale $nanogap $SMB::NANOSCALE $h $s $p
if { $gap < 0 } {
  return -1
}
return [HTGap $gap $h $s $p]
}



proc percentLineRate { params } {
pputs "percentLineRate $params"
set stuff(speed) 10000000
set stuff(len) 64
set stuff(pps) 1000
set stuff(percent) 100

eval $bl::macro1
eval $bl::macro2
set gap ""
switch [expr $speed/1000000] {
  10 { set speed $SMB::SPEED_10MHZ }
  100 { set speed $SMB::SPEED_100MHZ }
  1000 { set speed $SMB::SPEED_1GHZ }
  10000 { set speed $SMB::SPEED_10GHZ }
}
dputs speed:$speed
dputs len:$len
dputs percent:$percent
NSCalculateGap $SMB::PERCENT_LOAD_TO_GAP_BITS $speed $len $percent gap $h $s $p
dputs gap:$gap
bl::check HTGap $gap $h $s $p
}

proc getEtherPpsFromGap { gap wirerate len } {
if { $wirerate == $SMB::SPEED_10MHZ } {
  set wirerate 10000000
} elseif { $wirerate == $SMB::SPEED_100MHZ } {
  set wirerate 100000000
} elseif { $wirerate == $SMB::SPEED_1GHZ } {
  set wirerate 1000000000
} elseif { $wirerate == $SMB::SPEED_10GHZ } {
  set wirerate 10000000000.0
}
set preamble [expr 8 * 8]
incr len 4
#set gap [expr $gap * ($nano / $wirerate.0) ]
set databits [expr $len * 8.0]
set totalbits [expr $preamble + $databits + $gap]
#puts totalbits:$totalbits
#puts wirerate:$wirerate
#puts [expr $wirerate / int($totalbits)]
#exit
set pps [expr int($wirerate / $totalbits)]
#dputs "PPS=$pps totalbits=$totalbits len=$len gap=$gap speed=$wirerate"
return $pps
}

proc getEtherPercentFromGap { gap wirerate len } {
#NOTE: enter len with crc
if { 0 } {
   if { $wirerate == $SMB::SPEED_10MHZ } {
  set wirerate 10000000
} elseif { $wirerate == $SMB::SPEED_100MHZ } {
  set wirerate 100000000
} elseif { $wirerate == $SMB::SPEED_1GHZ } {
  set wirerate 1000000000
} elseif { $wirerate == $SMB::SPEED_10GHZ } {
  set wirerate 10000000000
}
}
set preamble [expr 8 * 8]
#incr len 4
#set gap [expr $gap * ($nano / $wirerate.0) ]
set databits   [expr $len * 8]
set totalbits  [expr ($preamble + $databits + $gap) / 1.0 ]
set wtotalbits [expr ($preamble + $databits + 96) / 1.0 ]
#puts totalbits:$totalbits
#puts wirerate:$wirerate
#puts [expr $wirerate / int($totalbits)]
#exit
set pps  [expr $wirerate / $totalbits  ]
set wpps [expr $wirerate / $wtotalbits ]
set percent [expr 100 * ($pps / $wpps)]
#dputs "PPS=$pps totalbits=$totalbits len=$len gap=$gap speed=$wirerate"
return $percent
}


proc getEtherGapFromPercent { percent wirerate len } {
pputs "gap_bits_from_percent"
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set preamble_bits 64             ;#For all ethernet types, this is the preamble bits
set min_gap_bits 96              ;#All ethernet flavours, 96 bits!
if { $wirerate == $SMB::SPEED_10MHZ } {
  set wirerate 10000000
} elseif { $wirerate == $SMB::SPEED_100MHZ } {
  set wirerate 100000000
} elseif { $wirerate == $SMB::SPEED_1GHZ } {
  set wirerate 1000000000
} elseif { $wirerate == $SMB::SPEED_10GHZ } {
  set wirerate 10000000000
}
#set len [expr $len + 4]
incr len 4
set gap_in_bytes [expr int([expr (($len + 20)/($percent / 100.0))-$len-8])]
set gap_in_bits [expr int([expr $gap_in_bytes * 8])]
#set gap_nano [expr ($gap_in_bits * $nano)/$wirerate.0]
dputs "CalcGap: percent=$percent speed=$wirerate len=$len gap=$gap_in_bits"
return $gap_in_bits
}

proc getEtherGapFromPps { pps wirerate len } {
if { $wirerate == $SMB::SPEED_10MHZ } {
  set wirerate 10000000
} elseif { $wirerate == $SMB::SPEED_100MHZ } {
  set wirerate 100000000
} elseif { $wirerate == $SMB::SPEED_1GHZ } {
  set wirerate 1000000000
} elseif { $wirerate == $SMB::SPEED_10GHZ } {
  set wirerate 10000000000
}
set preamble 8.0
incr len 4
set overheadbitswithoutgap [expr $preamble * 8.0]
set databits [expr $len * 8.0]
set linerateslashpps [expr $wirerate / $pps]
set totalbits [expr $databits + $overheadbitswithoutgap]
set gap [expr $linerateslashpps - $totalbits]
return $gap
}



proc getPosPpsFromPercent { percent cardmodel len crc_len } {
set pos_ratio [expr 1040.0/1080.0]
switch $cardmodel {
  "POS-6500" -
  "POS-3500" {
    set Mbps [expr 12 * 51.84]
  }
  "POS-6505" -
  "POS-3505" -
  "POS-6504" -
  "POS-3504" {
    set Mbps [expr 48 * 51.84]
  }
  "POS-3518" -
  "POS-3519" {
    set Mbps [expr 192 * 51.84]
  }
}
set Mbps [expr $Mbps * 1000000]
set use1 [expr $pos_ratio * $Mbps]
set use2 [expr $use1 / 8.0]
set top [expr ($percent * $use2) / 100.0 ]
set bottom [expr $len + $crc_len + 1]
set pps [expr int($top / $bottom.0)]
dputs "pps:$pps %:$percent len:$len crc_len:$crc_len posr:$pos_ratio Mbps:$Mbps use1:$use1"
return $pps
}

proc gapNanoseconds { load } {
pputs "gap_nanoseconds"
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set crc_bytes 4                  ;#this is the crc bytes for all ethernet types
set preamble_bits 64             ;#For all ethernet types, this is the preamble bits
set fast_e_bits 100000000        ;#b/s for fast-e
set linerate_bits $fast_e_bits   ;#just some indirection
set min_gap_bits 96              ;#All ethernet flavours, 96 bits!
set frame_bytes 60               ;#Minimum legal Ethernet frame size ( without the CRC)
#the next few lines do some math to derive the gap in microseconds
set total_length_bits [expr 8*($frame_bytes + $crc_bytes)+$preamble_bits]
set max_frames_per_sec [round [expr $linerate_bits.0/($total_length_bits + $min_gap_bits)]]
set gap_bits [round [expr ($linerate_bits/($max_frames_per_sec * $load / 100.0 )) - $total_length_bits]]
set gap_nano [expr ($nano * $gap_bits)/$linerate_bits.0]
return $gap_nano
}

proc setGapFromPercent { percent speed len h s p } {
#iSpeed Input parameter can be one of the speed constants:
#SPEED_10GHZ
#SPEED_1GHZ
#SPEED_100MHZ
#SPEED_10MHZ
set gap 0
wsLIBCMD NSCalculateGap $SMB::PERCENT_LOAD_TO_GAP_BITS $speed $len $percent gap $h $s $p
#ulPacketLength is (excluding Preamble and CRC)
#Comments Does not apply to POS, ATM, or WAN cards.
#Example:
#int iMode = PERCENT_LOAD_TO_GAP_BITS
#int iSpeed = SPEED_10GHZ
#unsigned long ulPacketLength = 100
#double dValue = 95.5
#unsigned long ulGap = 0;
#NSCalculateGap(iMode,iSpeed,dValue,&ulGap,iHub,iSlot,iPort);
#HTGap(ulGap, iHub, iSlot, iPort);
wsLIBCMD HTGap $gap $h $s $p
}

#end gap section
}



###
# bl57-igmp.tcl
###

namespace eval bl {




###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
#
#
# IGMP FUNCTIONS
# --------------
#
#
#
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################


#############################################################################
# proc IGMPJoin (from Dan Acheff & Alex Karstens)
# --------------------------
# purpose: join a group
# parameters:  the hsp and the group
# returns:  nothing
#############################################################################
proc IGMPJoin { h s p grp } {
pputs "IGMPJoin"
if { $bl::ONEBASEDHSP } {set h [minus $h]; set s [minus $s]; set p [minus $p]}
catch {unset Join}
struct_new Join Layer3IGMPJoin
set Join(ucIPAddress) [split $grp .]
bl::check HTSetCommand $SMB::L3_IGMP_JOIN 0 0 0 Join $h $s $p
set Join(ucIPAddress) [split $grp .]
bl::check HTSetCommand $SMB::L3_IGMP_JOIN 0 0 0 Join $h $s $p
unset Join
}



#############################################################################
# proc IGMPCounts (from Dan Acheff & Alex Karstens)
# --------------------------
# purpose: show igmp counters
# parameters:  the hsp
# returns:  nothing
#############################################################################
proc IGMPCounts {h s p} {
pputs "IGMPCounts"
eval $bl::macro2


struct_new igmpCounters Layer3MulticastCounters
PP "$h/$s/$p IGMP Counters"
PP "-------------------"
bl::check HTGetStructure $SMB::L3_MULTICAST_COUNTER_INFO 0 0 0 igmpCounters 0 $h $s $p
PP "   TxFrames       :   $igmpCounters(ulTxFrames)"
PP "   TxJoinGrps     :   $igmpCounters(ulTxJoinGroups)"
PP "   TxLeaveGrps    :   $igmpCounters(ulTxLeaveGroups)"
PP "   RxFrames       :   $igmpCounters(ulRxFrames)"
PP "   RxUnknown      :   $igmpCounters(ulRxUnknownType)"
PP "   RxIPChkSumErr  :   $igmpCounters(ulRxIpChecksumErrors)"
PP "   RxIGMPChkSumErr:   $igmpCounters(ulRxIgmpChecksumErrors)"
PP "   RxIGMPLngthErr :   $igmpCounters(ulRxIgmpLengthErrors)"
PP "   RxWrongVerQuer :   $igmpCounters(ulRxWrongVersionQueries)"
PP ""
#PP "\n Press ENTER to continue"
#gets stdin response
}

#############################################################################
# proc IGMPInit (from Dan Acheff & Alex Karstens)
# --------------------------
# purpose: clear out the IGMP status on an interface.  use it before setting any IGMP.
# parameters:  the hsp
# returns:  nothing
#############################################################################
proc IGMPInit { params } {
pputs "IGMPInit"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
catch {unset Init}
struct_new Init Layer3IGMPInit
set Init(ucVersion)  2
set Init(uiMaxGroups) 2
bl::check HTSetCommand $SMB::L3_IGMP_INIT 0 0 0 Init $h $s $p
unset Init
}
}

#end IGMP section

}


###
# bl57-layer1.tcl
###

namespace eval bl {


##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# LAYER 1 FUNCTIONS
# ---------------------------------------
# This section contains function set up speed, duplex on ethernet, and eventually clocking
# on POS and ATM cards.
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
proc copperfiber { params } { fibercopper $params }
proc fibercopper {params } {
  set stuff(media) copper
  struct_new phyConfig NSPhyConfig
  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    switch [string tolower $media] {
      c -
      copper {
        set phyConfig(ucActiveMedia) $SMB::COPPER_MODE
      }
      f -
      fiber {
        set phyConfig(ucActiveMedia) $SMB::FIBER_MODE
      }
    }
    if { [string first "332" $bl::info(pure.$port.cardmodel)] > -1 } {
      bl::check HTSetStructure $SMB::NS_PHY_CONFIG 0 0 0 phyConfig 0 $h $s $p
      after 1000
    }
  }
}


proc duplex { params } {
set stuff(duplex) full
eval $bl::macro1

foreach port $ports {
  eval $bl::macro2
  switch [string tolower $duplex] {
    "f" -
    "full" {
      bl::check HTDuplexMode $SMB::FULLDUPLEX_MODE $h $s $p
    }
    "h" -
    "half" {
      bl::check HTDuplexMode $SMB::HALFDUPLEX_MODE $h $s $p
    }
  }
}
}

proc speed { params } {
set stuff(speed) 100

eval $bl::macro1
  foreach port $ports {
  eval $bl::macro2
  switch [string tolower $speed] {
    "1g" -
    "1gig" -
    "gig" -
    "1000" {
      bl::check HTSetSpeed $SMB::SPEED_1GHZ $h $s $p
    }
    "1hundred" -
    "hundred" -
    "100" {
      bl::check HTSetSpeed $SMB::SPEED_100MHZ $h $s $p
    }
    "ten" -
    "10" {
      bl::check HTSetSpeed $SMB::SPEED_10MHZ $h $s $p
    }
  }
}
}

#############################################################################
# proc ethernetSpeedAndDuplex
# ---------------------------------------
# usage: ethernetSpeedAndDuplex 100FULL 0 0 0
#############################################################################
proc ethernetSpeedAndDuplex { params } {
pputs "ethernetSpeedAndDuplex"
set stuff(param) 100FULL

eval $bl::macro1
eval $bl::macro2
  vputs "ethernetSpeedAndDuplex $params"
  switch $param {
    "100FULL" {
      bl::check HTDuplexMode $SMB::FULL_DUPLEX_MODE $h $s $p
      bl::check HTSetSpeed $SMB::SPEED_100MHZ $h $s $p
    }
    "100HALF" {
      bl::check HTDuplexMode $SMB::HALF_DUPLEX_MODE $h $s $p
      bl::check HTSetSpeed $SMB::SPEED_100MHZ $h $s $p
    }
    "10FULL" {
      bl::check HTDuplexMode $SMB::FULL_DUPLEX_MODE $h $s $p
      bl::check HTSetSpeed $SMB::SPEED_10MHZ $h $s $p
    }
    "10HALF" {
      bl::check HTDuplexMode $SMB::HALF_DUPLEX_MODE $h $s $p
      bl::check HTSetSpeed $SMB::SPEED_10MHZ $h $s $p
    }
  }
}

#############################################################################
# proc layer1Setup
# ---------------------------------------
# purpose: set up 10/100 full/half or do the autoneg thing for our gig cards
# parameters: hsp duplex speed
# returns: nothing
# notes:
#############################################################################
proc layer1Setup { params } { ethernetLayer1Setup $params }

proc ethernetLayer1Setup { params } {
pputs "ethernetLayer1Setup"
set stuff(duplex) F
set stuff(speed) 100

eval $bl::macro1
  foreach port $ports {
  eval $bl::macro2
    vputs "Layer 1   $h/$s/$p $params"
    if { $speed == 10 } {
      bl::check HTSetSpeed $SMB::SPEED_10MHZ $h $s $p
    } elseif { $speed == 100 } {
      bl::check HTSetSpeed $SMB::SPEED_100MHZ $h $s $p
    }

    if { $speed != 1000 } {
      if { [string toupper $duplex] == "F" } {
        bl::check HTDuplexMode $SMB::FULL_DUPLEX_MODE $h $s $p
      } elseif { [string toupper $duplex] == "H" } {
        bl::check HTDuplexMode $SMB::HALF_DUPLEX_MODE $h $s $p
      }
    }

    if { $speed== 1000 } {
      bl::check HTSetStructure $SMB::GIG_STRUC_AUTO_FIBER_NEGOTIATE 0 0 0 "" 0 $h $s $p \
      -ucMode 1 \
      -ucRestart 1 \
      -uiLinkConfiguration 0 \
      -ucEnableCCode 0
    }
}
}

proc gigAuto { params  } { gigauto $params }

proc gigauto { params } {
pputs "gigauto $params"
set stuff(restart) 1
set stuff(auto) 1
set stuff(pause) 0
set stuff(linkconfig) 0
set stuff(enableCCode) 0
set stuff(prelen) 8
struct_new ggggg GIGAutoFiberNegotiate
struct_new gt GIGTransmit

eval $bl::macro1
foreach port $ports {
  eval $bl::macro2
    bl::vputs "Setting GigaBit autonegotiation $h/$s/$p auto=$auto restart=$restart pause=$pause"
    set ggggg(ucMode) $auto
    set ggggg(ucRestart) $restart
    set ggggg(uiLinkConfiguration) $linkconfig
    set ggggg(ucEnableCCode) $enableCCode
    set ggggg(ucPreambleLen) $prelen
    set ggggg(ucEnableHoldoff) $pause
    bl::check HTSetStructure $SMB::GIG_STRUC_AUTO_FIBER_NEGOTIATE 0 0 0 ggggg 0 $h $s $p

    set gt(uiLinkConfiguration) 0x0020
    bl::check HTSetStructure $SMB::GIG_STRUC_TX 0 0 0 gt 0 $h $s $p


#        bl::check HTSetStructure $SMB::GIG_STRUC_TX 0 0 0 - 0 $h $s $p \
#        -ucPreambleByteLength 8 \
#        -uiLinkConfiguration 0x20
}
}

#end Layer1 section

}



###
# bl57-link.tcl
###


namespace eval bl {


########### CARD INFO ############


############# ATM #############
############# ATM #############
############# ATM #############

set CARDS(AT-9015.technology) ATMT1
set CARDS(AT-9015.cable) RJ48
set CARDS(AT-9015.streams) Trad.
set CARDS(AT-9015.chassis) SMB2000
set CARDS(AT-9015.flavour) Streams
set CARDS(AT-9015.portsPerSlot) 1
set CARDS(AT-9015.slotsPerChassis) 20
set CARDS(AT-9015.slotsPerSlot) 1
set CARDS(AT-9015.layer4-7) none

set CARDS(AT-9020.technology) ATME1
set CARDS(AT-9020.cable) RJ48
set CARDS(AT-9020.streams) Trad.
set CARDS(AT-9020.chassis) SMB2000
set CARDS(AT-9020.flavour) Streams
set CARDS(AT-9020.portsPerSlot) 1
set CARDS(AT-9020.slotsPerChassis) 20
set CARDS(AT-9020.slotsPerSlot) 1
set CARDS(AT-9020.layer4-7) none

set CARDS(AT-9622.technology) ATM-OC12
set CARDS(AT-9622.cable) SM/MM
set CARDS(AT-9622.streams) Trad.
set CARDS(AT-9622.chassis) SMB2000
set CARDS(AT-9622.flavour) Non-Streaming
set CARDS(AT-9622.portsPerSlot) 1
set CARDS(AT-9622.slotsPerChassis) 10
set CARDS(AT-9622.slotsPerSlot) 2
set CARDS(AT-9622.layer4-7) none


set CARDS(AT-9155.technology) ATMOC3-1
set CARDS(AT-9155.cable) SM/MM
set CARDS(AT-9155.streams) Trad1
set CARDS(AT-9155.chassis) SMB2000
set CARDS(AT-9155.flavour) ATMType1
set CARDS(AT-9155.portsPerSlot) 1
set CARDS(AT-9155.slotsPerChassis) 10
set CARDS(AT-9155.slotsPerSlot) 2
set CARDS(AT-9155.layer4-7) none

set CARDS(AT-9155C.technology) ATM-OC3
set CARDS(AT-9155C.cable) SM/MM
set CARDS(AT-9155C.streams) Trad.
set CARDS(AT-9155C.chassis) SMB2000
set CARDS(AT-9155C.flavour) Non-Stream
set CARDS(AT-9155C.portsPerSlot) 1
set CARDS(AT-9155C.slotsPerChassis) 10
set CARDS(AT-9155C.slotsPerSlot) 2
set CARDS(AT-9155C.layer4-7) none

set CARDS(AT-3453A.technology) ATM-OC3/12
set CARDS(AT-3453A.cable) SM/MM
set CARDS(AT-3453A.streams) Smart
set CARDS(AT-3453A.chassis) SMB6000
set CARDS(AT-3453A.flavour) Streams
set CARDS(AT-3453A.portsPerSlot) 2
set CARDS(AT-3453A.slotsPerChassis) 12
set CARDS(AT-3453A.slotsPerSlot) 1
set CARDS(AT-3453A.layer4-7) Maybe


set CARDS(AT-3451A.technology) ATM-OC3
set CARDS(AT-3451A.cable) SM/MM
set CARDS(AT-3451A.streams) Smart
set CARDS(AT-3451A.chassis) SMB6000
set CARDS(AT-3451A.flavour) Streams
set CARDS(AT-3451A.portsPerSlot) 2
set CARDS(AT-3451A.slotsPerChassis) 12
set CARDS(AT-3451A.slotsPerSlot) 1
set CARDS(AT-3451A.layer4-7) Maybe

############ WAN ###########
############ WAN ###########
############ WAN ###########

set CARDS(WN-3415.technology) F/R
set CARDS(WN-3415.cable) CAT5
set CARDS(WN-3415.streams) Trad.
set CARDS(WN-3415.chassis) SMB2000
set CARDS(WN-3415.flavour) Non-Streaming
set CARDS(WN-3415.portsPerSlot) 1
set CARDS(WN-3415.slotsPerChassis) 10
set CARDS(WN-3415.slotsPerSlot) 2
set CARDS(WN-3415.layer4-7) none

set CARDS(WN-3445.technology) F/R/PPP
set CARDS(WN-3445.cable) COAX
set CARDS(WN-3445.streams) Smart
set CARDS(WN-3445.chassis) SMB2000
set CARDS(WN-3445.flavour) Streaming
set CARDS(WN-3445.portsPerSlot) 1
set CARDS(WN-3445.slotsPerChassis) 10
set CARDS(WN-3445.slotsPerSlot) 2
set CARDS(WN-3445.layer4-7) none

########### FIBBER CHANNEL #######

set CARDS(FBC-3601.technology) FC-1
set CARDS(FBC-3601.cable) GBIC
set CARDS(FBC-3601.streams) Smart
set CARDS(FBC-3601.chassis) SMB6000
set CARDS(FBC-3601.flavour) SmartMetrics
set CARDS(FBC-3601.portsPerSlot) 2
set CARDS(FBC-3601.slotsPerChassis) 12
set CARDS(FBC-3601.slotsPerSlot) 1
set CARDS(FBC-3601.layer4-7) none

set CARDS(FBC-3601A.technology) FC-1
set CARDS(FBC-3601A.cable) GBIC
set CARDS(FBC-3601A.streams) Smart
set CARDS(FBC-3601A.chassis) SMB6000
set CARDS(FBC-3601A.flavour) SmartMetrics
set CARDS(FBC-3601A.portsPerSlot) 2
set CARDS(FBC-3601A.slotsPerChassis) 12
set CARDS(FBC-3601A.slotsPerSlot) 1
set CARDS(FBC-3601A.layer4-7) none

set CARDS(FBC-3602A.technology) FC-2
set CARDS(FBC-3602A.cable) GBIC
set CARDS(FBC-3602A.streams) Smart
set CARDS(FBC-3602A.chassis) SMB6000
set CARDS(FBC-3602A.flavour) SmartMetrics
set CARDS(FBC-3602A.portsPerSlot) 2
set CARDS(FBC-3602A.slotsPerChassis) 12
set CARDS(FBC-3602A.slotsPerSlot) 1
set CARDS(FBC-3602A.layer4-7) none

set CARDS(FBC-3602.technology) FC-2
set CARDS(FBC-3602.cable) GBIC
set CARDS(FBC-3602.streams) Smart
set CARDS(FBC-3602.chassis) SMB6000
set CARDS(FBC-3602.flavour) SmartMetrics
set CARDS(FBC-3602.portsPerSlot) 2
set CARDS(FBC-3602.slotsPerChassis) 12
set CARDS(FBC-3602.slotsPerSlot) 1
set CARDS(FBC-3602.layer4-7) none

######### 10/100 E ############
######### 10/100 E ############
######### 10/100 E ############


set CARDS(LAN-6101.technology) E/FE
set CARDS(LAN-6101.cable) CAT5
set CARDS(LAN-6101.streams) Smart
set CARDS(LAN-6101.chassis) SMB6000
set CARDS(LAN-6101.flavour) SmartMetrics
set CARDS(LAN-6101.portsPerSlot) 6
set CARDS(LAN-6101.slotsPerChassis) 12
set CARDS(LAN-6101.slotsPerSlot) 1
set CARDS(LAN-6101.layer4-7) Web

set CARDS(LAN-6101/3101.technology) E/FE
set CARDS(LAN-6101/3101.cable) CAT5
set CARDS(LAN-6101/3101.streams) Smart
set CARDS(LAN-6101/3101.chassis) SMB6000
set CARDS(LAN-6101/3101.flavour) SmartMetrics
set CARDS(LAN-6101/3101.portsPerSlot) 6
set CARDS(LAN-6101/3101.slotsPerChassis) 12
set CARDS(LAN-6101/3101.slotsPerSlot) 1
set CARDS(LAN-6101/3101.layer4-7) Web

set CARDS(LAN-6101A/3101A.technology) E/FE
set CARDS(LAN-6101A/3101A.cable) CAT5
set CARDS(LAN-6101A/3101A.streams) Smart
set CARDS(LAN-6101A/3101A.chassis) SMB6000
set CARDS(LAN-6101A/3101A.flavour) SmartMetrics
set CARDS(LAN-6101A/3101A.portsPerSlot) 6
set CARDS(LAN-6101A/3101A.slotsPerChassis) 12
set CARDS(LAN-6101A/3101A.slotsPerSlot) 1
set CARDS(LAN-6101A/3101A.layer4-7) Web

set CARDS(LAN-3101.technology) E/FE
set CARDS(LAN-3101.cable) CAT5
set CARDS(LAN-3101.streams) Smart
set CARDS(LAN-3101.chassis) SMB6000
set CARDS(LAN-3101.flavour) SmartMetrics
set CARDS(LAN-3101.portsPerSlot) 6
set CARDS(LAN-3101.slotsPerChassis) 12
set CARDS(LAN-3101.slotsPerSlot) 1
set CARDS(LAN-3101.layer4-7) Web

set CARDS(LAN-3101A.technology) E/FE
set CARDS(LAN-3101.technology) E/FE
set CARDS(LAN-3101.cable) CAT5
set CARDS(LAN-3101.streams) Smart
set CARDS(LAN-3101.chassis) SMB6000
set CARDS(LAN-3101.flavour) SmartMetrics
set CARDS(LAN-3101.portsPerSlot) 6
set CARDS(LAN-3101.slotsPerChassis) 12
set CARDS(LAN-3101.slotsPerSlot) 1
set CARDS(LAN-3101.layer4-7) Web
set CARDS(LAN-3101A.cable) CAT5
set CARDS(LAN-3101A.streams) Smart
set CARDS(LAN-3101A.chassis) SMB6000
set CARDS(LAN-3101A.flavour) SmartMetrics
set CARDS(LAN-3101A.portsPerSlot) 6
set CARDS(LAN-3101A.slotsPerChassis) 12
set CARDS(LAN-3101A.slotsPerSlot) 1
set CARDS(LAN-3101A.layer4-7) Web

set CARDS(ML-7710.technology) E/FE
set CARDS(ML-7710.cable) CAT5
set CARDS(ML-7710.streams) Smart
set CARDS(ML-7710.chassis) SMB2000
set CARDS(ML-7710.flavour) SmartMetricc
set CARDS(ML-7710.portsPerSlot) 1
set CARDS(ML-7710.slotsPerChassis) 20
set CARDS(ML-7710.slotsPerSlot) 1
set CARDS(ML-7710.layer4-7) TCP

set CARDS(ML-7711.technology) FE
set CARDS(ML-7711.cable) MM/SM
set CARDS(ML-7711.streams) Smart
set CARDS(ML-7711.chassis) SMB2000
set CARDS(ML-7711.flavour) SmartMetrics
set CARDS(ML-7711.portsPerSlot) 1
set CARDS(ML-7711.slotsPerChassis) 20
set CARDS(ML-7711.slotsPerSlot) 1
set CARDS(ML-7711.layer4-7) TCP

set CARDS(LAN-3111.technology) FE
set CARDS(LAN-3111.cable) MM/SM
set CARDS(LAN-3111.streams) Tera
set CARDS(LAN-3111.chassis) SMB6000
set CARDS(LAN-3111.flavour) SmartMetrics
set CARDS(LAN-3111.portsPerSlot) 6
set CARDS(LAN-3111.slotsPerChassis) 12
set CARDS(LAN-3111.slotsPerSlot) 1
set CARDS(LAN-3111.layer4-7) Yes!

set CARDS(LAN-3111A.technology) FE
set CARDS(LAN-3111A.cable) MM/SM
set CARDS(LAN-3111A.streams) Tera
set CARDS(LAN-3111A.chassis) SMB6000
set CARDS(LAN-3111A.flavour) SmartMetrics
set CARDS(LAN-3111A.portsPerSlot) 6
set CARDS(LAN-3111A.slotsPerChassis) 12
set CARDS(LAN-3111A.slotsPerSlot) 1
set CARDS(LAN-3111A.layer4-7) Yes!

set CARDS(LAN-3111B.technology) FE
set CARDS(LAN-3111B.cable) MM/SM
set CARDS(LAN-3111B.streams) Tera
set CARDS(LAN-3111B.chassis) SMB6000
set CARDS(LAN-3111B.flavour) SmartMetrics
set CARDS(LAN-3111B.portsPerSlot) 6
set CARDS(LAN-3111B.slotsPerChassis) 12
set CARDS(LAN-3111B.slotsPerSlot) 1
set CARDS(LAN-3111B.layer4-7) Yes!

set CARDS(LAN-3101B.technology) E/FE
set CARDS(LAN-3101B.cable) CAT5
set CARDS(LAN-3101B.streams) Smart
set CARDS(LAN-3101B.chassis) SMB6000
set CARDS(LAN-3101B.flavour) SmartMetrics
set CARDS(LAN-3101B.portsPerSlot) 6
set CARDS(LAN-3101B.slotsPerChassis) 12
set CARDS(LAN-3101B.slotsPerSlot) 1
set CARDS(LAN-3101B.layer4-7) Web

set CARDS(LAN-3301.technology) GE
set CARDS(LAN-3301.cable) CAT5
set CARDS(LAN-3301.streams) Tera
set CARDS(LAN-3301.chassis) SMB6000
set CARDS(LAN-3301.flavour) SmartMetrics
set CARDS(LAN-3301.portsPerSlot) 2
set CARDS(LAN-3301.slotsPerChassis) 12
set CARDS(LAN-3301.slotsPerSlot) 1
set CARDS(LAN-3301.layer4-7) Yes!

set CARDS(LAN-3324.technology) GE
set CARDS(LAN-3324.cable) CAT5
set CARDS(LAN-3324.streams) Tera
set CARDS(LAN-3324.chassis) SMB6000
set CARDS(LAN-3324.flavour) SmartMetrics
set CARDS(LAN-3324.portsPerSlot) 4
set CARDS(LAN-3324.slotsPerChassis) 12
set CARDS(LAN-3324.slotsPerSlot) 1
set CARDS(LAN-3324.layer4-7) Yes!

set CARDS(LAN-3325.technology) GE
set CARDS(LAN-3325.cable) CAT5
set CARDS(LAN-3325.streams) Tera
set CARDS(LAN-3325.chassis) SMB6000
set CARDS(LAN-3325.flavour) SmartMetrics
set CARDS(LAN-3325.portsPerSlot) 4
set CARDS(LAN-3325.slotsPerChassis) 12
set CARDS(LAN-3325.slotsPerSlot) 1
set CARDS(LAN-3325.layer4-7) Yes!

set CARDS(LAN-3327.technology) GE
set CARDS(LAN-3327.cable) CAT5
set CARDS(LAN-3327.streams) Tera
set CARDS(LAN-3327.chassis) SMB6000
set CARDS(LAN-3327.flavour) SmartMetrics
set CARDS(LAN-3327.portsPerSlot) 1
set CARDS(LAN-3327.slotsPerChassis) 12
set CARDS(LAN-3327.slotsPerSlot) 1
set CARDS(LAN-3327.layer4-7) Yes!

set CARDS(LAN-3321.technology) GE
set CARDS(LAN-3321.cable) CAT5
set CARDS(LAN-3321.streams) Tera
set CARDS(LAN-3321.chassis) SMB6000
set CARDS(LAN-3321.flavour) SmartMetrics
set CARDS(LAN-3321.portsPerSlot) 2
set CARDS(LAN-3321.slotsPerChassis) 12
set CARDS(LAN-3321.slotsPerSlot) 1
set CARDS(LAN-3321.layer4-7) Yes!

set CARDS(LAN-3320.technology) GE
set CARDS(LAN-3320.cable) CAT5
set CARDS(LAN-3320.streams) Smart
set CARDS(LAN-3320.chassis) SMB6000
set CARDS(LAN-3320.flavour) SmartMetrics
set CARDS(LAN-3320.portsPerSlot) 2
set CARDS(LAN-3320.slotsPerChassis) 12
set CARDS(LAN-3320.slotsPerSlot) 1
set CARDS(LAN-3320.layer4-7) Yes!

set CARDS(ATM-3453.technology) ATM
set CARDS(ATM-3453.cable) SM
set CARDS(ATM-3453.streams) Tera
set CARDS(ATM-3453.chassis) SMB6000
set CARDS(ATM-3453.flavour) SmartMetrics
set CARDS(ATM-3453.portsPerSlot) 2
set CARDS(ATM-3453.slotsPerChassis) 12
set CARDS(ATM-3453.slotsPerSlot) 1
set CARDS(ATM-3453.layer4-7) Yes!

set CARDS(TeraMetrics.technology) ATM
set CARDS(TeraMetrics.cable) SM
set CARDS(TeraMetrics.streams) Tera
set CARDS(TeraMetrics.chassis) SMB6000
set CARDS(TeraMetrics.flavour) SmartMetrics
set CARDS(TeraMetrics.portsPerSlot) 24
set CARDS(TeraMetrics.slotsPerChassis) 12
set CARDS(TeraMetrics.slotsPerSlot) 1
set CARDS(TeraMetrics.layer4-7) Yes!

set CARDS(LAN-3300.technology) GE
set CARDS(LAN-3300.cable) CAT5
set CARDS(LAN-3300.streams) Tera
set CARDS(LAN-3300.chassis) SMB6000
set CARDS(LAN-3300.flavour) SmartMetrics
set CARDS(LAN-3300.portsPerSlot) 2
set CARDS(LAN-3300.slotsPerChassis) 12
set CARDS(LAN-3300.slotsPerSlot) 1
set CARDS(LAN-3300.layer4-7) Yes!


set CARDS(LAN-3301A.technology) GE
set CARDS(LAN-3301A.cable) CAT5
set CARDS(LAN-3301A.streams) Tera
set CARDS(LAN-3301A.chassis) SMB6000
set CARDS(LAN-3301A.flavour) SmartMetrics
set CARDS(LAN-3301A.portsPerSlot) 2
set CARDS(LAN-3301A.slotsPerChassis) 12
set CARDS(LAN-3301A.slotsPerSlot) 1
set CARDS(LAN-3301A.layer4-7) Yes!


set CARDS(LAN-3302.technology) GE
set CARDS(LAN-3302.cable) CAT5
set CARDS(LAN-3302.streams) Tera
set CARDS(LAN-3302.chassis) SMB6000
set CARDS(LAN-3302.flavour) SmartMetrics
set CARDS(LAN-3302.portsPerSlot) 2
set CARDS(LAN-3302.slotsPerChassis) 12
set CARDS(LAN-3302.slotsPerSlot) 1
set CARDS(LAN-3302.layer4-7) Yes!

set CARDS(LAN-3302A.technology) GE
set CARDS(LAN-3302A.cable) CAT5
set CARDS(LAN-3302A.streams) Tera
set CARDS(LAN-3302A.chassis) SMB6000
set CARDS(LAN-3302A.flavour) SmartMetrics
set CARDS(LAN-3302A.portsPerSlot) 2
set CARDS(LAN-3302A.slotsPerChassis) 12
set CARDS(LAN-3302A.slotsPerSlot) 1
set CARDS(LAN-3302A.layer4-7) Yes!


########### 1 GIG E ###########
########### 1 GIG E ###########
########### 1 GIG E ###########
########### 1 GIG E ###########

set CARDS(LAN-6201/3201.technology) GE
set CARDS(LAN-6201/3201.cable) MM/SM
set CARDS(LAN-6201/3201.streams) Smart
set CARDS(LAN-6201/3201.chassis) SMB6000
set CARDS(LAN-6201/3201.flavour) SmartMetrics
set CARDS(LAN-6201/3201.portsPerSlot) 1
set CARDS(LAN-6201/3201.slotsPerChassis) 12
set CARDS(LAN-6201/3201.slotsPerSlot) 1
set CARDS(LAN-6201/3201.layer4-7) TCP

set CARDS(LAN-6201A/3201A.technology) GE
set CARDS(LAN-6201A/3201A.cable) MM/SM
set CARDS(LAN-6201A/3201A.streams) Smart
set CARDS(LAN-6201A/3201A.chassis) SMB6000
set CARDS(LAN-6201A/3201A.flavour) SmartMetrics
set CARDS(LAN-6201A/3201A.portsPerSlot) 1
set CARDS(LAN-6201A/3201A.slotsPerChassis) 12
set CARDS(LAN-6201A/3201A.slotsPerSlot) 1
set CARDS(LAN-6201A/3201A.layer4-7) TCP

set CARDS(LAN-6201B/3201B.technology) GE
set CARDS(LAN-6201B/3201B.cable) GBIC
set CARDS(LAN-6201B/3201B.streams) Smart
set CARDS(LAN-6201B/3201B.chassis) SMB6000
set CARDS(LAN-6201B/3201B.flavour) SmartMetrics
set CARDS(LAN-6201B/3201B.portsPerSlot) 1
set CARDS(LAN-6201B/3201B.slotsPerChassis) 12
set CARDS(LAN-6201B/3201B.slotsPerSlot) 1
set CARDS(LAN-6201B/3201B.layer4-7) TCP

set CARDS(LAN-6201.technology) GE
set CARDS(LAN-6201.cable) MM/SM
set CARDS(LAN-6201.streams) Smart
set CARDS(LAN-6201.chassis) SMB6000
set CARDS(LAN-6201.flavour) SmartMetrics
set CARDS(LAN-6201.portsPerSlot) 1
set CARDS(LAN-6201.slotsPerChassis) 12
set CARDS(LAN-6201.slotsPerSlot) 1
set CARDS(LAN-6201.layer4-7) TCP

set CARDS(LAN-6201A.technology) GE
set CARDS(LAN-6201A.cable) MM/SM
set CARDS(LAN-6201A.streams) Smart
set CARDS(LAN-6201A.chassis) SMB6000
set CARDS(LAN-6201A.flavour) SmartMetrics
set CARDS(LAN-6201A.portsPerSlot) 1
set CARDS(LAN-6201A.slotsPerChassis) 12
set CARDS(LAN-6201A.slotsPerSlot) 1
set CARDS(LAN-6201A.layer4-7) TCP

set CARDS(LAN-6201B.technology) GE
set CARDS(LAN-6201B.cable) MM/SM
set CARDS(LAN-6201B.streams) Smart
set CARDS(LAN-6201B.chassis) SMB6000
set CARDS(LAN-6201B.flavour) SmartMetrics
set CARDS(LAN-6201B.portsPerSlot) 1
set CARDS(LAN-6201B.slotsPerChassis) 12
set CARDS(LAN-6201B.slotsPerSlot) 1
set CARDS(LAN-6201B.layer4-7) TCP

set CARDS(LAN-3200.technology) GE
set CARDS(LAN-3200.cable) MM/SM
set CARDS(LAN-3200.streams) None
set CARDS(LAN-3200.chassis) SMB6000
set CARDS(LAN-3200.flavour) Traditional
set CARDS(LAN-3200.portsPerSlot) 1
set CARDS(LAN-3200.slotsPerChassis) 12
set CARDS(LAN-3200.slotsPerSlot) 1
set CARDS(LAN-3200.layer4-7) None

set CARDS(LAN-3201.technology) GE
set CARDS(LAN-3201.cable) MM/SM
set CARDS(LAN-3201.streams) Smart
set CARDS(LAN-3201.chassis) SMB6000
set CARDS(LAN-3201.flavour) SmartMetrics
set CARDS(LAN-3201.portsPerSlot) 1
set CARDS(LAN-3201.slotsPerChassis) 12
set CARDS(LAN-3201.slotsPerSlot) 1
set CARDS(LAN-3201.layer4-7) TCP

set CARDS(LAN-3201A.technology) GE
set CARDS(LAN-3201A.cable) MM/SM
set CARDS(LAN-3201A.streams) Smart
set CARDS(LAN-3201A.chassis) SMB6000
set CARDS(LAN-3201A.flavour) SmartMetrics
set CARDS(LAN-3201A.portsPerSlot) 1
set CARDS(LAN-3201A.slotsPerChassis) 12
set CARDS(LAN-3201A.slotsPerSlot) 1
set CARDS(LAN-3201A.layer4-7) TCP

set CARDS(LAN-3201B.technology) GE
set CARDS(LAN-3201B.cable) MM/SM
set CARDS(LAN-3201B.streams) Smart
set CARDS(LAN-3201B.chassis) SMB6000
set CARDS(LAN-3201B.flavour) SmartMetrics
set CARDS(LAN-3201B.portsPerSlot) 1
set CARDS(LAN-3201B.slotsPerChassis) 12
set CARDS(LAN-3201B.slotsPerSlot) 1
set CARDS(LAN-3201B.layer4-7) TCP

set CARDS(LAN-3310.technology) GE
set CARDS(LAN-3310.cable) GBIC
set CARDS(LAN-3310.streams) Smart
set CARDS(LAN-3310.chassis) SMB6000
set CARDS(LAN-3310.flavour) SmartMetrics
set CARDS(LAN-3310.portsPerSlot) 2
set CARDS(LAN-3310.slotsPerChassis) 12
set CARDS(LAN-3310.slotsPerSlot) 1
set CARDS(LAN-3310.layer4-7) none

set CARDS(LAN-3310A.technology) GE
set CARDS(LAN-3310A.cable) GBIC
set CARDS(LAN-3310A.streams) Smart
set CARDS(LAN-3310A.chassis) SMB6000
set CARDS(LAN-3310A.flavour) SmartMetrics
set CARDS(LAN-3310A.portsPerSlot) 2
set CARDS(LAN-3310A.slotsPerChassis) 12
set CARDS(LAN-3310A.slotsPerSlot) 1
set CARDS(LAN-3310A.layer4-7) none

set CARDS(LAN-3310B.technology) GE
set CARDS(LAN-3310B.cable) GBIC
set CARDS(LAN-3310B.streams) Smart
set CARDS(LAN-3310B.chassis) SMB6000
set CARDS(LAN-3310B.flavour) SmartMetrics
set CARDS(LAN-3310B.portsPerSlot) 2
set CARDS(LAN-3310B.slotsPerChassis) 12
set CARDS(LAN-3310B.slotsPerSlot) 1
set CARDS(LAN-3310.layer4-7) none

set CARDS(GX-1405.technology) GE
set CARDS(GX-1405.cable) MM/SM
set CARDS(GX-1405.streams) Trad.
set CARDS(GX-1405.chassis) SMB2000
set CARDS(GX-1405.flavour) Non-Streaming
set CARDS(GX-1405.portsPerSlot) 1
set CARDS(GX-1405.slotsPerChassis) 10
set CARDS(GX-1405.slotsPerSlot) 2
set CARDS(GX-1405.layer4-7) none

set CARDS(GX-1405A.technology) GE
set CARDS(GX-1405A.cable) MM/SM
set CARDS(GX-1405A.streams) Trad.
set CARDS(GX-1405A.chassis) SMB2000
set CARDS(GX-1405A.flavour) Non-Streaming
set CARDS(GX-1405A.portsPerSlot) 1
set CARDS(GX-1405A.slotsPerChassis) 10
set CARDS(GX-1405A.slotsPerSlot) 2
set CARDS(GX-1405A.layer4-7) none

set CARDS(GX-1405B.technology) GE
set CARDS(GX-1405B.cable) MM/SM
set CARDS(GX-1405B.streams) Trad.
set CARDS(GX-1405B.chassis) SMB2000
set CARDS(GX-1405B.flavour) Non-Streaming
set CARDS(GX-1405B.portsPerSlot) 1
set CARDS(GX-1405B.slotsPerChassis) 10
set CARDS(GX-1405B.slotsPerSlot) 2
set CARDS(GX-1405B.layer4-7) none

set CARDS(GX-1420.technology) GE
set CARDS(GX-1420.cable) CAT5
set CARDS(GX-1420.streams) Trad.
set CARDS(GX-1420.chassis) SMB2000
set CARDS(GX-1420.flavour) Non-Streaming
set CARDS(GX-1420.slotsPerChassis) 10
set CARDS(GX-1420.slotsPerSlot) 2
set CARDS(GX-1420.layer4-7) none

set CARDS(GX-1420A.technology) GE
set CARDS(GX-1420A.cable) CAT5
set CARDS(GX-1420A.streams) Trad.
set CARDS(GX-1420A.chassis) SMB2000
set CARDS(GX-1420A.flavour) Non-Streaming
set CARDS(GX-1420A.slotsPerChassis) 10
set CARDS(GX-1420A.slotsPerSlot) 2
set CARDS(GX-1420A.layer4-7) none

set CARDS(GX-1420B.technology) GE
set CARDS(GX-1420B.cable) CAT5
set CARDS(GX-1420B.streams) Trad.
set CARDS(GX-1420B.chassis) SMB2000
set CARDS(GX-1420B.flavour) Non-Streaming
set CARDS(GX-1420B.slotsPerChassis) 10
set CARDS(GX-1420B.slotsPerSlot) 2
set CARDS(GX-1420B.layer4-7) none

set CARDS(LAN-3311.technology) GE
set CARDS(LAN-3311.cable) GBIC
set CARDS(LAN-3311.streams) Tera
set CARDS(LAN-3311.chassis) SMB6000
set CARDS(LAN-3311.flavour) TeraMetrics
set CARDS(LAN-3311.portsPerSlot) 2
set CARDS(LAN-3311.slotsPerChassis) 12
set CARDS(LAN-3311.slotsPerSlot) 1
set CARDS(LAN-3311.layer4-7) Yes!

set CARDS(LAN-3311A.technology) GE
set CARDS(LAN-3311A.cable) GBIC
set CARDS(LAN-3311A.streams) Tera
set CARDS(LAN-3311A.chassis) SMB6000
set CARDS(LAN-3311A.flavour) TeraMetrics
set CARDS(LAN-3311A.portsPerSlot) 2
set CARDS(LAN-3311A.slotsPerChassis) 12
set CARDS(LAN-3311A.slotsPerSlot) 1
set CARDS(LAN-3311A.layer4-7) Yes!

set CARDS(LAN-3311B.technology) GE
set CARDS(LAN-3311B.cable) GBIC
set CARDS(LAN-3311B.streams) Tera
set CARDS(LAN-3311B.chassis) SMB6000
set CARDS(LAN-3311B.flavour) TeraMetrics
set CARDS(LAN-3311B.portsPerSlot) 2
set CARDS(LAN-3311B.slotsPerChassis) 12
set CARDS(LAN-3311B.slotsPerSlot) 1
set CARDS(LAN-3311B.layer4-7) Yes!

set CARDS(LAN-3102.technology) GE
set CARDS(LAN-3102.cable) MM/SM
set CARDS(LAN-3102.streams) y
set CARDS(LAN-3102.chassis) SMB6000
set CARDS(LAN-3102.flavour) SmartMetrics
set CARDS(LAN-3102.portsPerSlot) 1
set CARDS(LAN-3102.slotsPerChassis) 12
set CARDS(LAN-3102.slotsPerSlot) 1

set CARDS(LAN-3102A.technology) GE
set CARDS(LAN-3102A.cable) MM/SM
set CARDS(LAN-3102A.streams) y
set CARDS(LAN-3102A.chassis) SMB6000
set CARDS(LAN-3102A.flavour) SmartMetrics
set CARDS(LAN-3102A.portsPerSlot) 1
set CARDS(LAN-3102A.slotsPerChassis) 12
set CARDS(LAN-3102A.slotsPerSlot) 1

set CARDS(LAN-3102B.technology) GE
set CARDS(LAN-3102B.cable) MM/SM
set CARDS(LAN-3102B.streams) y
set CARDS(LAN-3102B.chassis) SMB6000
set CARDS(LAN-3102B.flavour) SmartMetrics
set CARDS(LAN-3102B.portsPerSlot) 1
set CARDS(LAN-3102B.slotsPerChassis) 12
set CARDS(LAN-3102B.slotsPerSlot) 1

######### 10 GIG E #########
######### 10 GIG E #########
######### 10 GIG E #########
######### 10 GIG E #########
######### 10 GIG E #########

set CARDS(XLW-3720.technology) 10GE
set CARDS(XLW-3720.cable) SM
set CARDS(XLW-3720.streams) Smart
set CARDS(XLW-3720.chassis) SMB6000
set CARDS(XLW-3720.flavour) Streaming
set CARDS(XLW-3720.slotsPerChassis) 6
set CARDS(XLW-3720.slotsPerSlot) 2
set CARDS(XLW-3720.layer4-7) none

set CARDS(XLW-3721.technology) 10GE
set CARDS(XLW-3721.cable) SM
set CARDS(XLW-3721.streams) Smart
set CARDS(XLW-3721.chassis) SMB6000
set CARDS(XLW-3721.flavour) Streaming
set CARDS(XLW-3721.slotsPerChassis) 6
set CARDS(XLW-3721.slotsPerSlot) 2
set CARDS(XLW-3721.layer4-7) none


set CARDS(LAN-3710.technology) 10GE
set CARDS(LAN-3710.cable) SM
set CARDS(LAN-3710.streams) Smart
set CARDS(LAN-3710.chassis) SMB6000
set CARDS(LAN-3710.flavour) Streaming
set CARDS(LAN-3710.slotsPerChassis) 6
set CARDS(LAN-3710.slotsPerSlot) 2
set CARDS(LAN-3710.layer4-7) none

set CARDS(LAN-3710A.technology) 10GE
set CARDS(LAN-3710A.cable) SM
set CARDS(LAN-3710A.streams) Smart
set CARDS(LAN-3710A.chassis) SMB6000
set CARDS(LAN-3710A.flavour) Streaming
set CARDS(LAN-3710A.slotsPerChassis) 6
set CARDS(LAN-3710A.slotsPerSlot) 2
set CARDS(LAN-3710A.layer4-7) none

set CARDS(LAN-3710AL.technology) 10GE
set CARDS(LAN-3710AL.cable) SM
set CARDS(LAN-3710AL.streams) Smart
set CARDS(LAN-3710AL.chassis) SMB6000
set CARDS(LAN-3710AL.flavour) Streaming
set CARDS(LAN-3710AL.slotsPerChassis) 6
set CARDS(LAN-3710AL.slotsPerSlot) 2
set CARDS(LAN-3710AL.layer4-7) none

set CARDS(LAN-3710AS.technology) 10GE
set CARDS(LAN-3710AS.cable) MM
set CARDS(LAN-3710AS.streams) Smart
set CARDS(LAN-3710AS.chassis) SMB6000
set CARDS(LAN-3710AS.flavour) Streaming
set CARDS(LAN-3710AS.slotsPerChassis) 6
set CARDS(LAN-3710AS.slotsPerSlot) 2
set CARDS(LAN-3710AS.layer4-7) none

set CARDS(LAN-3710AE.technology) 10GE
set CARDS(LAN-3710AE.cable) GBIC
set CARDS(LAN-3710AE.streams) Smart
set CARDS(LAN-3710AE.chassis) SMB6000
set CARDS(LAN-3710AE.flavour) SmartMetrics
set CARDS(LAN-3710AE.portsPerSlot) 2
set CARDS(LAN-3710AE.slotsPerChassis) 6
set CARDS(LAN-3710AE.slotsPerSlot) 2
set CARDS(LAN-3710AE.layer4-7) none


######### POS #########
######### POS #########
######### POS #########

######### OC3/OC12 #########

set CARDS(POS-6500/3500.technology) POS3/12
set CARDS(POS-6500/3500.cable) MM/SM
set CARDS(POS-6500/3500.streams) Smart
set CARDS(POS-6500/3500.chassis) SMB6000
set CARDS(POS-6500/3500.flavour) SmartMetric
set CARDS(POS-6500/3500.portsPerSlot) 1
set CARDS(POS-6500/3500.slotsPerChassis) 12
set CARDS(POS-6500/3500.slotsPerSlot) 1
set CARDS(POS-6500/3500.layer4-7) none

set CARDS(POS-6500A/3500A.technology) POS3/12
set CARDS(POS-6500A/3500A.cable) MM/SM
set CARDS(POS-6500A/3500A.streams) Smart
set CARDS(POS-6500A/3500A.chassis) SMB6000
set CARDS(POS-6500A/3500A.flavour) SmartMetrics
set CARDS(POS-6500A/3500A.portsPerSlot) 1
set CARDS(POS-6500A/3500A.slotsPerChassis) 12
set CARDS(POS-6500A/3500A.slotsPerSlot) 1
set CARDS(POS-6500A/3500A.layer4-7) none

set CARDS(POS-6500B/3500B.technology) POS3/12
set CARDS(POS-6500B/3500B.cable) MM/SM
set CARDS(POS-6500B/3500B.streams) Smart
set CARDS(POS-6500B/3500B.chassis) SMB6000
set CARDS(POS-6500B/3500B.flavour) SmartMetrics
set CARDS(POS-6500B/3500B.portsPerSlot) 1
set CARDS(POS-6500B/3500B.slotsPerChassis) 12
set CARDS(POS-6500B/3500B.slotsPerSlot) 1
set CARDS(POS-6500B/3500B.layer4-7) none

set CARDS(POS-6500.technology) POS3/12
set CARDS(POS-6500.cable) MM/SM
set CARDS(POS-6500.streams) Smart
set CARDS(POS-6500.chassis) SMB6000
set CARDS(POS-6500.flavour) SmartMetrics
set CARDS(POS-6500.portsPerSlot) 1
set CARDS(POS-6500.slotsPerChassis) 12
set CARDS(POS-6500.slotsPerSlot) 1
set CARDS(POS-6500.layer4-7) none

set CARDS(POS-6500A.technology) POS3/12
set CARDS(POS-6500A.cable) MM/SM
set CARDS(POS-6500A.streams) Smart
set CARDS(POS-6500A.chassis) SMB6000
set CARDS(POS-6500A.flavour) SmartMetrics
set CARDS(POS-6500A.portsPerSlot) 1
set CARDS(POS-6500A.slotsPerChassis) 12
set CARDS(POS-6500A.slotsPerSlot) 1
set CARDS(POS-6500A.layer4-7) none

set CARDS(POS-6500B.technology) POS3/12
set CARDS(POS-6500B.cable) MM/SM
set CARDS(POS-6500B.streams) Smart
set CARDS(POS-6500B.chassis) SMB6000
set CARDS(POS-6500B.flavour) SmartMetrics
set CARDS(POS-6500B.portsPerSlot) 1
set CARDS(POS-6500B.slotsPerChassis) 12
set CARDS(POS-6500B.slotsPerSlot) 1
set CARDS(POS-6500B.layer4-7) none

set CARDS(POS-3500.technology) OC312
set CARDS(POS-3500.cable) MM/SM
set CARDS(POS-3500.streams) Smart
set CARDS(POS-3500.chassis) SMB6000
set CARDS(POS-3500.flavour) SmartMetrics
set CARDS(POS-3500.portsPerSlot) 1
set CARDS(POS-3500.slotsPerChassis) 12
set CARDS(POS-3500.slotsPerSlot) 1
set CARDS(POS-3500.layer4-7) none

set CARDS(POS-3500A.technology) POS3/12
set CARDS(POS-3500A.cable) MM/SM
set CARDS(POS-3500A.streams) Smart
set CARDS(POS-3500A.chassis) SMB6000
set CARDS(POS-3500A.flavour) SmartMetrics
set CARDS(POS-3500A.portsPerSlot) 1
set CARDS(POS-3500A.slotsPerChassis) 12
set CARDS(POS-3500A.slotsPerSlot) 1
set CARDS(POS-3500A.layer4-7) none

set CARDS(POS-3500B.technology) POS3/12
set CARDS(POS-3500B.cable) MM/SM
set CARDS(POS-3500B.streams) Smart
set CARDS(POS-3500B.chassis) SMB6000
set CARDS(POS-3500B.flavour) SmartMetrics
set CARDS(POS-3500B.portsPerSlot) 1
set CARDS(POS-3500B.slotsPerChassis) 12
set CARDS(POS-3500B.slotsPerSlot) 1
set CARDS(POS-3500B.layer4-7) none

########## OC48 #############

set CARDS(POS-3504.technology) POS48
set CARDS(POS-3504.cable) SM
set CARDS(POS-3504.streams) Smart
set CARDS(POS-3504.chassis) SMB6000
set CARDS(POS-3504.flavour) SmartMetrics
set CARDS(POS-3504.portsPerSlot) 2
set CARDS(POS-3504.slotsPerChassis) 12
set CARDS(POS-3504.slotsPerSlot) 1
set CARDS(POS-3504.layer4-7) none

set CARDS(POS-3504A.technology) POS48
set CARDS(POS-3504A.cable) SM
set CARDS(POS-3504A.streams) Smart
set CARDS(POS-3504A.chassis) SMB6000
set CARDS(POS-3504A.flavour) SmartMetrics
set CARDS(POS-3504A.portsPerSlot) 2
set CARDS(POS-3504A.slotsPerChassis) 12
set CARDS(POS-3504A.slotsPerSlot) 1
set CARDS(POS-3504A.layer4-7) none

set CARDS(POS-3504B.technology) POS48
set CARDS(POS-3504B.cable) SM
set CARDS(POS-3504B.streams) Smart
set CARDS(POS-3504B.chassis) SMB6000
set CARDS(POS-3504B.flavour) SmartMetrics
set CARDS(POS-3504B.portsPerSlot) 2
set CARDS(POS-3504B.slotsPerChassis) 12
set CARDS(POS-3504B.slotsPerSlot) 1
set CARDS(POS-3504B.layer4-7) none

set CARDS(POS-3505.technology) POS48
set CARDS(POS-3505.cable) SM
set CARDS(POS-3505.streams) Tera
set CARDS(POS-3505.chassis) SMB6000
set CARDS(POS-3505.flavour) TeraMetrics
set CARDS(POS-3505.portsPerSlot) 2
set CARDS(POS-3505.slotsPerChassis) 12
set CARDS(POS-3505.slotsPerSlot) 1
set CARDS(POS-3505.layer4-7) Yes!

set CARDS(POS-3505A.technology) POS48
set CARDS(POS-3505A.cable) SM
set CARDS(POS-3505A.streams) Tera
set CARDS(POS-3505A.chassis) SMB6000
set CARDS(POS-3505A.flavour) TeraMetrics
set CARDS(POS-3505A.portsPerSlot) 2
set CARDS(POS-3505A.slotsPerChassis) 12
set CARDS(POS-3505A.slotsPerSlot) 1
set CARDS(POS-3505A.layer4-7) Yes!


set CARDS(POS-3505B.technology) POS48
set CARDS(POS-3505B.cable) SM
set CARDS(POS-3505B.streams) Tera
set CARDS(POS-3505B.chassis) SMB6000
set CARDS(POS-3505B.flavour) TeraMetrics
set CARDS(POS-3505B.portsPerSlot) 2
set CARDS(POS-3505B.slotsPerChassis) 12
set CARDS(POS-3505B.slotsPerSlot) 1
set CARDS(POS-3505B.layer4-7) Yes!

######### OC192 #########

set CARDS(POS-3518.technology) POS-OC192
set CARDS(POS-3518.cable) SM
set CARDS(POS-3518.streams) Smart
set CARDS(POS-3518.chassis) SMB6000
set CARDS(POS-3518.flavour) TeraMetrics
set CARDS(POS-3518.portsPerSlot) 1
set CARDS(POS-3518.slotsPerChassis) 6
set CARDS(POS-3518.slotsPerSlot) 2
set CARDS(POS-3518.layer4-7) none

set CARDS(POS-3518A.technology) POS-OC192
set CARDS(POS-3518A.cable) SM
set CARDS(POS-3518A.streams) Smart
set CARDS(POS-3518A.chassis) SMB6000
set CARDS(POS-3518A.flavour) TeraMetrics
set CARDS(POS-3518A.portsPerSlot) 1
set CARDS(POS-3518A.slotsPerChassis) 6
set CARDS(POS-3518A.slotsPerSlot) 2
set CARDS(POS-3518A.layer4-7) none

set CARDS(POS-3518B.technology) POS-OC192
set CARDS(POS-3518B.cable) SM
set CARDS(POS-3518B.streams) Smart
set CARDS(POS-3518B.chassis) SMB6000
set CARDS(POS-3518B.flavour) TeraMetrics
set CARDS(POS-3518B.portsPerSlot) 1
set CARDS(POS-3518B.slotsPerChassis) 6
set CARDS(POS-3518B.slotsPerSlot) 2
set CARDS(POS-3518B.layer4-7) none

set CARDS(POS-3519.technology) POS-OC192
set CARDS(POS-3519.cable) SM
set CARDS(POS-3519.streams) Tera
set CARDS(POS-3519.chassis) SMB6000
set CARDS(POS-3519.flavour) TeraMetrics
set CARDS(POS-3519.portsPerSlot) 1
set CARDS(POS-3519.slotsPerChassis) 6
set CARDS(POS-3519.slotsPerSlot) 2
set CARDS(POS-3519.layer4-7) Yes!

set CARDS(POS-3519A.technology) POS-OC192
set CARDS(POS-3519A.cable) SM
set CARDS(POS-3519A.streams) Tera
set CARDS(POS-3519A.chassis) SMB6000
set CARDS(POS-3519A.flavour) TeraMetrics
set CARDS(POS-3519A.portsPerSlot) 1
set CARDS(POS-3519A.slotsPerChassis) 6
set CARDS(POS-3519A.slotsPerSlot) 2
set CARDS(POS-3519A.layer4-7) Yes!

set CARDS(POS-3519B.technology) POS-OC192
set CARDS(POS-3519B.cable) SM
set CARDS(POS-3519B.streams) Tera
set CARDS(POS-3519B.chassis) SMB6000
set CARDS(POS-3519B.flavour) TeraMetrics
set CARDS(POS-3519B.portsPerSlot) 1
set CARDS(POS-3519B.slotsPerChassis) 6
set CARDS(POS-3519B.slotsPerSlot) 2
set CARDS(POS-3519B.layer4-7) Yes!

set CARDS(POS-3519As.technology) POS-OC192
set CARDS(POS-3519As.cable) SM
set CARDS(POS-3519As.streams) Tera
set CARDS(POS-3519As.chassis) SMB6000
set CARDS(POS-3519As.flavour) TeraMetrics
set CARDS(POS-3519As.portsPerSlot) 1
set CARDS(POS-3519As.slotsPerChassis) 6
set CARDS(POS-3519As.slotsPerSlot) 2
set CARDS(POS-3519As.layer4-7) Yes!

######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
#
#
# FIRMWARE FUNCTIONS
# ------------------
#
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################



#############################################################################
# proc showCardFirmware
# ---------------------------------------
# purpose: show the card model and firmware for one card
# returns: a string with the good stuff in it
# notes:
#############################################################################
proc showCardFirmware { h s p { quiet 0 } } {
pputs "showCardFirmware"
if { $bl::ONEBASEDHSP } {set h [minus $h]; set s [minus $s]; set p [minus $p]}
set cm [getLibCardModel "h=$h s=$s p=$p"]
#set ver [EXReturnFWVersion $h $s $p]
struct_new fw FirmwareVersionStructure
HTGetStandardFWVersion fw $h $s $p
set ver [format "%s.%s.%s.%s" $fw(MajorNumber) $fw(MinorNumber) $fw(BuildNumber) $fw(PatchNumber)]

if { ! $quiet } {
puts "$h/$s/$p is a $cm running firmware version:$ver"
}
return "$h/$s/$p is a $cm running firmware version:$ver"
}


proc getcardname { params } {
return [getCardModel $params]
}

proc getcardmodel { params } {
return [getCardModel $params]
}

proc getcardModel { params } {
return [getCardModel $params]
}
proc getCardName { params } {
return [getCardModel $params]
}

proc getcardName { params } {
return [getCardModel $params]
}

proc getCardname { params } {
return [getCardModel $params]
}
proc cardname { params } {
return [getCardModel $params]
}

proc getcardName { params } {
return [getCardModel $params]
}

proc cardmodel { params } {
return [getCardModel $params]
}

proc cardtype { params } {
return [getCardModel $params]
}

proc getcardtype { params } {
return [getCardModel $params]
}

proc showCardModel { params } {
  vputs [getCardModel $params]
}

proc showcardmodel { params } {
  showCardModel $params
}

proc showCardName { params } {
showCardModel $params
}

proc showCardType { params } {
showCardModel $params
}


#############################################################################
# proc getCardModel
# ---------------------------------------
# purpose: shows the card model JUST the first 8 characters,
#############################################################################
proc getCardModel { params } {
  #pputs "getCardModel"
  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    if { ! [info exist bl::info(pure.$port.cardmodel)] } {
      set i ""
      if { [HTGetCardModel i $h $s $p] > -1 } {
        set i [string range $i 0 7]
      } else {
        set i ?
      }
      return $i
    } else {
      return $bl::info(pure.$port.cardmodel)
    }
  }
}

#############################################################################
# proc getLibCardModel
# --------------------------
#############################################################################
proc getLibCardModel { params } {
return [getCardModel $params]
}



###################################################################
# proc firmwareHspList
# --------------
# purpose: to display the firmware of a chassis and slots
# paramaters: a list of slots, and optionally, a parameter to show no chassis
# returns: nothing, but does a puts
#
####################################################################
proc firmwareHspList { ifList { nochassis 0 } } {
pputs "firmwareHspList"
if { ! $nochassis } {
set temp ""
set chassis ""
ETGetHardwareVersion chassis
set sernbr ""
ETGetSerialNumber sernbr
set fwvers ""
ETGetFirmwareVersion fwvers
set fwvers1 [string range $fwvers 5 5]
set fwvers2 [string range $fwvers 6 8]
set fwvers3 [string range $fwvers 2 4]
set fwvers4 [string range $fwvers 1 1]
puts "       Chassis: $chassis"
puts " Serial number: $sernbr"
puts "Firmware level: $fwvers1.$fwvers2.$fwvers3.$fwvers4 ($fwvers)"
puts " "
}
foreach if $ifList {
set h [lindex $if 0]
set s [lindex $if 1]
set p [lindex $if 2]
set cardinfo ""
LIBCDMD HTGetCardModel cardinfo $h $s $p
struct_new fw FirmwareVersionStructure
HTGetStandardFWVersion fw $h $s $p
puts -nonewline "Card $h/$s/$p: $cardinfo"
puts [format " Firmware: %s.%s.%s.%s" \
$fw(MajorNumber) \
$fw(MinorNumber) \
$fw(BuildNumber) \
$fw(PatchNumber) ]
unset fw
}
}

###############################################################################
# proc firmwareOneChassis
# ----------------
# purpose: return the firmware for current chassis.
###############################################################################
proc firmwareOneChassis { param } {
pputs "firmwareOneChassis"
set temp ""
set chassis ""
ETGetHardwareVersion chassis
set sernbr ""
ETGetSerialNumber sernbr
set fwvers ""
ETGetFirmwareVersion fwvers
set fwvers1 [string range $fwvers 5 5]
set fwvers2 [string range $fwvers 6 8]
set fwvers3 [string range $fwvers 2 4]
set fwvers4 [string range $fwvers 1 1]
return "Chassis:$chassis s/n:$sernbr f/w:$fwvers1.$fwvers2.$fwvers3.$fwvers4 ($fwvers)"
}


###############################################################################
# proc firmwareOneCard
# ----------------
# purpose: return the cardname & firmware version in a string
###############################################################################
proc firmwareOneCard { params } {
pputs "firmwareOneCard"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
set cardinfo ""
bl::check HTGetCardModel cardinfo $h $s $p
struct_new fw FirmwareVersionStructure
HTGetStandardFWVersion fw $h $s $p
set blah "Card $h/$s/$p: $cardinfo"
set blah2 [format " Firmware: %s.%s.%s.%s" \
$fw(MajorNumber) \
$fw(MinorNumber) \
$fw(BuildNumber) \
$fw(PatchNumber) ]
unset fw
return "$blah $blah2"
}
}

proc showFirmwareOneCard { params } { return [firmwareOneCard $params] }

###################################################################
# proc firmwareSlotlist
# ----------------------
# purpose: to display the firmware of a chassis and slots
# paramaters: a list of slots, and optionally, a parameter to show no chassis
# returns: nothing, but does a puts
#
####################################################################
proc firmwareSlotlist { slotlist { nochassis 0 } } {
pputs "firmwareSlotlist"
if { ! $nochassis } {
set temp ""
set chassis ""
ETGetHardwareVersion chassis
set sernbr ""
ETGetSerialNumber sernbr
set fwvers ""
ETGetFirmwareVersion fwvers
set fwvers1 [string range $fwvers 5 5]
set fwvers2 [string range $fwvers 6 8]
set fwvers3 [string range $fwvers 2 4]
set fwvers4 [string range $fwvers 1 1]
puts "       Chassis: $chassis"
puts " Serial number: $sernbr"
puts "Firmware level: $fwvers1.$fwvers2.$fwvers3.$fwvers4 ($fwvers)"
puts " "
}
foreach s $slotlist {
 if { $bl::ONEBASEDHSP } set s [minus $s]
set h 0; set p 0
set cardinfo ""
bl::check HTGetCardModel cardinfo $h $s $p
struct_new fw FirmwareVersionStructure
HTGetStandardFWVersion fw $h $s $p
puts -nonewline "Card $h/$s/$p: $cardinfo"
puts [format " Firmware: %s.%s.%s.%s" \
$fw(MajorNumber) \
$fw(MinorNumber) \
$fw(BuildNumber) \
$fw(PatchNumber) ]
unset fw
}
}


#
# goal: to be able to do compatible mode past 80 ports.
#
# This will require native mode, certainly, but needs to overlay it with a port
# number that will increment like the slot number in compatible mode, except without
# the hub number incrementing.  Well, to the user, the hub number and slot number are
# transparent.
#
proc inventoryTheSmb { logChList { quiet 0 } } {
variable info
variable oldLogChList

variable purePortIndex
pputs "inventoryTheSmbChassis:$bl::VERBOSE $logChList"

if { [info exists bl::purePortIndex] } {
  set bl::purePortIndex 1
}

#if the user is rearranging the chassislist, then reset ports
if { [info exists bl::oldLogChList] } {
  set logChIndex [expr [lindex $logChList 0] -1]
  foreach logCh $logChList {
    incr logChIndex
    if { [lindex $bl::oldLogChList $logChIndex] == $logCh } {
      #puts "here we are, so setting to zero"
      set bl::purePortIndex 1
    }
  }
} else {
  #puts "zero!!!"
  set logChIndex [expr [lindex $logChList 0] -1]
  set bl::purePortIndex 1
}
set bl::purePortIndex 1

#
#set purePortIndex [expr $purePortIndex + -1 + [lindex $logChList 0]]
if { [llength $logChList] < 2 } {
  set logChIndex [expr [lindex $logChList 0] -1]
}
set logChIndex [expr [lindex $logChList 0] -1]
foreach logCh $logChList {
  if { ! [info exists bl::info(log.chassisInventoried.$logCh)] } {
    set bl::info(log.chassisInventoried.$logCh) 0
  }
  #puts "logged:$bl::info(log.chassisInventoried.$logCh) for chassis:$logCh"
  incr logChIndex
  if { $bl::info(log.chassisInventoried.$logCh) == 1 && ! $bl::info(explicit_show_flag)} {
      set quiet "quiet"
  } else {
    set quiet "noisy"
  }

  if { $quiet != "quiet" } {
  showChassisFirmware $logChIndex
  vputs ""
  set column(1) 8
  set column(2) 12
  set column(3) 7
  set column(4) 6
  set column(5) 6
  set column(6) 7
  set column(7) 10
  set column(8) 9
  set column(9) 5
  set column(10) 10

  vputs -nonewline [format %-$column(1)s Logical]
  vputs -nonewline [format %-$column(2)s Card]
  vputs -nonewline [format %-$column(3)s Layer]
  vputs -nonewline [format %-$column(4)s Layer]
  vputs -nonewline [format %-$column(5)s Layer]
  vputs -nonewline [format %-$column(6)s Layer]
  vputs -nonewline [format %-$column(7)s Card]
  vputs -nonewline [format %-$column(8)s Library]
  vputs -nonewline [format %-$column(9)s " "]
  vputs -nonewline [format %-$column(10)s " "]
  vputs ""

  vputs -nonewline [format %-$column(1)s Port]
  vputs -nonewline [format %-$column(2)s Model]
  vputs -nonewline [format %-$column(3)s 1]
  vputs -nonewline [format %-$column(4)s 2]
  vputs -nonewline [format %-$column(5)s 3]
  vputs -nonewline [format %-$column(6)s 4-7]
  vputs -nonewline [format %-$column(7)s Firmware]
  vputs -nonewline [format %-$column(8)s H/S/P]
  vputs -nonewline [format %-$column(9)s Slot]
  vputs -nonewline [format %-$column(10)s Serial#]
  vputs ""

  vputs -nonewline [format %-$column(1)s "[string repeat - [minus $column(1)]] "]
  vputs -nonewline [format %-$column(2)s "[string repeat - [minus $column(2)]] "]
  vputs -nonewline [format %-$column(3)s "[string repeat - [minus $column(3)]] "]
  vputs -nonewline [format %-$column(4)s "[string repeat - [minus $column(4)]] "]
  vputs -nonewline [format %-$column(5)s "[string repeat - [minus $column(5)]] "]
  vputs -nonewline [format %-$column(6)s "[string repeat - [minus $column(6)]] "]
  vputs -nonewline [format %-$column(7)s "[string repeat - [minus $column(7)]] "]
  vputs -nonewline [format %-$column(8)s "[string repeat - [minus $column(8)]] "]
  vputs -nonewline [format %-$column(9)s "[string repeat - [minus $column(9)]] "]
  vputs -nonewline [format %-$column(10)s "[string repeat - $column(10)] "]
  vputs ""
  };#endif quiet

  set perChassisLogPortIndex 0
  set libCh $bl::info(log.libchassis.$logChIndex)
  if { ! $bl::info(log.chassisInventoried.$logCh) } {
    set bl::info(log.chassisSlots.$logCh) [NSGetNumSlots $libCh]
  }
  set numSlotsForThisChassis $bl::info(log.chassisSlots.$logCh)
  set oldslot -1
  for { set logSlot 1 } { $logSlot <= $numSlotsForThisChassis } { incr logSlot } {
    set libSlot [minus $logSlot]
    if { ! $bl::info(log.chassisInventoried.$logCh) } {
      set bl::info(lib.portsPerSlot.$libCh.$libSlot) [bl::check NSGetNumPorts $libCh $libSlot]
    }
    set numPortsForThisSlot $bl::info(lib.portsPerSlot.$libCh.$libSlot)
    set perSlotLogPortIndex 0
    for { set logPort 1 } { $logPort <= $numPortsForThisSlot } { incr logPort } {
      set libPort [minus $logPort]
      set cardinfo ""
      if { ! $bl::info(log.chassisInventoried.$logCh) } {
        bl::check HTGetCardModel cardinfo $libCh $libSlot $libPort
        #puts "cardinfo $cardinfo debug $libCh/$libSlot/$libPort $bl::purePortIndex 2222"
        set info(pure.$bl::purePortIndex.cardmodel) $cardinfo
      }
      set cardinfo $bl::info(pure.$bl::purePortIndex.cardmodel)
      if { $cardinfo != "No Card Present" } {
        incr perChassisLogPortIndex
        incr perSlotLogPortIndex
        if { ! $bl::info(log.chassisInventoried.$logCh) } {
          pdputs "reserving slot $libCh/libSlot"
          set k [HTSlotReserve $libCh $libSlot]

          if { $k < 0 } {
            set firmware "reserved"
            set sernum ?
          } else {
            struct_new nfw CardFWVersionStructure
            bl::check HTGetCardFWVersion nfw $libCh $libSlot $libPort
            set firmware [format "%s.%s.%s" $nfw(uiMajorNumber) $nfw(uiMinorNumber) $nfw(uiBuildNumber)]
            unset nfw
            #get serial number
            set sernum 0
            catch { struct_new myNSCardHardwareInfo NSCardHardwareInfo }
            bl::check HTGetStructure $SMB::NS_CARD_HARDWARE_INFO 0 0 0 myNSCardHardwareInfo 0 $libCh $libSlot $libPort
            set sernum $myNSCardHardwareInfo(ucSerialNumber)
            set result ""
            foreach ss $sernum {
                if { $ss != 0 } { append result [format %c $ss] }
            }
            set sernum $result
          }
          if { ! [info exists info(pure.$bl::purePortIndex.cardmodel)] } {
            HTSlotRelease $libCh $libSlot
          }
          set info(pure.$bl::purePortIndex.hsp) $libCh/$libSlot/$libPort
          set info(pure.$bl::purePortIndex.hub) $libCh
          set info(pure.$bl::purePortIndex.slot) $libSlot
          set info(pure.$bl::purePortIndex.port) $libPort
          set info(pure.$bl::purePortIndex.loghub) $logCh
          set info(pure.$bl::purePortIndex.logslot) [plus $libSlot]
          set info(pure.$bl::purePortIndex.logport) [plus $libPort]

          set uu [string range $cardinfo 0 3]
          if { [string range $cardinfo 4 4] == "6" } {
            set cardinfo [lindex [split $cardinfo /] 1]
            set cardinfo $uu$cardinfo
          }
          set cardinfo [string trimright $cardinfo ABCD]
          #puts "cardinfo debug $libCh/$libSlot/$libPort $bl::purePortIndex"
          set info(pure.$bl::purePortIndex.cardmodel) $cardinfo
          set info(pure.$bl::purePortIndex.technology) $bl::CARDS($cardinfo.technology)
          set info(pure.$bl::purePortIndex.cable) $bl::CARDS($cardinfo.cable)
          set info(pure.$bl::purePortIndex.streams) $bl::CARDS($cardinfo.streams)
          set info(pure.$bl::purePortIndex.firmware) $firmware
          set info(lib.$libCh/$libSlot/$libPort.purePortIndex) $bl::purePortIndex
          #puts "here brett info(lib.$libCh/$libSlot/$libPort.purePortIndex)=$purePortIndex"
          set info(lib.$libCh.$libSlot.$libPort.cardmodel) $cardinfo
          set info(lib.$libCh/$libSlot/$libPort.cardmodel) $cardinfo
          # BW 11/26/2003 5:13 PM
          lappend info(pure.portlist) $bl::purePortIndex
          lappend info(logCh.portlist.$logCh) $bl::purePortIndex
          set info(pure.numports) [llength $bl::info(pure.portlist)]
          # BW 7/25/2003 1:20 PM
          pdputs "Releasing slot $libCh/$libSlot"
          HTSlotRelease $libCh $libSlot
        }
        if { $quiet != "quiet" } {
          vputs  -nonewline [format %-$column(1)s $bl::purePortIndex]
          set cardinfo $bl::info(pure.$bl::purePortIndex.cardmodel)
          set uu [string range $cardinfo 0 3]
          if { [string range $cardinfo 4 4] == "6" } {
            set cardinfo [lindex [split $cardinfo / ] 1]
            set cardinfo $uu$cardinfo
          }
          if { $logSlot != $oldslot } {
            set oldslot $logSlot
            vputs  -nonewline [format %-$column(2)s [string trim $cardinfo]]
            vputs  -nonewline [format %-$column(3)s $bl::CARDS($cardinfo.cable) ]
            vputs  -nonewline [format %-$column(4)s $bl::CARDS($cardinfo.technology) ]
            vputs  -nonewline [format %-$column(5)s $bl::CARDS($cardinfo.streams) ]
            vputs  -nonewline [format %-$column(6)s $bl::CARDS($cardinfo.layer4-7) ]
            vputs  -nonewline [format %-$column(7)s $info(pure.$bl::purePortIndex.firmware)]
            vputs  -nonewline [format %-$column(8)s $libCh/$libSlot/$libPort]
            vputs  -nonewline [format %-$column(9)s $info(pure.$bl::purePortIndex.logslot) ]
            vputs  [format %-$column(10)s $sernum]
          } else {
            vputs  -nonewline [format %-$column(2)s " "]
            vputs  -nonewline [format %-$column(3)s " " ]
            vputs  -nonewline [format %-$column(4)s " " ]
            vputs  -nonewline [format %-$column(5)s " " ]
            vputs  -nonewline [format %-$column(6)s  " " ]
            vputs  -nonewline [format %-$column(7)s " " ]
            vputs  -nonewline [format %-$column(8)s $libCh/$libSlot/$libPort]
            vputs  -nonewline [format %-$column(9)s " " ]
            vputs  [format %-$column(10)s " " ]
          }
        };#endif quiet or not
        ## BW 7/7/2003 11:45 AM MAJOR BUG!!! puts bl::purPortIndex:$bl::purePortIndex
        incr bl::purePortIndex
      };#endif there is a card in that slot or if the slot is just empty
    };#endfor each logical port
  };#endfor each logical slot
  set bl::info(log.chassisInventoried.$logCh) 1
};#endforeach logical chassis
set bl::oldLogChList $logChList
};#endproc inventoryTheSmb


proc offlineinventoryTheSmb { logChList { quiet 0 } } {
variable info
variable oldLogChList

variable purePortIndex
pputs "inventoryTheSmbChassis:$bl::VERBOSE $logChList"

if { [info exists bl::purePortIndex] } {
  set bl::purePortIndex 1
}

#if the user is rearranging the chassislist, then reset ports
if { [info exists bl::oldLogChList] } {
  set logChIndex [expr [lindex $logChList 0] -1]
  foreach logCh $logChList {
    incr logChIndex
    if { [lindex $bl::oldLogChList $logChIndex] == $logCh } {
      #puts "here we are, so setting to zero"
      set bl::purePortIndex 1
    }
  }
} else {
  #puts "zero!!!"
  set logChIndex [expr [lindex $logChList 0] -1]
  set bl::purePortIndex 1
}
set bl::purePortIndex 1

#
#set purePortIndex [expr $purePortIndex + -1 + [lindex $logChList 0]]
if { [llength $logChList] < 2 } {
  set logChIndex [expr [lindex $logChList 0] -1]
}
set logChIndex [expr [lindex $logChList 0] -1]
foreach logCh $logChList {
  if { ! [info exists bl::info(log.chassisInventoried.$logCh)] } {
    set bl::info(log.chassisInventoried.$logCh) 0
  }
  #puts "logged:$bl::info(log.chassisInventoried.$logCh) for chassis:$logCh"
  incr logChIndex
  if { $bl::info(log.chassisInventoried.$logCh) == 1 && ! $bl::info(explicit_show_flag)} {
      set quiet "quiet"
  } else {
    set quiet "noisy"
  }

  if { $quiet != "quiet" } {
  offlineshowChassisFirmware $logChIndex
  vputs ""
  set column(1) 8
  set column(2) 12
  set column(3) 7
  set column(4) 6
  set column(5) 6
  set column(6) 7
  set column(7) 10
  set column(8) 9
  set column(9) 5
  set column(10) 10

  vputs -nonewline [format %-$column(1)s Logical]
  vputs -nonewline [format %-$column(2)s Card]
  vputs -nonewline [format %-$column(3)s Layer]
  vputs -nonewline [format %-$column(4)s Layer]
  vputs -nonewline [format %-$column(5)s Layer]
  vputs -nonewline [format %-$column(6)s Layer]
  vputs -nonewline [format %-$column(7)s Card]
  vputs -nonewline [format %-$column(8)s Library]
  vputs -nonewline [format %-$column(9)s " "]
  vputs -nonewline [format %-$column(10)s " "]
  vputs ""

  vputs -nonewline [format %-$column(1)s Port]
  vputs -nonewline [format %-$column(2)s Model]
  vputs -nonewline [format %-$column(3)s 1]
  vputs -nonewline [format %-$column(4)s 2]
  vputs -nonewline [format %-$column(5)s 3]
  vputs -nonewline [format %-$column(6)s 4-7]
  vputs -nonewline [format %-$column(7)s Firmware]
  vputs -nonewline [format %-$column(8)s H/S/P]
  vputs -nonewline [format %-$column(9)s Slot]
  vputs -nonewline [format %-$column(10)s Serial#]
  vputs ""

  vputs -nonewline [format %-$column(1)s "[string repeat - [minus $column(1)]] "]
  vputs -nonewline [format %-$column(2)s "[string repeat - [minus $column(2)]] "]
  vputs -nonewline [format %-$column(3)s "[string repeat - [minus $column(3)]] "]
  vputs -nonewline [format %-$column(4)s "[string repeat - [minus $column(4)]] "]
  vputs -nonewline [format %-$column(5)s "[string repeat - [minus $column(5)]] "]
  vputs -nonewline [format %-$column(6)s "[string repeat - [minus $column(6)]] "]
  vputs -nonewline [format %-$column(7)s "[string repeat - [minus $column(7)]] "]
  vputs -nonewline [format %-$column(8)s "[string repeat - [minus $column(8)]] "]
  vputs -nonewline [format %-$column(9)s "[string repeat - [minus $column(9)]] "]
  vputs -nonewline [format %-$column(10)s "[string repeat - $column(10)] "]
  vputs ""
  };#endif quiet

  set perChassisLogPortIndex 0
  set libCh $bl::info(log.libchassis.$logChIndex)
  if { ! $bl::info(log.chassisInventoried.$logCh) } {
    set bl::info(log.chassisSlots.$logCh) [NSGetNumSlots $libCh]
  }
  set numSlotsForThisChassis $bl::info(log.chassisSlots.$logCh)
  set oldslot -1
  for { set logSlot 1 } { $logSlot <= $numSlotsForThisChassis } { incr logSlot } {
    set libSlot [minus $logSlot]
    if { ! $bl::info(log.chassisInventoried.$logCh) } {
      set bl::info(lib.portsPerSlot.$libCh.$libSlot) [bl::check NSGetNumPorts $libCh $libSlot]
    }
    set numPortsForThisSlot $bl::info(lib.portsPerSlot.$libCh.$libSlot)
    set perSlotLogPortIndex 0
    for { set logPort 1 } { $logPort <= $numPortsForThisSlot } { incr logPort } {
      set libPort [minus $logPort]
      set cardinfo ""
      if { ! $bl::info(log.chassisInventoried.$logCh) } {
        bl::check HTGetCardModel cardinfo $libCh $libSlot $libPort
        #puts "cardinfo $cardinfo debug $libCh/$libSlot/$libPort $bl::purePortIndex 2222"
        set info(pure.$bl::purePortIndex.cardmodel) $cardinfo
      }
      set cardinfo $bl::info(pure.$bl::purePortIndex.cardmodel)
      if { $cardinfo != "No Card Present" } {
        incr perChassisLogPortIndex
        incr perSlotLogPortIndex
        if { ! $bl::info(log.chassisInventoried.$logCh) } {
          pdputs "reserving slot $libCh/libSlot"
          set k [HTSlotReserve $libCh $libSlot]

          if { $k < 0 } {
            set firmware "reserved"
            set sernum ?
          } else {
            struct_new nfw CardFWVersionStructure
            bl::check HTGetCardFWVersion nfw $libCh $libSlot $libPort
            set firmware [format "%s.%s.%s" $nfw(uiMajorNumber) $nfw(uiMinorNumber) $nfw(uiBuildNumber)]
            unset nfw
            #get serial number
            set sernum 0
            catch { struct_new myNSCardHardwareInfo NSCardHardwareInfo }
            bl::check HTGetStructure $SMB::NS_CARD_HARDWARE_INFO 0 0 0 myNSCardHardwareInfo 0 $libCh $libSlot $libPort
            set sernum $myNSCardHardwareInfo(ucSerialNumber)
            set result ""
            foreach ss $sernum {
                if { $ss != 0 } { append result [format %c $ss] }
            }
            set sernum $result
          }
          if { ! [info exists info(pure.$bl::purePortIndex.cardmodel)] } {
            HTSlotRelease $libCh $libSlot
          }
          set info(pure.$bl::purePortIndex.hsp) $libCh/$libSlot/$libPort
          set info(pure.$bl::purePortIndex.hub) $libCh
          set info(pure.$bl::purePortIndex.slot) $libSlot
          set info(pure.$bl::purePortIndex.port) $libPort
          set info(pure.$bl::purePortIndex.loghub) $logCh
          set info(pure.$bl::purePortIndex.logslot) [plus $libSlot]
          set info(pure.$bl::purePortIndex.logport) [plus $libPort]

          set uu [string range $cardinfo 0 3]
          if { [string range $cardinfo 4 4] == "6" } {
            set cardinfo [lindex [split $cardinfo /] 1]
            set cardinfo $uu$cardinfo
          }
          set cardinfo [string trimright $cardinfo ABCD]
          #puts "cardinfo debug $libCh/$libSlot/$libPort $bl::purePortIndex"
          set info(pure.$bl::purePortIndex.cardmodel) $cardinfo
          set info(pure.$bl::purePortIndex.technology) $bl::CARDS($cardinfo.technology)
          set info(pure.$bl::purePortIndex.cable) $bl::CARDS($cardinfo.cable)
          set info(pure.$bl::purePortIndex.streams) $bl::CARDS($cardinfo.streams)
          set info(pure.$bl::purePortIndex.firmware) $firmware
          set info(lib.$libCh/$libSlot/$libPort.purePortIndex) $bl::purePortIndex
          #puts "here brett info(lib.$libCh/$libSlot/$libPort.purePortIndex)=$purePortIndex"
          set info(lib.$libCh.$libSlot.$libPort.cardmodel) $cardinfo
          set info(lib.$libCh/$libSlot/$libPort.cardmodel) $cardinfo
          # BW 11/26/2003 5:13 PM
          lappend info(pure.portlist) $bl::purePortIndex
          lappend info(logCh.portlist.$logCh) $bl::purePortIndex
          set info(pure.numports) [llength $bl::info(pure.portlist)]
          # BW 7/25/2003 1:20 PM
          pdputs "Releasing slot $libCh/$libSlot"
          HTSlotRelease $libCh $libSlot
        }
        if { $quiet != "quiet" } {
          vputs  -nonewline [format %-$column(1)s $bl::purePortIndex]
          set cardinfo $bl::info(pure.$bl::purePortIndex.cardmodel)
          set uu [string range $cardinfo 0 3]
          if { [string range $cardinfo 4 4] == "6" } {
            set cardinfo [lindex [split $cardinfo / ] 1]
            set cardinfo $uu$cardinfo
          }
          if { $logSlot != $oldslot } {
            set oldslot $logSlot
            vputs  -nonewline [format %-$column(2)s [string trim $cardinfo]]
            vputs  -nonewline [format %-$column(3)s $bl::CARDS($cardinfo.cable) ]
            vputs  -nonewline [format %-$column(4)s $bl::CARDS($cardinfo.technology) ]
            vputs  -nonewline [format %-$column(5)s $bl::CARDS($cardinfo.streams) ]
            vputs  -nonewline [format %-$column(6)s $bl::CARDS($cardinfo.layer4-7) ]
            vputs  -nonewline [format %-$column(7)s $info(pure.$bl::purePortIndex.firmware)]
            vputs  -nonewline [format %-$column(8)s $libCh/$libSlot/$libPort]
            vputs  -nonewline [format %-$column(9)s $info(pure.$bl::purePortIndex.logslot) ]
            vputs  [format %-$column(10)s $sernum]
          } else {
            vputs  -nonewline [format %-$column(2)s " "]
            vputs  -nonewline [format %-$column(3)s " " ]
            vputs  -nonewline [format %-$column(4)s " " ]
            vputs  -nonewline [format %-$column(5)s " " ]
            vputs  -nonewline [format %-$column(6)s  " " ]
            vputs  -nonewline [format %-$column(7)s " " ]
            vputs  -nonewline [format %-$column(8)s $libCh/$libSlot/$libPort]
            vputs  -nonewline [format %-$column(9)s " " ]
            vputs  [format %-$column(10)s " " ]
          }
        };#endif quiet or not
        ## BW 7/7/2003 11:45 AM MAJOR BUG!!! puts bl::purPortIndex:$bl::purePortIndex
        incr bl::purePortIndex
      };#endif there is a card in that slot or if the slot is just empty
    };#endfor each logical port
  };#endfor each logical slot
  set bl::info(log.chassisInventoried.$logCh) 1
};#endforeach logical chassis
set bl::oldLogChList $logChList
catch { update }
};#endproc offlineinventoryTheSmb

proc show { { params smartbits } {arglist -1 } } {
  set thingtoshow [lindex $params 0]
  set arglist [lindex $params 1]
  if { $arglist != "" \
    && \
    $arglist != " " \
    && \
    [string length $arglist] < 3 \
    && \
    -1 == [string first = $arglist] } {
    set arglist "port=$arglist"
  }
  switch $thingtoshow {
    smb -
    hw -
    chassis -
    smartbit -
    hardware -
    inventory -
    smartbits { set bl::info(explicit_show_flag) 1; showSmartbits $arglist }
    libver -
    library -
    lib -
    smartlib { showSmartLib }
    counters { counters $arglist }
    cardmodel -
    cardtype -
    cardname -
    cardModel -
    cardName -
    cardType { showCardModel $arglist }
    streams -
    streamcounts -
    perstreamcounters -
    streamCounters -
    streamcounters -
    perStreamCounters { showPerStreamCounters $arglist }
    array { arrayShow $arglist }
    cards -
    reserved -
    mycard -
    cardslist -
    cardlist { puts $bl::info(reservelist) }
    group { puts [findgroup] }
    config { showconfig }
    default {
      puts "show config\\nshow smartbits\nshow reserved\nshow group\nshow cardmodel\nshow counters\nshow streamcounts"
    }
  }
}


proc clear { params } {
  set thing [lindex $params 0]
  set arglist [lindex $params 1]
  if { [string length $arglist] < 3 && -1 == [string first = $arglist] } {
    set arglist "port=$arglist"
  }
  switch $thing {
    counters { clearCounters $arglist }
    streams { clearStreams $arglist }
    default {
      puts "clear streams\nclear counters"
    }
  }
}



proc showchassis { { iplist -1 } } { showSmartbits $iplist }
proc showsmartbits { { iplist -1 } } { showSmartbits $iplist }

proc showSmartbits { { iplist -1 }  } {
pputs "showSmartbits"
  #if { $iplist == -1 } { return }
  #if { ! $bl::VERBOSE } { puts "I can't. You have bl::VERBOSE set to 0."; return }
  if { $iplist != -1 } {
    foreach smbip $iplist {
      linkIfNotAlreadyLinked $smbip
    }
  }
  set totalLinks [ETGetTotalLinks]
  catch { unset logChList }
  for { set logCh 1 } { $logCh <= $totalLinks } { incr logCh } {
    lappend logChList $logCh
  };#endfor each logical chassis
  inventoryTheSmb $logChList $bl::NOISY
  vputs ""
  vputs ""
  if { $iplist > -1 } {
    foreach smbip $iplist {
      bl::unlinkFromChassis $smbip
    }
  }
};#endproc show smartbits


proc unlink { {iplist -1} } {
  if { $iplist == -1 } {
    bl::unlinkAll
  } else {
    unlinkFromChassis $iplist
  }
}



proc unlinkFromChassis { iplist } {
  if { $iplist == -1 } { return }
  set lll 0
  foreach smbip $iplist {
    incr lll
    if { [info exists bl::info(chassisiplist) ] } {
      if { -1 == [lsearch $bl::info(chassisiplist) $smbip ] } {
        vputs "I Can't. You are not linked to $smbip!"
      } else {
        vputs -nonewline "Attempting to unlink on $smbip..."; flush stdout
        ETSetCurrentSockLink $smbip
        set link [ bl::check NSUnLink ]
        if { $link >= 0 } {
          if { [info exists bl::info(chassisiplist)] } {
            set bl::info(chassisiplist) \
            [lreplace $bl::info(chassisiplist) \
            [lsearch $bl::info(chassisiplist) $smbip] \
            [lsearch $bl::info(chassisiplist) $smbip] \
            ]
          }
          set bl::info(log.chassisInventoried.$lll) 0
          #find all the logical ports for this chassis and wipe them out...why?
          vputs "OK!"
        } else {
          vputs "Failed!  But, clearing the list of links anyway."
          if { [info exists bl::info(chassisiplist)] } {
          set bl::info(chassisiplist) \
          [lreplace $bl::info(chassisiplist) \
          [lsearch $bl::info(chassisiplist) $smbip] \
          [lsearch $bl::info(chassisiplist) $smbip] \
          ]
          }
        }
      }
    } else {
      vputs "I Can't. You are not linked to $smbip!"
    }
  }
}

proc unlinkAll { { param 1 } } {
  catch { unlinkFromChassis $bl::info(chassisiplist) }
}

proc showHardware  { {listOfIpaddresses "-1" } } { showSmartbits $listOfIpaddresses }

proc offlineshowChassisFirmware { logCh } {
  pputs "showChassisFirmware"
  vputs ""
  vputs ""
  vputs ""
  vputs "Chassis  IP               Chassis    Serial                 # of "
  vputs "Number   Address          Model      Number     Firmware    Blades "
  vputs "-------  -------------    ------     --------   --------    ------"
  set bladecounter 0
  vputs -nonewline [format %-9s $logCh]
  #puts "list:$bl::info(chassisiplist) pick:[minus $logCh]"
  set smbip [lindex $bl::info(chassisiplist) [minus $logCh]]
  vputs -nonewline [format %-17s $smbip]
  #ETSetCurrentSockLink $smbip
  set libCh $bl::info(log.libchassis.$logCh)
  #set numSlotsForThisChassis [NSGetNumSlots $libCh]
  set numSlotsForThisChassis 12
  set chassis "offline"
  #ETGetHardwareVersion chassis
  vputs -nonewline [format %-11s $chassis]
  set serial offline
  #ETGetSerialNumber serial
  vputs -nonewline [format %-11s $serial]
  set fwvers offline
  #ETGetFirmwareVersion fwvers
  set fwvers1 [string range $fwvers 5 5]
  set fwvers2 [string range $fwvers 6 8]
  set fwvers3 [string range $fwvers 2 4]
  set fwvers4 [string range $fwvers 1 1]
  set firmware "$fwvers1.$fwvers2.$fwvers3.$fwvers4"
  vputs -nonewline [format %-13s $firmware]
  for { set logSlot 1 } { $logSlot <= $numSlotsForThisChassis } { incr logSlot } {
    set libSlot [minus $logSlot]
    set cardinfo LAN-3325
    #bl::check HTGetCardModel cardinfo $libCh $libSlot 0
    if { $cardinfo == "No Card Present" } {
      set cardinfo "----------------"
    } else {
      incr bladecounter
    }
  }
  vputs [format %-10s "$bladecounter"]
}

proc showChassisFirmware { logCh } {
  pputs "showChassisFirmware"
  vputs ""
  vputs ""
  vputs ""
  vputs "Chassis  IP               Chassis    Serial                 # of "
  vputs "Number   Address          Model      Number     Firmware    Blades "
  vputs "-------  -------------    ------     --------   --------    ------"
  set bladecounter 0
  vputs -nonewline [format %-9s $logCh]
  #puts "list:$bl::info(chassisiplist) pick:[minus $logCh]"
  set smbip [lindex $bl::info(chassisiplist) [minus $logCh]]
  vputs -nonewline [format %-17s $smbip]
  ETSetCurrentSockLink $smbip
  set libCh $bl::info(log.libchassis.$logCh)
  set numSlotsForThisChassis [NSGetNumSlots $libCh]
  set numSlotsForThisChassis 12
  set chassis ""
  ETGetHardwareVersion chassis
  vputs -nonewline [format %-11s $chassis]
  set serial ""
  ETGetSerialNumber serial
  vputs -nonewline [format %-11s $serial]
  set fwvers ""
  ETGetFirmwareVersion fwvers
  set fwvers1 [string range $fwvers 5 5]
  set fwvers2 [string range $fwvers 6 8]
  set fwvers3 [string range $fwvers 2 4]
  set fwvers4 [string range $fwvers 1 1]
  set firmware "$fwvers1.$fwvers2.$fwvers3.$fwvers4"
  vputs -nonewline [format %-13s $firmware]
  for { set logSlot 1 } { $logSlot <= $numSlotsForThisChassis } { incr logSlot } {
    set libSlot [minus $logSlot]
    set cardinfo ""
    bl::check HTGetCardModel cardinfo $libCh $libSlot 0
    if { $cardinfo == "No Card Present" } {
      set cardinfo "----------------"
    } else {
      incr bladecounter
    }
  }
  vputs [format %-10s "$bladecounter"]
}


proc connect { ipaddress { quiet 0 } } {  return [linkIfNotAlreadyLinked $ipaddress $quiet] }
proc link { ipaddress { quiet 0 } } {  return [linkIfNotAlreadyLinked $ipaddress $quiet] }
proc quicklink { ipaddress } {   return [linkIfNotAlreadyLinked $ipaddress $quiet] }

proc offlinelink { ipaddress { quiet 0 } } {  return [offlinelinkIfNotAlreadyLinked $ipaddress $quiet] }


proc offlinelinkToSmb { iplist { quiet 0 } } {
  pputs "START offlinelink to smb"
  foreach smbip $iplist {
    vputs -nonewline "Trying to link to Smartbits on IP $smbip..."; flush stdout
    #catch { update }
    #set x [ NSSocketLink $smbip 16385 $SMB::RESERVE_NONE]
    set x 1
    if { $x > 0 } {
      #NSSetPortMappingMode $SMB::PORT_MAPPING_NATIVE
      set logCh [bl::calcLogCh $smbip]
      set contid [expr ($logCh - 1) * 4]
      #NSSetControllerID $contid
      vputs "OK!"
    } else {
      vputs "Failed!"
      return -1
    }
  }
  #set totalLinks [ETGetTotalLinks]
  set totalLinks 1
  catch { unset logChList }
  for { set logCh 1 } { $logCh <= $totalLinks } { incr logCh } {
    lappend logChList $logCh
  }

  if { [info exist logChList] } {
    offlineinventoryTheSmb $logChList $quiet
  }
  pputs "END offlinelink to smb"
}

proc linkToSmb { iplist { quiet 0 } } {
  foreach smbip $iplist {
    vputs -nonewline "Trying to link to Smartbits on IP $smbip..."; flush stdout
    set x [ NSSocketLink $smbip 16385 $SMB::RESERVE_NONE]
    if { $x > 0 } {
      NSSetPortMappingMode $SMB::PORT_MAPPING_NATIVE
      set logCh [bl::calcLogCh $smbip]
      set contid [expr ($logCh - 1) * 4]
      NSSetControllerID $contid
      vputs "OK!"
    } else {
      vputs "Failed!"
      return -1
    }
  }
  set totalLinks [ETGetTotalLinks]
  catch { unset logChList }
  for { set logCh 1 } { $logCh <= $totalLinks } { incr logCh } {
    lappend logChList $logCh
  }
  if { [info exist logChList] } {
    inventoryTheSmb $logChList $quiet
  }
}


proc linked { ipaddress } { return [islinked $ipaddress] }
proc islinked { ipaddress } {
  if { ! [info exists bl::info(chassisiplist)] } { return 0 }
  if { -1 == [lsearch $bl::info(chassisiplist) $ipaddress] } {
    return 0
  } else {
    return 1
  }
}

proc offlinelinkIfNotAlreadyLinked { iplist { quiet 0 } } {
pputs "START linkIfNotAlreadyLinked"
variable info
set bl::info(explicit_show_flag) 0
if { [string first , $iplist] > -1 } {
  set iplist [split $iplist ,]
}
if { $iplist == -1 } { return }
foreach ipaddress $iplist {
  set ipaddress [string trim $ipaddress]
  variable info
  if { ! [info exists info(chassisiplist)] } {
    set retval [offlinelinkToSmb $ipaddress $quiet]
    if { $retval == -1 } {
      return -1
    }
  } else {
    if { -1 == [lsearch $bl::info(chassisiplist) $ipaddress] } {
      set retval [offlinelinkToSmb $ipaddress $quiet]
      if { $retval == -1 } {
        return -1
      }
    } else {
      vputs "Already linked to Smartbits on $ipaddress."
    }
  }
}
pputs "END linkIfNotAlreadyLinked"
}

proc linkIfNotAlreadyLinked { iplist { quiet 0 } } {
pputs "linkIfNotAlreadyLinked"
variable info
set bl::info(explicit_show_flag) 0
if { [string first , $iplist] > -1 } {
  set iplist [split $iplist ,]
}
if { $iplist == -1 } { return }
foreach ipaddress $iplist {
  set ipaddress [string trim $ipaddress]
  variable info
  if { ! [info exists info(chassisiplist)] } {
    set retval [linkToSmb $ipaddress $quiet]
    if { $retval == -1 } {
      return -1
    }
  } else {
    if { -1 == [lsearch $bl::info(chassisiplist) $ipaddress] } {
      set retval [linkToSmb $ipaddress $quiet]
      if { $retval == -1 } {
        return -1
      }
    } else {
      vputs "Already linked to Smartbits on $ipaddress."
    }
  }
}
}

proc getlogCh  { ip } { return [calcLogCh $ip] }
proc findlogCh { ip } { return [calcLogCh $ip] }

proc calcLogCh { ipaddress} {
  variable info
  #catch { puts $info(chassisiplist) }
  lappendUnique info(chassisiplist) $ipaddress
  #puts "YO!!! $info(chassisiplist) should now have $ipaddress in it!"
  set logCh [expr [lsearch $bl::info(chassisiplist) $ipaddress ] +1]
  set libCh [expr 4 * [minus $logCh]]
  lappendUnique info(log.chassislist) $logCh
  lappendUnique info(lib.chassislist) $libCh
  set info(log.libchassis.$logCh) $libCh
  set info(lib.logchasiss.$libCh) $logCh
  return $logCh
}

proc fakelink { ipaddress } {
  variable info
  if { ! [info exists info(chassisiplist)] } {
    set logCh [bl::calcLogCh $ipaddress]
  } else {
    set x [lsearch $bl::info(chassisiplist) $ipaddress]
    if { -1 == $x } {
      set logCh [bl::calcLogCh $ipaddress]
    }
  }
  bl::inventoryTheSmb $logCh $bl::QUIET
}

proc groupreserve { { params -1 } }  {  reserveCard [findgroup] }
proc reserve { params } { reserveCard $params }
proc reservePort { params } { reserveCard $params }
proc reserveSlot { params } { reserveCard $params }

proc release  { params } { releaseCard $params }
proc releaseSlot { params } { releaseCard $params }
proc releasePort  { params } { releaseCard $params }

proc reserveCard { params } {
set retval 1
pputs "reserveCard $params"
eval $bl::macro1
#puts "ports:$ports portslen:$portslen"
set donealready 0
foreach port $ports {
eval $bl::macro2
if { [info exists bl::info(reservelist) ] } {
  if { -1 == [lsearch $bl::info(reservelist) $h/$s] } {
    if { $donealready == 0 } {
      vputs -nonewline "Reserving slot "
      set donealready 1
    }
    vputs -nonewline "$h/$s/*"
    set x [HTSlotReserve $h $s]
    if { $x > -1 } {
      lappend bl::info(reservelist) $h/$s
      if { $portcounter < $portslen } {
        vputs -nonewline ","
      } else {
        vputs ""
      }
      set retval 1
    } else {
      vputs -nonewline "(failed) "; set retval 0
    }
  } else {
    vputs "Already reserved $h/$s/*"
  }
} else {
  if { $donealready == 0 } {
    vputs -nonewline "Reserving slot "
    set donealready 1
  }
  vputs -nonewline "$h/$s/*"
  set x [HTSlotReserve $h $s]
  if { $x > -1 } {
    lappend bl::info(reservelist) $h/$s
    if { $portcounter < $portslen } {
      vputs -nonewline ","
    } else {
      vputs ""
    }
    set retval 1
  } else {
    puts -nonewline "(failed) "; set retval 0
  }
}
}
return $retval
}

proc reserveCardwithCorrectControllerID { params } {
set retval 1
pputs "reserveCard $params"

eval $bl::macro1
#puts "ports:$ports portslen:$portslen"
set donealready 0
foreach port $ports {
eval $bl::macro2
if { [info exists bl::info(reservelist) ] } {
  if { -1 == [lsearch $bl::info(reservelist) $h/$s] } {
    if { $donealready == 0 } {
      vputs -nonewline "Reserving slot "
      set donealready 1
    }
    vputs -nonewline "$h/$s/*"
    set x [HTSlotReserve $h $s]
    puts x:$x
    if { $x > -1 } {
      lappend bl::info(reservelist) $h/$s
      if { $portcounter < $portslen } {
        vputs -nonewline ","
      } else {
        vputs ""
      }
      catch {unset addr}
      struct_new addr Layer3Address
      set addr(iControl) 0x0080
      HTLayer3SetAddress addr $h $s 0
      unset addr
      set smbip [lindex $bl::info(chassisiplist) \
      [lsearch $bl::info(lib.chassislist) $h]]
      ETSetCurrentSockLink $smbip
      NSSetControllerID $h
      set retval 1
    } else {
      vputs -nonewline "(failed) "; set retval 0
    }
  } else {
    vputs "Already reserved $h/$s/*"
  }

} else {
  if { $donealready == 0 } {
    vputs -nonewline "Reserving slot "
    set donealready 1
  }
  vputs -nonewline "$h/$s/*"
  set x [HTSlotReserve $h $s]
  if { $x > -1 } {
    lappend bl::info(reservelist) $h/$s
    if { $portcounter < $portslen } {
      vputs -nonewline ","
    } else {
      vputs ""
    }
    set retval 1
  } else {
    vputs -nonewline "(failed) "; set retval 0
  }
}
}
return $retval
}

proc releaseCard { params } {
pputs "releaseCard"

eval $bl::macro1

  foreach port $ports {
  eval $bl::macro2
  if { [info exists bl::info(reservelist) ] } {
    if { -1 != [lsearch $bl::info(reservelist) $h/$s] } {
      vputs -nonewline "Releasing $h/$s/*..."
      set x [bl::check HTSlotRelease $h $s]
      if { $x > -1 } {
        set bl::info(reservelist) \
        [lreplace $bl::info(reservelist) \
        [lsearch $bl::info(reservelist) $h/$s ] \
        [lsearch $bl::info(reservelist) $h/$s ] \
        ]
        vputs "OK!"
      } else {
        vputs "failed"
      }
    } else {
      vputs "You have not even reserved $h/$s/*"
    }
  } else {
    vputs "You have not even reserved any cards at all"
  }
  }
}


#set bl::FIRMWARE_SOURCED 1

}


###
# bl57-misc.tcl
###

if { ! [info exists bl::MISC_SOURCED] } {

namespace eval bl {


##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# MISCELLANEOUS FUNCTIONS SECTION
# ----------------
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################

#set tree [treeme ./]
#puts $tree
proc treeme { ff { dl "" } { indent 0 } } {
	set files [glob -nocomplain *]
	foreach ff $files {
		if { [file isdirectory $ff] } {
			set j ""
			for { set i 0 } { $i < $indent } { incr i } { append j " " }
			#puts "$j\[$ff\]"
			append dl "$j\[$ff\]\n"
			cd $ff
			incr indent
			set dl [treeme $ff $dl $indent]
			incr indent -1
			cd ..
		} else {
			set j ""
			for { set i 0 } { $i < $indent } { incr i } { append j " " }
			#puts "$j$ff"
			append dl "$j$ff\n"
		}
		#after 50
	}
	return $dl
}


proc pathme { {path ""} { tree "" } } {
	set files [glob -nocomplain *]
	foreach f $files {
		if { [file isdirectory $f] } {
			append path /$f
			cd $f
			set tree [pathme $path $tree]
			cd ..
			set path [string trim $path /$f]
		} else {
			append tree "$path/$f\n"
			#puts $path/$f
			#after 100
		}
	}
	return $tree
}


#copyfiletree ../newroot .
proc copyfiletree { targetdir sourcedir } {
	set pwd1 [pwd]
	cd $sourcedir
	set tree [pathme $sourcedir]
	foreach pathfile [split $tree \n] {
		#puts $pathfile
		after 100
		set p [split $pathfile /]
		set i 0
		set j [expr [llength $p] -1]
		set pwd [pwd]
		cd $targetdir
		for { set i 0 } { $i < $j } { incr i } {
			set k [lindex $p $i]
			catch { file mkdir $k }
			cd $k
		}
		set pp [pwd]
		#puts "We are in $pp and we are going to copy $pathfile here"
		cd $pwd
		if { $pathfile != "" } {
			catch { file copy $pathfile $pp } h
			#puts $h
		}
	}
	cd $pwd1
}


proc lc { s } { return [string tolower $s] }
proc slashtomask { slash } {
  set full [expr $slash /8.0]
  set intf [expr int($full)]
  set deci [expr $full - $intf]
  for { set i 0 } { $i < $intf } { incr i } {
    append retval 255.
  }
  set t8 [expr $deci * 8 ]
  set uu 0
  #puts t8:$t8
  set dd 256
  for { set i 0 } { $i < $t8 } { incr i } {
    set dd [expr $dd / 2]
    set uu [expr $uu + $dd]
  }
  set retval $retval$uu
  while { [llength [split $retval .]] < 4 } {
    append retval .0
  }
  return $retval
}


proc int2bits {i} {
    #returns a bitslist, e.g. int2bits 10 => {1 0 1 0}
    set res ""
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res==""} {set res 0}
    split $res ""
}

proc bits2int {bits} {
    #returns integer equivalent of a bitlist
    set res 0
    foreach i $bits {
        set res [expr {$res*2+$i}]
    }
    set res
}

proc val2Bin val {
    set binRep [binary format c $val]
    binary scan $binRep B* binStr
    return $binStr
}

proc masktoslash { mask } {
  set retval 0
  foreach thing [split $mask .] {
    #puts thing:$thing
    if { [expr $thing / 255.0 ] == 1.0 } {
      incr retval 8
    } else {
      set bb [int2bits $thing]
      #puts "bb:$bb [llength $bb]"
      if { $bb != 0 } {
        for { set i 0 } { $i < 8 } { incr i } {
          set isit [lindex $bb $i]
          if { $isit } {
            incr retval
          }
        }
      }
    }
    #puts retval:$retval
  }
  return $retval
}

proc ping { smbip { max 2 } } {
  set okflag 0
  set temp 0
  while { ! $okflag && $temp <= $max } {
    bl::rputs -nonewline "Pinging $smbip..."
    flush stdout
    set retval 0
    set sssttt "100%"
    if { $::env(OS) != "SunOS" } {
      set retval [catch { set sssttt [exec ping $smbip -n 2] } err]
    } else {
      set retval [catch { set sssttt [exec ping $smbip] } err]
    }
    if { [string first "100%" $sssttt] > -1 || $retval } {
      incr temp
      bl::rputs "failed, retrying [expr $max - $temp] time(s)."
    } else {
      bl::rputs OK!
      set okflag 1
    }
  }
  return $okflag
}

#proc locateSMB { { params 0,0 } {filename -1} } { bl::smblocator $params $filename }
#proc smblocator { { iprange 0,0} {filename -1} } {
#  set ttt [split $iprange ,]
#  set smbip [lindex $ttt 0]
#  set endip [lindex $ttt 1]
#  ETSetTimeout 5
#  NSSetSocketLinkTimeOut 5
#  bl::verbose
#  while { $smbip <= $endip } {
#    if { [bl::ping $smbip 0] } {
#      bl::link $smbip
#      bl::unlinkAll
#    }
#    set smbip [bl::dottedquad $smbip]
#  }
#}


proc locateSMB { { params 0,0 } {filename -1} { timeoot 5 } } { bl::smblocator $params $filename $timeoot }
proc smblocator { { iprange 0,0} {filename -1} { timeoot 5 } } {
  set ttt [split $iprange ,]
  set smbip [lindex $ttt 0]
  set endip [lindex $ttt 1]
  ETSetTimeout $timeoot
  NSSetSocketLinkTimeOut $timeoot
  bl::verbose
  set endip [bl::dottedquad $endip]
  while { "$smbip" != "$endip" } {
#    if { [bl::ping $smbip 0] } {
#      bl::link $smbip
#      bl::unlinkAll
#    }
    bl::link $smbip
    bl::unlinkAll
    set smbip [bl::dottedquad $smbip]
  }
}

















proc silkscreenslot { silk } {
   set s [split $silk {}]
   set row [expr [lindex $s 0] -1]
   set column [lindex $s 1]
   if { $column == "a" } {
      set c 1
   } else {
      set c 2
   }
   set slot [expr $row*$c+$c-1]
   return $slot
}


proc getlibhsp { port } { set x [split [gethsp $port] /]; return "[lindex $x 0] [lindex $x 1] [lindex $x 2]" }

proc findhsp { hsp } { return [gethsp $hsp] }
proc gethsp { port } {
variable info
return $info(pure.$port.hsp)
}

proc findhub { hub } { return [gethub $hub] }
proc gethub { port } {
variable info
return $info(pure.$port.hub)
}

proc findslot { slot } { return [getslot $slot] }
proc getslot { port } {
variable info
  return $info(pure.$port.slot)
}

proc findport { port } { return [getport $port] }
proc getport { port } {
variable info
  return $info(pure.$port.port)
}


proc verbose { { t 0 } } { set bl::VERBOSE 1 }
proc tacit { { t 0 }  } { set bl::VERBOSE 0 }
proc -verbose { { t 0 }  } { bl::tacit }
proc noverbose { { t 0 }  } { bl::tacit }
proc quiet { { t 0 }  } { set bl::QUIETFLAG 1 }
proc noisy { { t 0 }  } { set bl::QUIETFLAG 0 }
proc -noisy { { t 0 }  } { bl::quiet }
proc noquiet { { t 0 }  } { bl::noisy }
proc -quiet { { t 0 }  } { bl::noisy }

proc findXY { lines target } {
  set found 0
  set y 0
  foreach line $lines {
    set cols [split $line ,]
    set x 0
    foreach col $cols {
      set col [string trim $col]
      set temp [string first $target $col]
      #puts "col:$col  temp:$temp target:$target"; after 1000
      if { $temp > -1 } {
        set found 1
        break
      }
      incr x
    }
    if { $found  } {
      break
    }
    incr y
  }
  if { $found } {
    return $x,$y
  } else {
    return -1
  }
}

proc findXYVal { lines xy } {
  set found 0
  set x 0
  set y 0
  foreach line $lines {
    set cols [split $line ,]
    set x 0
    foreach col $cols {
      set matrix($x,$y) $col
#      puts "x:$x matrix($x,$y):$matrix($x,$y)"; after 1000
      incr x
    }
    incr y
  }
  set temp [ catch { set retVal $matrix($xy) } ]
#  puts [array get matrix]
  if { $temp } {
    return -1
  } else {
    return $retVal
  }
}



#
# PUTS FUNCTIONS
# --------------
# This section has functions
# that do special puts and some gets things. like printing to file.
# For example, replace all the puts in your code with fputs, and it will put it to a file
# vputs puts only if /verbose is set.
# qputs puts only if /quiet is NOT set.
##########################################################################################



################################################################################
# Proc pdpgets
# ----------
# purpose: to gets if programmer debug flag is set
#
################################################################################
proc pdgets { {i 0} {j 0} } {
  if { $bl::PROCDEBUG } {
    puts "Programmer breakpoint. Press \[enter\] to continue"
    gets stdin k
    return $k
  }
}

################################################################################
# proc udgets
# ----------
# purpose: to gets if user debug flag is set
#
################################################################################
proc udgets { {i 0} {j 0} } {
  if { $bl::USERDEBUG } {
    gets stdin k
    return $k
  }
}

######## START of the bl puts chain #########
######## remember: you can call bputs directly from your program
########           the procs udputs, dputs, catch { pdputs, pputs call bputs  }
########           bputs in turn calls lputs,catch { eputs, catch { rputs. } }
########           they in turn call qputs
########           qputs calls puts. thats it.

proc udputs { i { k "" } { quiet 0 } } {
if { $bl::USERDEBUG || $bl::USERDEBUGFLAG } { lputs $i $k $quiet }
}


proc pdputs { i { k "" } { quiet 0 } } {
if { $bl::PROCDEBUG || $bl::PROCDEBUGFLAG } { lputs $i $k $quiet }
}

proc pputs { i { k "" } { quiet 0 } } {
if { $bl::PROCDEBUG || $bl::PROCDEBUGFLAG } { lputs $i $k $quiet }
}


proc dputs { i { k "" } { quiet 0 } } {
if { $bl::DEBUG || $bl::DEBUGFLAG } { lputs $i $k $quiet }
}

#proc vputs { i { k "" } {quiet 0}} {
#if { $bl::VERBOSE == 1 } { lputs $i $k $quiet }
#}

proc bputs { i { k "" } {quiet 0}} { vputs $i $k $quiet }

proc vputs { i { k "" } { quiet 0 } } {
  if { $bl::VERBOSE == 1 } {
    set oldquietflag $bl::QUIETFLAG
    lputs $i $k $quiet
    set bl::QUIETFLAG 1
    rputs $i $k $quiet
    eputs $i $k $quiet
    set bl::QUIETFLAG $oldquietflag
  }
  return ""
}

proc leputs { i { k "" } { quiet 0 } } {
  lputs $i $k $quiet
  set bl::QUIETFLAG 1
  eputs $i $k $quiet
  set bl::QUIETFLAG 0
  return ""
}

proc lrputs { i { k "" } { quiet 0 } } {
    lputs $i $k $quiet
    set bl::QUIETFLAG 1
    rputs $i $k $quiet
    set bl::QUIETFLAG 0
    return ""
}



proc fputs { i { k "" } { quiet 0 } } {
  lputs $i $k $quiet
}

proc closeBlLogFiles { type } {
  variable LOGFILEHANDLE
  variable REPORTFILEHANDLE
  variable ERRORFILEHANDLE
  switch [string tolower $type] {
  "log" {
    if { [info exists bl::LOGFILEHANDLE] } {
      flush $bl::LOGFILEHANDLE
      close $bl::LOGFILEHANDLE
      unset bl::LOGFILEHANDLE
    }
  }
  "report" {
    if { [info exists bl::REPORTFILEHANDLE] } {
      flush $bl::REPORTFILEHANDLE
      close $bl::REPORTFILEHANDLE
      unset bl::REPORTFILEHANDLE
    }
  }
  "error" {
    if { [info exists bl::ERRORFILEHANDLE] } {
      flush $bl::ERRORFILEHANDLE
      close $bl::ERRORFILEHANDLE
      unset bl::ERRORFILEHANDLE
    }
  }
  }
}



proc lputs { i { k "" } {quiet 0} } {
  variable LOGFLAG
  variable LOGFILEHANDLE

  if { ! [info exists bl::LOGFLAG] } {
    set bl::LOGFLAG 0
  }
  if { $bl::LOGFLAG } {
    if { ! [info exists bl::LOGFILEHANDLE] } {
      set bl::LOGFILEHANDLE [ startfile $bl::LOGFILENAME 0]
      #set bl::LOGFILEHANDLE [open $bl::LOGFILENAME a+]
    }
    if { $i == "-nonewline" } {
      puts -nonewline $bl::LOGFILEHANDLE $k
      flush $bl::LOGFILEHANDLE
    } else {
      puts $bl::LOGFILEHANDLE $i
      flush $bl::LOGFILEHANDLE
    }
  }
  qputs $i $k $quiet
}

proc rputs { i { k "" } {quiet 0} } {
  variable REPORTFLAG
  variable REPORTFILEHANDLE
  if { ! [info exists bl::REPORTFLAG] } {
    set bl::REPORTFLAG 0
  }
  if { $bl::REPORTFLAG } {
    if { ! [info exists bl::REPORTFILEHANDLE] } {
      set bl::REPORTFILEHANDLE [ startfile report.txt ]
    }
    if { $i == "-nonewline" } {
      puts -nonewline $bl::REPORTFILEHANDLE $k; flush $bl::REPORTFILEHANDLE
    } else { puts $bl::REPORTFILEHANDLE $i; flush $bl::REPORTFILEHANDLE }
  }
  qputs $i $k $quiet
}


proc eputs { i { k "" } {quiet 0} } {
  variable ERRORFLAG
  variable ERRORFILEHANDLE

  if { ! [info exists bl::ERRORFLAG] } {
    set bl::ERRORFLAG 0
  }

  if { $bl::ERRORFLAG } {
    if { ! [info exists bl::ERRORFILEHANDLE] } {
      set bl::ERRORFILEHANDLE [ startfile error.txt ]
    }
    if { $i == "-nonewline" } {
      puts -nonewline $bl::ERRORFILEHANDLE $k; flush $bl::ERRORFILEHANDLE
    } else { puts $bl::ERRORFILEHANDLE $i; flush $bl::ERRORFILEHANDLE }
  }
  qputs $i $k $quiet
}

proc nputs { i { k "" } { $quiet 0 } } {
  if { ![info exists bl::GLOBALcatch { LPUTSLINENUMBER ] } { }
    set bl::GLOBALcatch { LPUTSLINENUMBER 0 }
  }
  if { ![info exists bl::catch { LPUTSFLAG ] } { }
    set bl::catch { LPUTSFLAG 0 }
  }

  incr bl::GLOBALcatch { LPUTSLINENUMBER }
  if { $i == "-nonewline" } {
    if { $bl::catch { LPUTSFLAG } { }
      qputs -nonewline "$bl::GLOBALcatch { LPUTSLINENUMBER $k }"
    } else {
      qputs -nonewline $k
    }
  } else {
    if { $bl::catch { LPUTSFLAG } { }
      qputs "$bl::GLOBALcatch { LPUTSLINENUMBER $i }"
    } else {
      qputs $i
    }
  }
}

##########################################################################################
# qputs: tertiary puts ( i.e. only puts is called from this )
#        puts if the quiet flag is not set
##########################################################################################
proc qputs { i { k "" } {quiet 0 } } {
  if { ! [info exists bl::QUIETFLAG] } {
     set bl::QUIETFLAG 0
  }
  if { $bl::QUIETFLAG == 0 && $quiet == 0 } {
  if { $i == "-nonewline" } {
      puts -nonewline $k; flush stdout; flush stdout
      if $bl::TKFLAG {
        tkputs -nonewline $k
      }
      if $bl::AUTODEBUGFLAG {
        termmsg $k
      }
    } else {
      puts $i; flush stdout; flush stdout
      if $bl::TKFLAG {
        tkputs $i
      }
      if $bl::AUTODEBUGFLAG {
        termmsg "$i\n"
      }
    }
  }
};#endproc qputs

proc tkputs2 { i { k "" } } {
  puts "i:$i k:$k"
  if { $i == "-nonewline" } {
    set text $k
  } else {
    set text $k\n
  }
  if {[winfo exist .mainframe.outputframe.text]} {
      $bl::TKFRAME insert end $text
      $bl::TKFRAME yview moveto 1.0
  } else {
      puts $text
  }
  update
  update idletasks
}

proc tkputs {args} {

    if {[lindex $args 0] == "-nonewline"} {
        set newline ""
        set args [lrange $args 1 end]
    } else {
        set newline "\n"
    }
    if {[llength $args] == 2} {
        set text "[lindex $args 1]$newline"
    } else {
        set text "[lindex $args 0]$newline"
    }

    if {[winfo exist .mainframe.outputframe.text]} {
        $bl::TKFRAME insert end $text
        $bl::TKFRAME yview moveto 1.0
    } else {
        puts $text
    }
    update
    update idletasks
}

######## end of the bl puts chain #########
######## remember: you can call bputs directly from your program
########           the procs udputs, dputs, pdputs, pputs (calls)-----> bputs
########           bputs in turn calls lputs, eputs, rputs.
########           These will log, make error file, or report file, depending on
########           the flags set in the globals section.
########           they in turn call qputs
########           qputs calls puts. thats it.


##########################################################################################
# PP ( Pretty Print ) I can't explain it, just try it, you'll like it.
##########################################################################################
proc PP { { data "" }  { param "" } { param2 "" } } {
variable PPSCREENWIDTH
variable PPERROR
variable PPJOIN
variable PPFROMHERE
variable PPWALL
variable PPTOPLINE
variable PPBOTTOMLINE
variable PPCORNER
variable PPUNDERLINE
variable PPEXTRASPACES

set NONEWLINEFLAG 0
if { ! [info exists ::PPERROR] } {
   set bl::PPERROR !
}
if { ! [info exists ::PPJOIN] } {
   set bl::PPJOIN +
}
if { ! [info exists ::PPSCREENWIDTH]} {
   set bl::PPSCREENWIDTH 77
}
if { ! [info exists ::PPFROMHERE] } {
   set bl::PPFROMHERE 1
}
if { ! [info exists ::PPWALL] } {
   set bl::PPWALL |
}
if { ! [info exists ::PPUNDERLINE] } {
   set bl::PPUNDERLINE -
}
if { ! [info exists ::PPTOPLINE] } {
   set bl::PPTOPLINE -
}
if { ! [info exists ::PPBOTTOMLINE] } {
   set bl::PPBOTTOMLINE -
}
if { ! [info exists ::PPCORNER] } {
   set bl::PPCORNER +
}


switch -- $data {
"setDefaultError"        { set bl::PPERROR $param}
"setDefaultJoin"         { set bl::PPJOIN $param}
"setDefaultScreenWidth" { set bl::PPSCREENWIDTH $param}
"setDefaultFromHere"    { set bl::PPFROMHERE $param }
"setDefaultWall"         { set bl::PPWALL $param }
"setDefaultUnderline"    { set bl::PPUNDERLINE $param }
"setDefaultTopline"      { set bl::PPTOPLINE $param }
"setDefaultBottomline"   { set bl::PPBOTTOMLINE $param }
"setDefaultCorner"       { set bl::PPCORNER $param }
"-topline" {

bputs -nonewline $bl::PPCORNER
for { set i 0 } { $i < $bl::PPSCREENWIDTH } { incr i } {
bputs -nonewline $bl::PPTOPLINE
}
bputs $bl::PPCORNER
}
"-bottomline" {
bputs -nonewline $bl::PPJOIN
for { set i 0 } { $i < $bl::PPSCREENWIDTH } { incr i } {
bputs -nonewline $bl::PPBOTTOMLINE
}
bputs $bl::PPJOIN
}
"" {
bputs -nonewline $bl::PPWALL
bputs -nonewline [format %-$bl::PPSCREENWIDTH\s " "]
bputs $bl::PPWALL
}
"-underline" {
bputs -nonewline $bl::PPJOIN
for { set i 0 } { $i < $bl::PPSCREENWIDTH } { incr i } {
bputs -nonewline $bl::PPBOTTOMLINE
}
bputs $bl::PPJOIN
}
"-errorline" {
bputs -nonewline $bl::PPERROR
for { set i 0 } { $i < $bl::PPSCREENWIDTH } { incr i } {
bputs -nonewline $bl::PPERROR
}
bputs $bl::PPERROR
}
"-nonewline" -
default {
if { $data == "-nonewline" } {
set data $param
set param $param2
set NONEWLINEFLAG 1
}
bputs -nonewline $bl::PPWALL

set cf 0
switch -- $param {
"-center" {
	set cf 1
}
}

set bl::PPEXTRASPACES [expr $bl::PPSCREENWIDTH - $bl::PPFROMHERE ]
bputs -nonewline [format %$bl::PPFROMHERE\s " " ]
if { $cf } {
	set gggg 1
	if { [expr [string length $data] %2 ] } { set gggg 0 }
	set indentation [expr $bl::PPEXTRASPACES / 2 - ( [string length $data] /2 ) ]
	bputs -nonewline [format %[expr $indentation-1]\s " "]
	bputs -nonewline $data
	bputs -nonewline [format %[expr $indentation+$gggg]\s " "]

} else {
	bputs -nonewline [format %-$bl::PPEXTRASPACES\s $data ]
}
if { $NONEWLINEFLAG } { bputs -nonewline $bl::PPWALL } else { bputs $bl::PPWALL }
switch -- $param {
"-underline" {
bputs -nonewline $bl::PPWALL
set dataLen [string len $data]
set underlineLen $dataLen
set x ""
for { set i 0 } { $i < $underlineLen } { incr i } {
set x $x$bl::PPUNDERLINE
}
set bl::PPEXTRASPACES [expr $bl::PPSCREENWIDTH - $bl::PPFROMHERE ]
bputs -nonewline [format %$bl::PPFROMHERE\s " " ]
bputs -nonewline [format %-$bl::PPEXTRASPACES\s $x ]
if { $NONEWLINEFLAG } { bputs -nonewline $bl::PPWALL } else { bputs $bl::PPWALL }
}
} ;#endswitch param
}
}
} ;#endproc pp


proc plus { i } { return [expr $i +1] }
proc minus  { i } { return [expr $i -1] }
proc ggg { i } {  set h [gets $i]; puts $h; return $h; after 500 }
proc ppp {i j}  { puts $i $j; flush $i; after 500}

proc stopstart { params } {
pputs "stopstart"

eval $bl::macro1
eval $bl::macro2
  if { [string tolower $h] == "all" } {
    for { set cha 0 } { $cha < 10 } { incr cha } {
      for { set slo 0 } { $slo < 100 } { incr slo } {
        for { set por 0 } { $por < 100 } { incr por } {
          HTRun $SMB::HTSTOP $cha $slo $por
        }
      }
    }
  }
  if { $bl::ONEBASEDHSP } {set h [minus $h]; set s [minus $s]; set p [minus $p]}
   HTRun $SMB::HTSTOP $h $s $p
   HTRun $SMB::HTRUN $h $s $p
}

proc stopStart { params } { stopstart $params }

proc resetSlot  { params } { resetPort $params }
proc reset { params } { resetPort $params }
proc default { params } { resetPort $params }


#############################################################################
# proc pauseMicroseconds
# --------------------------
# purpose: to wait microseconds, instead of tcl buil-int "after" command
#          which is in milliseconds.
#
#############################################################################
proc pauseMicroseconds { waitMicrosec } {
pputs "afterMicroseconds"
  set start [clock click]
  set stop  [clock click]
  set diff [expr $stop - $start]
  while { $diff < $waitMicrosec } {
    set stop  [clock click]
    set diff [expr $stop - $start]
  }
}


##############################################################################################
# Proc HowmanyZeroes
# -------------
# purpose: counts the number of leading zeroes in a string
# parameters: the string
# returns: the quantity of leading zeroes in a string
#
#############################################################################################
proc howmanyzeroes { str } {
set retval 0
set l [string length $str]
  for {set i 0} {$i < $l} {incr i} {
    if {[string index $str $i] == "0"} {
      set retval [expr $retval +1]
    } else {
      break
    }
  }
return $retval
}

##############################################################################################
#
# Proc addonetocrazystring
# -------------
# purpose: to take a general string of the format xxxxyyyyy where xxxx is of any length and
#          is characterbased, and yyyy is of any length and is numeric, and add one to the
#          numeric portion, handling rollover and leading zeroes.
#
# parameters: the string
# returns: same string plus 1
#
#############################################################################################
proc addonetocrazystring { thestring } {
set newnumber ""
set i [leftright $thestring]
#watchthis "left" [lindex $i 0]
#watchthis "right"  [lindex $i 1]
set lh [lindex $i 0]
set rh [lindex $i 1]
set totalzeroes [howmanyzeroes $rh]
#watchthis "zero" $totalzeroes
set rh [string trimleft $rh 0]
#watchthis "rh" $rh
set rhl [string length [expr $rh +1]]
#watchthis "rhlen" $rhl
#for each character in rh over 1, subtract a zero, but
#not so much that it gets shorter than what was passed in

#here, we take off the zeroes
for {set i 1} { $i < $rhl } { incr i } {
  set totalzeroes [expr $totalzeroes -1]
}
#watchthis "zero" $totalzeroes
#This if/else is if rh is all zeroes, we don't add any
if {$rh != ""} {
for {set i 0} { $i < $totalzeroes } {incr i} {
  append newnumber 0
}
} else {
for {set i 0} { $i < [expr $totalzeroes-1] } {incr i} {
  append newnumber 0
}
}
##########################
#Brett-Documentation
#
#Now, before we put the number on, let's check if its length would be equal to
#the length of what was passed in! If not, add zero's until it is!
#
##########################
set i $newnumber
append i [expr $rh +1]
set i $lh$i
while { [string length $i] < [string length $thestring] } {
  append newnumber 0
  set i $newnumber
  append i [expr $rh +1]
  set i $lh$i
}
append newnumber [expr $rh +1]
set newnumber $lh$newnumber
return $newnumber
};#end proc addtocrazystring


##############################################################################################
#
# Proc IsNumeric
# -----------
# purpose: to see if a given char is a number
# parameters: the char
# returns: -1 if not numeric, 1 if so
#
#############################################################################################
proc isnumeric { character } {
set retval -1
for {set i 0} {$i < 10} {incr i} {
  if { $character == $i } {
    set retval 1
  }
}
return $retval
}

##############################################################################################
#
# Proc Numerize
# -------------
# purpose: to produce a string of 1 and 0's, that represent in ordinal positions where
#         corresponding numbers occur in the input string
# parameters: the string
# returns: an identically long string, but each character replaced with a 0 and number with 1
#
#############################################################################################
proc numerize  { str } {
set strlen [string length $str]
set ii ""
for {set i 0} { $i < $strlen } { incr i } {
  set iii [isnumeric [string index $str $i]]
  if { $iii > 0 } {
    append ii 1
  } else {
    append ii 0
  }
}
return $ii
}

##############################################################################################
#
# Proc LeftRight
# -------------
# purpose: to produce two strings out of one, splitting them where a number occurs
# parameters: the string
# returns: a list of two strings, "left" and "right", the "left" being everything in the
#          first string to the left of the
#          the first number in the first string, and the "right" everything else.
#
#############################################################################################
proc leftright { str } {
  set lhand ""
  set rhand ""
  set numer [numerize $str]
  for { set i 0 } { $i < [string length $str] } {incr i } {
  if { [string index $numer $i] == 1 } {
    break
  }
  append lhand [string index $str $i]
  }
  for { set i $i } { $i < [string length $str] } {incr i } {
    append rhand [string index $str $i]
  }
  lappend retval $lhand
  lappend retval $rhand
  return $retval
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



proc random {args} {
  for { set i 0 } { $i < 200 } { incr i } {
    set temp [expr {rand()}]
  }
  set num [expr {rand()}]
  if { [llength $args] == 0 } {
    return $num
  } elseif { [llength $args] == 1 } {
    return [expr {int($num * [lindex $args 0])}]
  } elseif { [llength $args] == 2 } {
  foreach {lower upper} $args break
    set range [expr {$upper - $lower}]
    return [expr {int($num * $range) + $lower}]
  } else {
    set fn [lindex [info level 0] 0]
    error "wrong # args : should be \"$fn ?value1? ?value2?\""
  }
}

proc randomEthernetLength {} {
set temp -1
while { $temp < 60 } {
set temp [random 1514]
}
return $temp
}




##########################################################################################
# isodd
# --------------
# purpose: tell you if the number if odd or even
# paramaters: the number
# returns: 1 if odd, 0 if even
# usage: puts [isodd 5]
##########################################################################################
proc isodd { i } {
  if { [expr $i / 2] < [expr $i.0 / 2.0] } { return 1 }
  return 0
}



#####################################################################################
#
# proc round
# --------------
# purpose: round up a IMAGINARY number
# paramaters: the number
# returns: the number rounded up
# usage: round 1.3333335 will result in 1.333334
#############################################################################################
proc round { i } {
set j [split $i .]
set k [lindex $j 0]
set l [lindex $j 1]
for { set m [string length $l] } { $m > 0 } { incr m -1 } {
  if { [string index $l $m] > 4 } {
    set n [string index $l [expr $m -1] ]
    if { $n == 9 } {
      set n 0
    } else {
    set n [expr $n+1]
    set o [string range $l 0 [expr $m -2] ]
    set l $o$n
    }
  } else {
    set l [string range $l 0 [expr $m -1] ]
  }
#puts "l:$l"
}
set p [string trimright $l 0]
#puts $p
if { $p != "" } { if {$p > 4} { incr k  } }
return $k
}

#############################################################################
# proc lappendUnique
# --------------------------
# purpose: uniquely append something to a list
#############################################################################
proc lappendUnique { arr item } {
upvar $arr blah
#puts "does blah exist yet? Answer:[info exists blah]"
if { ! [info exists blah] } {
  lappend blah $item
} else {
  if { 0 > [lsearch $blah $item] } {
  #puts "is the item $item already in $blah? no!"
  lappend blah $item
  }
}
}
proc ver { { t 0 }  } { showSmartlibVersion; vputs "BL version: $::biglibRev"; vputs "Last Touch: $bl::biglibRevdate"; vputs "minimum SmartLib version:$bl::biglibSmartlibReq" }
proc version { { t 0 } } { showSmartlibVersion; vputs "BL version: $::biglibRev"; vputs "Last Touch: $bl::biglibRevdate"; vputs "minimum SmartLib version:$bl::biglibSmartlibReq" }
proc showver {{ t 0 } } { showSmartlibVersion; vputs "BL version: $::biglibRev"; vputs "Last Touch: $bl::biglibRevdate"; vputs "minimum SmartLib version:$bl::biglibSmartlibReq" }
proc showversion {{ t 0 } } { showSmartlibVersion; vputs "BL version: $::biglibRev"; vputs "Last Touch: $bl::biglibRevdate"; vputs "minimum SmartLib version:$bl::biglibSmartlibReq" }
proc showSmartlib {{ t 0 } } { showSmartlibVersion }
proc showSmartLib {{ t 0 } } { showSmartlibVersion }
proc showSmartlibVer {{ t 0 } } { showSmartlibVersion }
proc showSmartlibVersion {{ t 0 } } { vputs [getSmartlibVersion] }

proc getSmartlibVersion {{ t 0 } } {
  set blah ""
  bl::check ETGetLibVersion blah blah
  return "SmartLibrary Version:$blah"
}





proc run { params } { startTraffic $params }
proc start { params } { startTraffic $params }
#proc start { params } { groupstart }
proc startPort { params } { startTraffic $params }
proc startCard { params } { startTraffic $params }

proc stop { params } { stopTraffic $params }
#proc stop { params } { groupstop }
proc stopPort  { params } { stopTraffic $params }
proc stopCard  { params } { stopTraffic $params }

proc startTraffic { params } {
#puts "params:$params"

eval $bl::macro1
#puts "$h/$s/$p port=$ports"


#  puts pports:$pports
  foreach port $ports {
  eval $bl::macro2
  vputs "Starting port $port"
  #  puts "Starting  $h/$s/$p"
  if { [string tolower $h] == "all" } {
    for { set cha 0 } { $cha < 10 } { incr cha } {
      for { set slo 0 } { $slo < 100 } { incr slo } {
        for { set por 0 } { $por < 100 } { incr por } {
          HTRun $SMB::HTRUN $cha $slo $por
        }
      }
    }
  }
  bl::check HTRun $SMB::HTRUN $h $s $p
}
if { $bl::AUTOHISTO } {
  bl::enablestreamcounts $params
}
}

proc stopTraffic { params } {
eval $bl::macro1
foreach port $ports {
  eval $bl::macro2
  vputs "Stopping port $port"
  bl::check HTRun $SMB::HTSTOP $h $s $p
}
}

proc resetPortPartial { params } {
  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    HTSetStructure $SMB::L3_DEFINE_IP_STREAM 0 0 0 "" 0 $h $s $p
    bl::check HTResetPort $SMB::RESET_PARTIAL $h $s $p
    vputs "Defaulted $h/$s/$p (EXCEPT Layer 1)"
  }
}

proc resetPort { params } {
  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    HTSetStructure $SMB::L3_DEFINE_IP_STREAM 0 0 0 "" 0 $h $s $p
    bl::check HTResetPort $SMB::RESET_FULL $h $s $p
    vputs "Defaulted $h/$s/$p and removed all streams"
  }
}

proc resetCard { params } { resetPort $params }


#########################################################
# proc round
# --------------
# purpose: round up a IMAGINARY number
# paramaters: the number
# returns: the number rounded up
# usage: round 1.3333335 will result in 1.333334
#
#########################################################
proc round { i } {
set j [split $i .]
set k [lindex $j 0]
set l [lindex $j 1]
for { set m [string length $l] } { $m > 0 } { incr m -1 } {
  if { [string index $l $m] > 4 } {
    set n [string index $l [expr $m -1] ]
    if { $n == 9 } {
      set n 0
    } else {
      set n [expr $n+1]
      set o [string range $l 0 [expr $m -2] ]
      set l $o$n
    }
  } else {
    set l [string range $l 0 [expr $m -1] ]
  }
  }
set p [string trimright $l 0]
if { $p != "" } { if {$p > 4} { incr k  } }
return $k
}

##########################################################################################
# getrev
# --------------
# purpose: to return the rev of a program
# paramaters: none
# returns: the rev
# usage: puts [getrev]
##########################################################################################
proc getrev {{ t 0 } } { return $bl::biglibRev }

##########################################################################################
# getrevdate
# --------------
# purpose: to return the revdate of a program
# paramaters: none
# returns: the revdate
# usage: puts [getrevdate]
##########################################################################################
proc getrevdate {{ t 0 } } { return $bl::biglibRevdate }


proc pauseSeconds { seconds } { vputs "waiting $seconds\s"; after [expr 1000 * $seconds] }

proc getSpeedAndDuplex { params } {
  return [findSpeedAndDuplex $params]
}

proc findSpeedAndDuplex { params } {
pputs "findSpeedAndDuplex $params"

eval $bl::macro2
set temp ""
set contents ""
set address ""
set register 0
bl::check HTFindMIIAddress address temp $h $s $p
bl::check HTReadMII $address $register contents $h $s $p
if { [lindex $contents 13] == 0 } {
    lappend retval "10"
  } else {
    lappend retval "100"
  }
  if { [lindex $contents 8] == 0 } {
    lappend retval "HALF"
  } else {
    lappend retval "FULL"
  }
  return $retval
}


proc groupnuke { { params -1 } } { bl::check HGClearGroup; variable BLGROUP; catch { unset BLGROUP } }

proc groupadd { params } {
set retval ""
variable BLGROUP
#puts params:$params
eval $bl::macro1
vputs -nonewline "Adding port "
foreach port $ports {
    eval $bl::macro2
    #puts -nonewline "yo!port:$port ->"
    set oldverbose $bl::VERBOSE
    set bl::VERBOSE 0
    if { [set uuu [bl::reserveCard $port]] } {
      bl::check HGAddtoGroup $h $s $p
      set bl::VERBOSE $oldverbose
      vputs -nonewline "$port,"
      set BLGROUP [lappend BLGROUP $port]
    } else {
      puts "$port but somebody else is using it."
      append retval "$port but somebody else is using it."
      set bl::VERBOSE $oldverbose
    }
    set bl::VERBOSE $oldverbose
  }
  if { $uuu } { vputs " to the group." }
  return $retval
}


proc groupdelete { params } { groupsubtract $params }

proc groupsubtract { params } {
variable BLGROUP
eval $bl::macro1
  vputs -nonewline "Deleting port "
  foreach port $ports {
    vputs -nonewline "$port,"
    eval $bl::macro2
    set ok [bl::check HGRemoveFromGroup $h $s $p]
    catch { set BLGROUP [lreplace $BLGROUP [lsearch $BLGROUP $port] [lsearch $BLGROUP $port]] }
  }
  vputs " from the group"
}


proc showgroup {{ t 0 } } { bl::group show }

proc group { params } {
#  puts ggparams:$params
  set thing [lindex [split $params] 0]
  set arglist [lreplace [split $params] 0 0]
#  if { [string length $arglist] < 3 && -1 == [string first = $arglist] } {
#    set arglist "port=$arglist"
#  }
#  puts ggarglist:$arglist
  switch $thing {
    delete { groupdelete $arglist }
    show { puts [findgroup] }
    arp { grouparp $arglist }
    stream -
    streams { groupstreams $arglist }
    add { return [groupadd $arglist] }
    go -
    run -
    start { groupstart $arglist }
    halt -
    stop { groupstop $arglist }
    reserve { groupreserve $arglist }
    default -
    reset -
    resetport { groupreset $arglist }
    counters -
    showcounters {
      set x "[findgroup] $arglist";
      if { [string first "port=" $x] > -1 } {
        set x [string trimright $x "port="];
      }
      set x [string trimright $x " "];
      groupcounters $x
    }
    results {
      set x "[findgroup]";
      if { [string first "port=" $x] > -1 } {
        set x [string trimright $x "port="];
      }
      set x [string trimright $x " "];
      groupcounters "$x counters=u64TxSignatureFrames.low,u64RxSignatureFrames.low"
    }
    streamcounters -
    showstreamcounters { showPerStreamCounters [findgroup] }
    clear -
    clearcounters { groupclearcounters $arglist }
    default {
      puts "group add <port>\ngroup subtract <port>\ngroup nuke\ngroup show\ngroup clearCounters\ngroup start\ngroup stop"
    }
  }
}

proc groupstart { { param -1 } } { bl::check HGRun $SMB::HTRUN; vputs "Started the group"   }
proc groupstop  { { param -1 } } { bl::check HGRun $SMB::HTSTOP; vputs "Stopped the group"  }

proc groupreset { { params -1 } } {
  bl::check HGResetPort $SMB::RESET_FULL;
  #bl::resetPort [findgroup]
  foreach port [split [findgroup] , ]  {
    set cardModel $bl::info(pure.$port.cardmodel)
    switch $cardModel {
    "AT-9622" -
    "AT-9015" -
    "AT-9020" -
    "AT-9155C" -
    "AT-9155" -
    "AT-9155CS" {
    bl::atmResetCard $port
    bl::atmSetLine $port
    }
    }
  }
  eval $bl::macro1
  foreach port [split [findgroup] , ]  {
    eval $bl::macro2
    HTSetStructure $SMB::L3_DEFINE_IP_STREAM 0 0 0 "" 0 $h $s $p
  }
  vputs "Defaulted the cards in the group.  All streams removed. "
}


proc groupclear { { params -1 } } { bl::groupclearcounters blah; vputs "Cleared counters for the group"  }

proc groupclearcounters { { params -1 } } { bl::check HGClearPort }
proc isItAValidIpaddress { ip } {
  set t [split $ip .]
  if { [llength $t] != 4 } {
    return 0
  } else {
    return 1
  }
}

proc showwArray { arr } {
  upvar $arr localArray
  set blah [split [array get localArray]]
  foreach { param val } $blah {
    lappend newlist $param=$val
  }
  set newlist2 [lsort -dictionary $newlist]
  puts $newlist2
  exit
  set newlist2 [split $newlist2 =]
  foreach { param val } $newlist2 {
    set blah($param) $val
  }
  puts [array get blah]
  #puts $newlist2
}

proc showArray { arr } {
  upvar 0 $arr localArray
  showwArray localArray
}

proc export { j } {
  namespace export $j
}

proc fixhsp { h s p  { port -1 } } {
  if { [string first / $h] > -1} {
    set temp [split $h /];
    set h [lindex  $temp 0]; set s [lindex $temp 1]; set p [lindex $temp 2]
  } else {
    if { $port != -1 && $port != "" } {
      set s $bl::info(pure.$port.slot)
      set p $bl::info(pure.$port.port)
      set h $bl::info(pure.$port.hub)
    } else {
      if { $bl::ONEBASEDHSP } {set h [minus $h]; set s [minus $s]; set p [minus $p]}
    }
  }
  return [list $h $s $p]
}

proc lex2 { userstring patterns } {
set possibilities ""
set index -1
foreach pattern $patterns {
  incr index
  set pl [string length $pattern]
  set ul [string length $userstring]
  set ll 0
  for { set i 0 } { $i < $pl } { incr i } {
    set pLetter [string index $pattern $i]
    set uLetter [string index $userstring $i]
    if { $pLetter != $uLetter } {
      break
    } else {
      incr ll
    }
  }
  #puts "ll:$ll ul:$ul userstring:$userstring pattern:$pattern"
  if { $ll == $ul } {
    lappend possibilities $pattern
    if { [string trimright $pattern] == $userstring } {
      break
    }
  }
}
return $possibilities
}


proc driver {} {
variable config
puts "Welcome to the BL Driver."
puts "type \"quit\" to quit, otherwise ? to see a list of commands"
puts ""
set temp [info procs]
foreach pattern $temp {
  lappend patterns "$pattern "
}
lappend patterns "quit "
set patterns [lsort $patterns]
  while { 1 } {
    puts -nonewline ">>"; flush stdout
    set userstring [gets stdin]
    set ttt [string first "?" $userstring]
    set userstring [string trimright $userstring ?]
    set command [lindex $userstring 0]
    set params [lreplace $userstring 0 0]
    set command [string trimright $command]
    set poss ""
    if { $ttt != -1 } {
      foreach pat $patterns {
        set pat [string trimright $pat]
        set poss "$poss [regexp -inline -all ^$command.* $pat]"
      }
      #set poss [regexp -inline -all "\$$command\[^ ]*" $patterns]
    } else {
      set poss [regexp -inline $command $patterns]
    }
    #puts poss:$poss
    set poss [lsort -unique $poss]
    set possl [llength $poss]
    if { [string first "quit" $userstring] > -1 } {
      break
    }
    if { $possl  == 0 } {
      catch { eval $userstring }
    }
    #puts poss:$poss
    if { $possl == 1 && $ttt == -1 && $userstring != "" } {
      set uu "$poss $params"
      set x "bl::$poss \"$params\""
      if { ! [info exists bl::config] } {
        set config "#biglib config file\n"
      }
      if { [isSaveableCommand $poss] } {
        set config $bl::config$uu\n
      }
      catch { eval $x } g
      if { $g != "invalid command name \"\"" && $g != "" } {
        puts  $g
      }
    }
    if { $ttt != -1 }  {
      foreach possey $poss {
        puts -nonewline "$possey "
      }
      puts ""
    }
  };#end of outer while loop
}


proc showconfig { parms } {
  puts $bl::config
}

proc write { parms } { bl::saveconfig $parms }
proc saveconfig { parms } {
  set fh [open $parms w]
  puts $fh $bl::config
}

proc load { parms } { bl::source $parms }

proc source { parms } {
  variable config
  set fh [open $parms r]
  foreach ddd [split [read $fh] \n] {
    puts "$parms>>$ddd"
    if { [regexp \[a-z\] $ddd] && [string length $ddd] > 2 && [string index $ddd 0] != "#" } {
      set eee [lindex $ddd 0]
      set fff [lreplace $ddd 0 0]
      set uu "$eee $fff"
      set tt "bl::$eee \"$fff\""
      catch { eval $tt } g
      if { ! [info exists bl::config] } {
        set config "#biglib config file\n"
      }
      if { [isSaveableCommand $eee] } {
        set config $bl::config$uu\n
      }
      puts $g
    }
  }
  [close $fh]
  puts "***** here ******"
}

proc isSaveableCommand { parm } {
  set dontsavelist [list "source" "source " "source  \
  " "saveconfig " "showconfig " "saveconfig" "showconfig" ]
  if { -1 == [lsearch $dontsavelist $parm] } {
    return 1
  }
  return 0
}

proc pause { { parms 1 } } {
  if { $parms == 1 } {
    vputs "tick!"
  } else {
    vputs -nonewline "Pausing $parms seconds"
    for { set i 1 } { $i <= $parms } {incr i }  {
      after [expr 1000 * $i]
      vputs -nonewline "."; flush stdout
    }
  }
  vputs ""
}

#
# usage:
#         set i(h) 0
#         fillarray "h=5" i
#         puts $i(h) ;#should be "5"
#
proc fillarray { argv arrayname } {
  upvar $arrayname localarray
  set alltheargs [split $argv]
  foreach arg $alltheargs {
    set param [lindex [split $arg =] 0]
    set value [lindex [split $arg =] 1]
    set localarray($param) $value
  }
}

proc verticalwords { listofwords { screenwidth 80 } } {
  set longestlen 0
  set howmanywords [llength $listofwords]
  set columnwidth [expr ($screenwidth / $howmanywords)+2]
  foreach word $listofwords {
    set wordlen [string length $word]
    if { $longestlen < $wordlen } {
      set longestlen $wordlen
    }
  }

  incr longestlen
  set r 0
  for { set i 1 } { $i <= $longestlen } { incr i } {
    set index [expr $longestlen - $i]
    foreach word $listofwords {
      set word [format %$longestlen\s $word]
      #set word [string trim $word]
      append row($index) [format %-$columnwidth\s [string index $word $index]]
    }
  }
  set xx ""
  for { set i 0 } { $i <[expr $columnwidth-2] } { incr i } { set xx $xx\- }
  foreach word $listofwords {
    append row([expr $longestlen]) [format %-$columnwidth\s $xx]
  }
  for { set i 0 } { $i <= $longestlen } { incr i } {
    puts $row($i)
  }
}

proc verticalmetrics { listofwords { columnwidth 8 } } {
  set longestlen 0
  set howmanywords [llength $listofwords]
  foreach word $listofwords {
    set wordlen [string length $word]
    if { $longestlen < $wordlen } {
      set longestlen $wordlen
    }
  }

  incr longestlen
  set r 0
  for { set i 1 } { $i <= $longestlen } { incr i } {
    set index [expr $longestlen - $i]
    foreach word $listofwords {
      set word [format %$longestlen\s $word]
      #set word [string trim $word]
      append row($index) [format %-$columnwidth\s [string index $word $index]]
    }
  }
  set xx ""
  for { set i 0 } { $i < [expr $columnwidth-1] } { incr i } { set xx $xx\- }
  set xx "$xx "
  foreach word $listofwords {
    append row([expr $longestlen]) [format %-$columnwidth\s $xx]
  }
  for { set i 0 } { $i <= $longestlen } { incr i } {
    qputs $row($i)
  }
}

proc grouplist { { params -1 } } {
  return $bl::BLGROUP
}

proc getgroup { { params -1 } } { findgroup $param }
proc findgroup { { params -1 } } {
  variable BLGROUP
  set retval ""
  foreach thing $bl::BLGROUP {
    set retval "$retval$thing,"
  }
  set retval [string trimright $retval ,]
  return $retval
}

proc groupnum   { { params -1 } } { groupcount $params }
proc groupcount { { params -1 } } {
  return [llength [bl::grouplist]]
}

proc imixSetSizelist { type totalpackets sizelist distlist } {\
    variable imixTotalpackets[subst $type]
    variable imixSizelist[subst $type]
    variable imixDistrib[subst $type]
    variable imixUsedpackets[subst $type]
    variable imixMaxPackets[subst $type]
    variable imixDone[subst $type]
    catch { unset imixUsedpackets[subst $type] }
    catch { unset imixMaxPackets[subst $type] }
    catch { unset imixDone[subst $type] }
    set bl::imixTotalpackets[subst $type] $totalpackets
    set bl::imixSizelist[subst $type] $sizelist
    set bl::imixDistrib[subst $type] $distlist
    set i -1
#   puts $distlist
#   puts $sizelist
    foreach thing $sizelist {
      incr i
      set uu [expr [lindex $distlist $i] * .01]
      lappend howmany [expr $thing * $uu]
    }
    set xx 0
    foreach thing $howmany {
      set xx [expr $xx + $thing]
    }
#   puts howmany:$howmany
#   puts xx:$xx
    set avg [expr $xx / [llength $sizelist]]
#   puts avg:$avg
#   exit
    variable imixAvg[subst $type]
    #puts "setting bl::imixAvg[subst $type] to $avg"
    set bl::imixAvg[subst $type] $avg

#   set k bl::imixSizelist[subst $type]
#   puts [subst $$k]
#   exit
}

proc imixGetFramesize { type } {
  variable imixSizelist[subst $type]
  variable imixUsedpackets[subst $type]
  variable imixMaxPackets[subst $type]
  variable imixDone[subst $type]
  set returnSize -1
  set breakout 0
  set k1 bl::imixSizelist[subst $type]

  set numberOfSizes [llength [subst $$k1]]
  while { ! $breakout } {

  #set index [expr round([expr rand() * $numberOfSizes]) ]
  set index [expr round([expr floor([expr rand() * $numberOfSizes])])]

  set k2 bl::imixUsedpackets[subst $type][subst $index]
  if { ! [info exists [subst $k2]] } {
    variable imixUsedpackets[subst $type][subst $index]
    set bl::imixUsedpackets[subst $type][subst $index] 0
  }
  set k3 bl::imixMaxPackets[subst $type][subst $index]
  if { ! [info exists [subst $k3] ] }  {
    set k4 bl::imixDistrib[subst $type]
    set t1 [lindex [subst $$k4] $index]
#   puts $bl::imixDistrib
    set k5 bl::imixTotalpackets[subst $type]
    set t2 [expr $t1 * [subst $$k5] * .01]
    #puts t2:$t2
    set t3 [split $t2 .]
    set t4 [lindex $t3 0]
    #puts t4:$t4
    variable imixMaxPackets[subst $type][subst $index]
    set bl::imixMaxPackets[subst $type][subst $index] $t4
  }


  #puts "max packets($index):$bl::imixMaxPackets($index) \
  #imixUsedpackets($index):$bl::imixUsedpackets($index)"

  if { [subst $$k2] < [subst $$k3] } {
    set returnSize [lindex [subst $$k1] $index]
    incr bl::imixUsedpackets[subst $type][subst $index]
    break
  }
  variable imixDone[subst $type][subst $index]
  set bl::imixDone[subst $type][subst $index] 1

  set test -1
  set breakout 1
  set k6 bl::imixSizelist[subst $type]
  foreach size [subst $$k6] {
    incr test
    if { ! [info exists bl::imixDone[subst $type][subst $test])] } {
      variable imixDone[subst $type][subst $test]
      set bl::imixDone[subst $type][subst $test] 0
    }
    set k7 bl::imixDone[subst $type][subst $test]
    if { ! [subst $$k7]  } {
      #puts bl::done($test):$bl::done($test)
      set breakout 0
    }
  }

  }
  if { $returnSize == -1 } {
  catch { unset imixUsedpackets[subst $type][subst $test] }
  catch { unset imixMaxPackets[subst $type][subst $test] }
  catch { unset imixDone[subst $type][subst $test] }
  }
  return $returnSize
}

proc ss { args } {
  bl::check HTSetStructure $args
}

proc gs { args } {
  bl::check HTGetStructure $args
}

proc sc { args } {
  bl::check HTSetCommand $args
}

proc setHardcodedInterfaceInformation { } { return 1 }

proc extractnums { str } {
  set notalreadyaddedspace 0
  while { 1 } {
    set numstr ""
    set strlen [string length $str]
    for { set i 0 } { $i < $strlen } { incr i } {
      set letter [string index $str $i]
      if { [isnumeric $letter] == 1 } {
        set numstr $numstr$letter
        set notalreadyaddedspace 1
      } else {
        if { $notalreadyaddedspace } {
          set numstr "$numstr "
          set notalreadyaddedspace 0
        }
      }
    }
    break
  }
  return $numstr
}

#############################################################
#
# C2I - Converts a character and returns its integer value
#
# argument: ucItem - The character whose integer value will
#                     be returned
#
#############################################################
proc C2I {ucItem} {
  set iItem 0
  set ucMin [format %c 0x00]
  set ucMax [format %c 0xFF]

  if {$ucItem == $ucMin} {
    set iItem 0
  } elseif {$ucItem == $ucMax} {
    set iItem 255
  } else {
    scan $ucItem %c iItem
  }

  return $iItem
}


proc wsLIBCMD {args} {
  set iResponse [uplevel $args]
  if {$iResponse < 0} {
    puts "$args :  $iResponse"
  }
  if { $iResponse == -27 } {
    eputs "ERROR: -27"
    eputs "UNLINKING + RELINKING TO SMARTBITS"
    unlink_from_all_chassis
    catch { grabv2 $SMB::INITED }
  }
  if { $iResponse == -28 } {
    eputs "ERROR: -28"
    eputs "REBOOTING SMARTBITS"
    foreach gh $SMB::info(g.ch_list) {
      reset_smb $SMB::info(g.ipaddress.$gh) SMB-6000
    }
    after 35000
    if { [info exists ::INITED] } {
      grabv2 $SMB::INITED
    }
    if { [info exists ::info(g.tests] } {
      if { $SMB::RUNLONG } {
        command_line_interpreter "run test $SMB::info(g.tests)"
      } else {
        command_line_interpreter "runlong test $SMB::info(g.tests)"
      }
    }
  }
  return $iResponse
}

proc setGapFromPercent { percent speed len h s p } {
#iSpeed Input parameter can be one of the speed constants:
#SPEED_10GHZ
#SPEED_1GHZ
#SPEED_100MHZ
#SPEED_10MHZ
set gap 0
wsLIBCMD NSCalculateGap $SMB::PERCENT_LOAD_TO_GAP_BITS $speed $len $percent gap $h $s $p
#ulPacketLength is (excluding Preamble and CRC)
#Comments Does not apply to POS, ATM, or WAN cards.
#Example:
#int iMode = PERCENT_LOAD_TO_GAP_BITS
#int iSpeed = SPEED_10GHZ
#unsigned long ulPacketLength = 100
#double dValue = 95.5
#unsigned long ulGap = 0;
#NSCalculateGap(iMode,iSpeed,dValue,&ulGap,iHub,iSlot,iPort);
#HTGap(ulGap, iHub, iSlot, iPort);
wsLIBCMD HTGap $gap $h $s $p
}

############# WAN STRUFF #############

proc wanResetCard { params } {

eval $bl::macro1
#puts "wanReset ports:$ports"
foreach port $ports {
eval $bl::macro2
#puts "Resetting card $h $s $p "
set cardmodel $bl::info(lib.$h/$s/$p.cardmodel)
if {$cardmodel == "WN-3441A" || $cardmodel == "WN-3442A"} {
   wsLIBCMD HTSetCommand $SMB::WN_T1E1_LINE_DEL_ALL 0 0 0 "" $h $s $p
}
wsLIBCMD HTSetCommand $SMB::WN_CHANNEL_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_PVC_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_STREAM_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_LMI_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_PVC_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_TRIGGER_DEL_ALL 0 0 0 "" $h $s $p
}
}


proc wanDs3LineConfig { params } {
pputs "ds3_line_config"
set stuff(hsp) 0
set stuff(clockSource) "internal"

eval $bl::macro1
struct_new MyDS3LineCfg WNDS3LineCfg
foreach port $ports {
eval $bl::macro2
if {$clockSource == "internal" } {
 puts "     Setting with internal clock source"
 set clockSource $SMB::WN_CARD_CLK_INTERNAL
} else {
 puts "     Setting with loop clock source"
 set clockSource $SMB::WN_LOOP_TIMED_CLOCK
}
set MyDS3LineCfg(ucActive) 1
set MyDS3LineCfg(ucClocking) $clockSource
set MyDS3LineCfg(ucLoopbackEnable) $SMB::WN_LOOPBACK_DISABLED
#set MyDS3LineCfg(ucLineEncoding) $SMB::WN_DS3_ENCODING_B3ZS
#set MyDS3LineCfg(ucLineBuildout) $SMB::WN_DS3_BUILDOUT_LT225
set MyDS3LineCfg(ucChannelized) $SMB::WN_DS3_UNCHANNELIZED
wsLIBCMD HTSetStructure $SMB::WN_DS3_LINE_CFG 0 0 0 MyDS3LineCfg 0 $h $s $p
}
unset MyDS3LineCfg
}

proc wanDs3SetLineState  { params } {
set stuff(hsp) 0
set stuff(mode) "enable"

eval $bl::macro1
struct_new DS3LineCtrl WNDS3LineCtrl
foreach port $ports {
eval $bl::macro2
if {$mode == "disable" } {
 puts "     Disabling DS3 $h $s $p"
 set mode 0
} else {
 puts "     Enabling DS3 $h $s $p"
 set mode 1
}
set DS3LineCtrl(ucEnable) $mode
wsLIBCMD HTSetStructure $SMB::WN_DS3_LINE_CTRL 0 0 0 DS3LineCtrl 0 $h $s $p
}
}

proc wanChannelConfig { params } {
set stuff(hsp) 0
set stuff(channel) 0
set stuff(slotsPerChannel) 0
set stuff(firstslot) 0

struct_new ChanPhysCfg WNChannelPhysCfg
struct_new ChanAttribCfg WNChannelAttribCfg

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set ChanPhysCfg(ulChannelNo) $channel
  set ChanPhysCfg(ulCount)     1
  ###################################################
  # Given T1 with four slotsPerChannel, for channel 0 firstSlot will be zero
  # and channel will be zero, so start will be 0 + (0 * 4) = 0
  # The for loop will start at 0 ($start) and continue while less then 4
  # This will give channel 0 slots 0,1,2,3
  # Channel 1 will have a firstSlot of 0 and a channel of 1.  This will
  # make start 0 + (1 * 4) = 4
  # This will give channel 1 slots 4,5,6,7
  ####################################################
  set start [expr $firstslot + ($channel * $slotsPerChannel)]
  for {set i $start} {$i < [expr $start + $slotsPerChannel]} {incr i} {
     set ChanPhysCfg(ucTimeSlots.$i) 1 ;#enable
  }
  set ChanPhysCfg(ucCRCOff)   0
  set ChanPhysCfg(ucUseCRC32) 0
  wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_PHYS_CFG 0 0 0 ChanPhysCfg 0 $h $s $p
  set ChanAttribCfg(ulChannelNo) $channel
  set ChanAttribCfg(ulCount) 1
  set ChanAttribCfg(ucEnable) 1
  set ChanAttribCfg(ucConnType) $SMB::WN_CONN_PPP
  set ChanAttribCfg(ucTXMode)   $SMB::WN_TX_CONTINUOUS
  set ChanAttribCfg(ucFCSErr) 0
  set ChanAttribCfg(ucAbortFlag) 0
  set ChanAttribCfg(ulBurstCount)      0
  wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_ATTRIB_CFG 0 0 0 ChanAttribCfg 0 $h $s $p
}
}

proc  wanSetChannelState { params } {
set stuff(hsp) 0
set stuff(channel) 0
set stuff(mode) enable
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
if {$mode == "disable" } {
    puts "     Disabling T1E1 Channel $channel on Line/Port $P "
    set mode 0
  } else {
    puts "     Enabling T1E1 Channel $channel on Port/Line $P "
    set mode 1
  }
  struct_new chCtrl WNChannelCtrl
  set chCtrl(ulLineNo)    $p
  set chCtrl(ulChannelNo) $channel
  set chCtrl(ulCount)     1
  set chCtrl(ucEnable)    $mode
 wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_CTRL 0 0 0 chCtrl 0 $h $s $p
}
}

proc wanStartConfig { params } {

eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    wsLIBCMD HTSetCommand $SMB::WN_START_CFG 0 0 0 "" $h $s $p
  }
}

proc wanSetStreamState { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(count) 1
set stuff(mode) 1
struct_new StreamCtrl WNStreamCtrl

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
   set StreamCtrl(ulStreamNo) $stream
   set StreamCtrl(ulCount) 1
   set StreamCtrl(ucEnable) $mode

   wsLIBCMD HTSetStructure $SMB::WN_STREAM_CTRL 0 0 0 StreamCtrl 0 $h $s $p
}
}

proc wanSetStreamMap { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(channel) 0
set stuff(dlci) 0
struct_new StrmExtCfg  WNStreamExtCfg
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set StrmExtCfg(ulCount) 1
  set StrmExtCfg(ulDLCI) $dlci
  set StrmExtCfg(ulLineNo) $p
  set StrmExtCfg(ulChannelNo) $channel
  set StrmExtCfg(ucEncapType) $SMB::WN_RFC1662_RTD_PPP
  set StrmExtCfg(ucCR)     0
  set StrmExtCfg(ucFECN)      0
  set StrmExtCfg(ucBECN)      0
  set StrmExtCfg(ucDE)     0
  set StrmExtCfg(ulFrameRate) 90
  wsLIBCMD HTSetStructure $SMB::WN_STREAM_EXT_CFG $stream 1 0 StrmExtCfg 0 $h $s $p
}
}



proc wanSetStreamstate { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(mode) 1
set stuff(count) 1
struct_new StreamCtrl WNStreamCtrl
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set StreamCtrl(ulCount) $count
  set StreamCtrl(ucEnable) $mode
  wsLIBCMD HTSetStructure $SMB::WN_STREAM_CTRL $stream 0 0 StreamCtrl 0 $h $s $p
}
}

proc wanCommit { params } {
set stuff(hsp) 0
struct_new StreamCtrl WNStreamCtrl
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
wsLIBCMD HTSetCommand $SMB::WN_COMMIT_CFG 0 0 0 "" $h $s $p
}
}

proc wanDs3DisplayLineinfo { params } {
set stuff(hsp) 0
struct_new lineStatus WNDS3LineStatus
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  wsLIBCMD HTGetStructure $SMB::WN_DS3_LINE_STATUS 0 0 0 lineStatus 0 $h $s $p
  puts -nonewline "   Slot $s Status               ==> "
  switch $lineStatus(ucStatus) {
     0 {puts "LINE/PORT_UP"}
     1 {puts "LINE/PORT DOWN"}
     2 {puts "LINE/PORT DISABLED"}
     default {puts "UNKNOWN LINE STATE $lineStatus(ucStatus)"}
  }
   return $lineStatus(ucStatus)
}
}

proc wanDisplayChannelinfo { params } {
set stuff(hsp) 0
set stuff(chanNum) 0
struct_new chanStatus WNChannelStatus
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
   set chanStatus(ulLineNo) $p
   set chanStatus(ulChannelNo) $chanNum
   wsLIBCMD HTGetStructure $SMB::WN_CHANNEL_STATUS 0 0 0 chanStatus 0 $h $s $p
   puts -nonewline "   Slot $S Line $P Channel $chanNum Status     ==> "
   switch $chanStatus(ucStatus) {
      1 {puts "CHANNEL DOWN"}
      2 {puts "CHANNEL UP"}
      3 {puts "CHANNEL DISABLED"}
      default {puts "UNKNOWN CHANNEL STATE $chanStatus(ucStatus)"}
   }
   return $chanStatus(ucStatus)
}
}

########## PPP FUNCT #######3

proc RetrievePPPStats { params } {
bl::pputs "RetrievePPPStats {cc cpid Start NumSess SetupRate Detail} "
set stuff(hsp) 0
set stuff(Start) 0
set stuff(NumSessions) 1
set stuff(SetupRate) 10
set stuff(Detail) 0

catch { unset PPPInfo }
struct_new PPPInfo PPPStatusInfo*$NumSess
catch { unset PPPSearch }
struct_new PPPSearch PPPStatusSearchInfo
catch { unset PPPIP }
struct_new PPPIP PPPStatusSearchInfo


eval $bl::macro1
foreach port $ports {
eval $bl::macro2
set addon 214748

# misc variables
set lcp ""
set ipcp ""
set ipxcp ""
set failure ""
set pppoe ""
set mode ""
set weack ""
set wegot ""

# Initialize the Min, Max and Avg latency measurements
set ::MinLatency 0
set ::MaxLatency 0
set ::AvgLatency 0
set SumLatencies 0



set iRsp [HTGetStructure $::PPP_STATUS_INFO $Start $NumSess 0 PPPInfo $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPInfo
  exit
}

set PPPSearch(uipppStartIndex) 0
set PPPSearch(uipppCount) $NumSess
set PPPSearch(uipppReturnItemId) $::PPP_STATUS_LATENCY
set PPPSearch(uipppSearchItemId) $::PPP_STATUS_STREAM_INDEX
set PPPSearch(ullpppSearchRangeLow.low) 0
set PPPSearch(ullpppSearchRangeHigh.low) $::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPSearch $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}
set PPPIP(uipppStartIndex) 0
set PPPIP(uipppCount) $NumSess
set PPPIP(uipppReturnItemId) $::PPP_STATUS_LOCAL_IPADDR
set PPPIP(uipppSearchItemId) $::PPP_STATUS_STREAM_INDEX
set PPPIP(ullpppSearchRangeLow.low) 0
set PPPIP(ullpppSearchRangeHigh.low) $::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPSearch $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}
# Get total latency value
set iRsp [HTGetStructure $::PPP_STATUS_INFO $Start 1 0 PPPInfo $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}


if {$Detail == 1} {
  puts "PPP Instance, LCP State, IPCP State, IPXCP State, Failure Code, Magic Number, Our IP Address,\
        Peer's IP Address, Requested Options, Acked Options, MRU, MTU,\
        PPPoE State, PPPoE Mode, PPPoE Session ID, Source MAC, Dest MAC, Latency"
  puts ""
}

puts ""
puts -nonewline "Step 8/8: Getting dynamic PPP-server assigned IP addresses..."; flush stdout
set bl::REPORT_FLAG 0

for {set j $Start} {$j < $NumSess} {incr j} {
  puts -nonewline "."; flush stdout
  if {$Detail == 1} {
    set latency [expr $PPPInfo($j.ullpppLatency.low)/10000]
  } else {
    set latency [expr $PPPSearch(ullpppItem.$j.low)/10000]
  }
  set SumLatencies [expr ($SumLatencies + $latency)]


  # Figure out the Min. Latency
  if {$::MinLatency == 0} {
    set ::MinLatency $latency
  } elseif {$::MinLatency > $latency} {
    set ::MinLatency $latency
  }

  # Figure out the Max. Latency
  if {$::MaxLatency < $latency} {
    set ::MaxLatency $latency
  }
  if {$Detail == 1} {
  # Decode PPP state
  set temp $PPPInfo($j.ucppplcpState)
  if {$temp == $::PPP_LCP_UP} {
    set lcp "LCP Up"
  } elseif {$temp == $::PPP_LCP_DOWN} {
    set lcp "LCP Down"
  } elseif {$temp == $::PPP_LCP_AUTHENTICATING} {
    set lcp "LCP Authenticating"
  }

  set temp $PPPInfo($j.ucpppipcpState)
  if {$temp == $::PPP_NCP_UP} {
    set ipcp "IPCP Up"
  } elseif {$temp == $::PPP_NCP_DOWN} {
    set ipcp "IPCP Down"
  }

  set temp $PPPInfo($j.ucpppipxcpState)
  if {$temp == $::PPP_NCP_UP} {
    set ipxcp "IPXCP Up"
  } elseif {$temp == $::PPP_NCP_DOWN} {
    set ipxcp "IPXCP Down"
  }

  set temp $PPPInfo($j.ucState)
  if {$temp == $::PPP_OE_INACTIVE} {
    set pppoe "Inactive"
  } elseif {$temp == $::PPP_OE_STARTED} {
    set pppoe "Started"
  } elseif {$temp == $::PPP_OE_PADO_SENT} {
    set pppoe "PADO Sent"
  } elseif {$temp == $::PPP_OE_PADR_SENT} {
    set pppoe "PADR Sent"
  } elseif {$temp == $::PPP_OE_SESSION_STATE} {
    set pppoe "Session State"
  }

  # Decode failure code
  set temp $PPPInfo($j.ucppplcpFailCode)
  if {$temp == $::LCP_CLOSE_REASON_UNKNOWN} {
    set failure "Unknown"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_NO_RSP} {
    set failure "Authentication failure: no response"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_LOCAL_REJ} {
    set failure "Authentication failure: local reject"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_PEER_REJ} {
    set failure "Authentication failure: peer reject"
  } elseif {$temp == $::LCP_CONFIG_FAILURE} {
    set failure "LCP configuration failure"
  } elseif {$temp == $::LCP_CONFIG_TIMEOUT} {
    set failure "LCP configuration timeout"
  } elseif {$temp == $::NCP_CONFIG_FAILURE} {
    set failure "NCP configuration failure"
  } elseif {$temp == $::NCP_CONFIG_TIMEOUT} {
    set failure "NCP configuration timeout"
  } elseif {$temp == $::NO_FAILURE} {
    set failure "No failure"
  } elseif {$temp == $::PPP_OE_TIMEOUT_NO_RSP} {
    set failure "PPPoE timeout: no response"
  } elseif {$temp == $::PPP_OE_GEN_ERR} {
    set failure "Generic error"
  } elseif {$temp == $::PPP_OE_SVC_ERR} {
    set failure "Service name error"
  } elseif {$temp == $::PPP_OE_AC_ERR} {
    set failure "AC system error"
  } elseif {$temp == $::PPP_OE_NO_AC} {
    set failure "No AC found"
  }

  set temp $PPPInfo($j.ucMode)
  if {$temp == $::PPP_OE_CLIENT} {
    set mode "Client"
  } else {
    set mode "Disabled"
  }

  # decode PPP options
  set wegot [decodeOpt $PPPInfo($j.ulpppWeGot)]
  set wegot "($wegot)"
  set weack [decodeOpt $PPPInfo($j.ulpppWeAcked)]
  set weack "($weack)"
  if { ! $bl::DEBUG_FLAG } {
    set bl::QUIET_FLAG 1
  } else {
    set bl::QUIET_FLAG 0
  }
  puts -nonewline "$PPPInfo($j.ulpppInstance), $lcp, $ipcp, $ipxcp, $failure, 0x[format %08x $PPPInfo($j.ulpppMagicNumber)], "
  for {set i 0} {$i < 4} {incr i} {
    puts -nonewline "$PPPInfo($j.ucpppOurIPAddr.$i)"
    if {$i != 3} {
       puts -nonewline "."
    } else {
       puts -nonewline ", "
    }
  }

  for {set i 0} {$i < 4} {incr i} {
    puts -nonewline "PEERIP: $PPPInfo($j.ucpppPeerIPAddr.$i)"
    if {$i != 3} {
       puts -nonewline "."
    } else {
       puts -nonewline ", "
    }
  }

  puts -nonewline "$wegot, $weack, $PPPInfo($j.uipppMRU), $PPPInfo($j.uipppMTU), $pppoe, $mode, $PPPInfo($j.uiSessionID), "

  for {set i 0} {$i < 6} {incr i} {
    puts -nonewline "0x[format %02x $PPPInfo($j.ucSourceMAC.$i)]"
    if {$i != 5} {
       puts -nonewline "-"
    } else {
       puts -nonewline ", "
    }
  }

  for {set i 0} {$i < 6} {incr i} {
    puts -nonewline "0x[format %02x $PPPInfo($j.ucDestMAC.$i)]"
    if {$i != 5} {
       puts -nonewline "-"
    } else {
       puts -nonewline ", "
    }
  }

  puts "$latency"
  }

set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.0) [expr $PPPIP(ullpppItem.$j.low) & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.1) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 8)] & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.2) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 16)] & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.3) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 24)] & 0xFF]

set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.0) $PPPInfo($j.ucpppOurIPAddr.0)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.1) $PPPInfo($j.ucpppOurIPAddr.1)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.2) $PPPInfo($j.ucpppOurIPAddr.2)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.3) $PPPInfo($j.ucpppOurIPAddr.3)
set temp $PPPInfo(0.ullpppTotalLatency.low)
if {$temp < 0 } {
  set temp [expr ($temp & 0x7FFFFFFF)/10000]
  set ::TotalLatency [expr $temp + $addon]
} else {
  set ::TotalLatency [expr $temp/10000] ;# specify in msec
}
set bl::info(lib.PPP.totalLatency.$PPPInfo(0.ullpppTotalLatency.high))
}
}
unset PPPInfo
unset PPPSearch
unset PPPIP
}

################################################################################
proc RetrieveLocalIP { params } {
set stuff(hsp) 0
set stuff(CurrEthPortID) 0
set stuff(Start) 1
set stuff(NumSess) 1

catch { unset PPPIP }
struct_new PPPIP PPPStatusSearchInfo

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

set PPPIP(uipppStartIndex) 0
set PPPIP(uipppCount) $NumSess
set PPPIP(uipppReturnItemId) $SMB::PPP_STATUS_LOCAL_IPADDR
set PPPIP(uipppSearchItemId) $SMB::PPP_STATUS_STREAM_INDEX
set PPPIP(ullpppSearchRangeLow.low) 0
set PPPIP(ullpppSearchRangeHigh.low) $SMB::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $SMB::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPIP $h $s1 $p1]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPInfo
  unset PPPIP
  exit
}
set classA       [expr  $PPPIP(ullpppItem.$j.low) & 0xFF]
set classB [expr [expr ($PPPIP(ullpppItem.$j.low) >> 8)] & 0xFF]
set classC [expr [expr ($PPPIP(ullpppItem.$j.low) >> 16)] & 0xFF]
set classD [expr [expr ($PPPIP(ullpppItem.$j.low) >> 24)] & 0xFF]
}
unset PPPIP
return "ClassA.ClassB.ClassC.ClassD"
}

################################################################################
# decodeOpt:: This procedure decodes the PPP options into text
#
################################################################################
proc decodeOpt { params } {
set stuff(temp) 0
set stuff(CurrEthPortID) 0
set stuff(Start) 1
set stuff(NumSess) 1

# decode PPP options
set pppOpt "None"

if {[expr ($temp & $::PPPO_USEPAPAUTH)] == $::PPPO_USEPAPAUTH} {
  set pppOpt "PAP"
}

if {[expr ($temp & $::PPPO_USECHAPAUTH)] == $::PPPO_USECHAPAUTH} {
  if {$pppOpt != "None"} {
    set pppOpt "CHAP,$pppOpt"
  } else {
    set pppOpt "CHAP"
  }
}

if {[expr ($temp & $::PPPO_MRU)] == $::PPPO_MRU} {
  if {$pppOpt != "None"} {
    set pppOpt "MRU,$pppOpt"
  } else {
    set pppOpt "MRU"
  }
}

if {[expr ($temp & $::PPPO_USEMAGIC)] == $::PPPO_USEMAGIC} {
  if {$pppOpt != "None"} {
    set pppOpt "Magic#,$pppOpt"
  } else {
    set pppOpt "Magic#"
  }
}

 return $pppOpt

}


#############################################################################
# proc SetPPPCtrl
#
# Configure passive modes and setup session rate
#############################################################################
proc SetPPPCtrl { params } {
set stuff(hsp) 0
set stuff(SetupRate) 10
set stuff(action) 1

catch { unset PPPCtrlCfg }
struct_new PPPCtrlCfg PPPControlCfg

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

set PPPCtrlCfg(ulpppInstance) 0     ;# Starting stream index
set PPPCtrlCfg(ulpppCount) 0
set PPPCtrlCfg(ucpppAction) $action
set PPPCtrlCfg(ulpppEchoFreq) 0
set PPPCtrlCfg(ulpppEchoErrFreq) 0
set PPPCtrlCfg(ucpppLCPPassiveMode) 0
set PPPCtrlCfg(ucpppIPCPPassiveMode) 0

set temp $SetupRate
if { $SetupRate > 50 } { set temp 50 }
if { $SetupRate <= 0 } { set temp 1 }
set PPPCtrlCfg(ulpppInterConnDelay) [expr 1000/$temp]

set iRsp [HTSetStructure $::PPP_SET_CTRL 0 0 0 PPPCtrlCfg 0 $h $s $p]
if {$iRsp < 0} {
    puts "Error in setting PPP control..."
    unset PPPCtrlCfg
    exit
 }
}
unset PPPCtrlCfg
}



proc PPPConfigRequestNew { params } {
set stuff(hsp) 0
set stuff(Start)  0
set stuff(NumStreams) 1
set stuff(authent) MagicNumber
set stuff(ourId) SMB
set stuff(ourPw) SMB
set stuff(peerId) SMB
set stuff(peerPw) SMB
set stuff(ServiceNameLen) 3
set stuff(ServiceName) SMB
set stuff(sip) 10.0.0.2
set stuff(dip) 20.0.0.2

catch { unset PPPCfg }
struct_new PPPCfg PPPParamCfg

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

## LCP Negotiation options
#foreach option $authent {
#  if {$option == "MRU"} {
#    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_MRU]
#    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_MRU]
#  } elseif {$option == "CHAP"} {
#    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USECHAPAUTH]
#    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USECHAPAUTH]
#  } elseif {$option == "PAP"} {
#    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USEPAPAUTH]
#    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USEPAPAUTH]
#  } elseif {$option == "MagicNumber"} {
#    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USEMAGIC]
#    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USEMAGIC]
#  } else {
#    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USENONE]
#    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USENONE]
#  }
#}
#
## LCP Supported options
#foreach option $authent {
#  if {$option == "MRU"} {
#    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_MRU]
#  } elseif {$option == "CHAP"} {
#    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USECHAPAUTH]
#  } elseif {$option == "PAP"} {
#    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USEPAPAUTH]
#  } elseif {$option == "MagicNumber"} {
#    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USEMAGIC]
#  } else {
#    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USENONE]
#  }
#}
#
## LCP parameters
#set PPPCfg(ucpppEnablePPP) 1
#set PPPCfg(ucpppCHAPAlgo) $SMB::PPP_CHAPMS;
#set PPPCfg(uipppMRU) $SMB::PPP_CONFIGURE_MRU       ;# 1500
#set PPPCfg(uipppMaxFailure) $SMB::PPP_CONFIGURE_MAXFAILURE   ;# 5
#set PPPCfg(uipppMaxConfigure) $SMB::PPP_CONFIGURE_MAXCONFIGURE   ;# 10
#set PPPCfg(uipppMaxTerminate) $SMB::PPP_CONFIGURE_MAXTERMINATE ;# 2
#set PPPCfg(ulpppMagicNumber)  $SMB::PPP_CONFIGURE_MAGICNUMBER  ;# 0
#
#
## IP parameters
#set PPPCfg(ucpppIPEnable) 1
#set PPPCfg(ucpppNegotiateIPAddr) 0
#
#set i -1
#foreach quadrant [split $sip .] {
#  incr i
#  set pppCfg(ucpppOurIPAddr.$i) $quadrant
#}
#
#
#set i -1
#foreach quadrant [split $dip .] {
#  incr i
#  set pppCfg(ucpppPeerIPAddr.$i) $quadrant
#}
#
#
#set pppCfg(uipppRestartTimer) 0x03
#set pppCfg(uipppRetryCount) 0x05
#
#
#set pppCfg(ulpppInstance) 0x00
#set pppCfg(ulpppCount) 0x00   ;# Not used for PPP/ATM - use the PPP Copy, Modify, Fill commands
#
#
#set PPPCfg(ucModFrame) 0
#
#
#set PPPCfg(ucpppOurID._char_) $ourId
#set PPPCfg(ucpppOurPW._char_) $ourPw
#set PPPCfg(ucpppPeerIDr._char_) $peerId
#set PPPCfg(ucpppPeerPWr._char_) $peerPw


set iRsp [HTSetStructure $SMB::PPP_SET_CONFIG 0 0 0 PPPCfg 0 $h $s $p]
if {$iRsp < 0} {
  puts "Error in issuing PPP Config Request..."
  unset PPPCfg
  exit
}

catch { unset PPPCopy }
struct_new PPPCopy PPPParamsCopy
set PPPCopy(uipppSrcStrNum) $Start
set PPPCopy(uipppDstStrNum) [expr $Start + 1]
set PPPCopy(uipppDstStrCount) [expr $NumStreams - 1]

set iRsp [HTSetStructure $SMB::PPP_PARAMS_COPY 0 0 0 PPPCopy 0 $h $s $p]
if {$iRsp < 0} {
  puts "Error in issuing PPP Config Request..."
  unset PPPCfg
  unset PPPCopy
  exit
}
unset PPPCopy
unset PPPCfg
}
}

};#end namespace bl


set bl::MISC_SOURCED 1
}



###
# bl57-scheduler.tcl
###

namespace eval bl {



#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#
#
# SCHEDULER FUNCTIONS
# -------------------
#
#
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################


#############################################################################
# proc setSchedule
# ---------------------------------------
# purpose: for a 10gig card? doesnt work with anything else as of 3.11
# parameters:
# returns:
# notes:
#############################################################################
proc setSchedule { h s p streamNum repeatcount } {
pputs "setSchedule"
eval $bl::macro2


struct_new ss NSStreamScheduleEntry
set ss(uiStreamIndex) $streamNum
set ss(uiRepeatCount) $repeatcount
bl::check HTSetStructure $SMB::NS_STREAM_SCHEDULE 0 0 0 ss 0 $h $s $p
unset ss
}





}



###
# bl57-streams.tcl
###

namespace eval bl {

#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#
#
#
# STREAMS FUNCTIONS
# -----------------
# This sections contains functions for
# setting Smartmetrics streams on our most popular cards.
#
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################


proc burst { params } {
set stuff(num) 10
set stuff(burst) 10
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
if { $num > 0 } {
  bl::check HTTransmitMode $SMB::SINGLE_BURST_MODE $h $s $p
} else {
  bl::check HTTransmitMode $SMB::CONTINUOUS_PACKET_MODE $h $s $p
}
bl::check HTBurstCount $num $h $s $p
}
}

proc clearstreams { params } { clearStreams $params }
proc clearStreams { params } {
pputs "clearStreams $params"

eval $bl::macro1
  foreach port $ports {
  eval $bl::macro2
  vputs "Clearing Streams off of $h/$s/$p"
  bl::check HTSetStructure $SMB::L3_DEFINE_SMARTBITS_STREAM 0 0 0 "" 0 $h $s $p
  }
}


proc groupstreams { { params "ports=-1" } } { bl::streams "port=-1 $params"; puts "" }
proc stream { params } { streams $params }


#############################################################################
# proc streams
# ---------------------------------------
# purpose: makes some streams
# usage  : stream $h $s $p
# returns: nothing
#
# note: speed for OC3, put 155.  For OC12, 622.  For gig, 1000.
#       for e, 10.  for fe, 100.  For 10gige, 10000.  For Oc192, 10000.
#       for oc48, 2.45
#############################################################################
proc streams { params } {
set retval 0
pputs "streams"

set stuff(hsp) 0
set stuff(numStreams) 0
set stuff(burst) 0
set stuff(len) 64
set stuff(percent) 100
set stuff(pps) 1000
set stuff(dmc) 0
set stuff(smc) 0
set stuff(sip) 0
set stuff(dip) 0
set stuff(gtw) 0
set stuff(msk) 0
set stuff(dmcMsk) 0.0.0.0.0.1
set stuff(smcMsk) 0.0.0.0.0.0
set stuff(sipMsk) 0.0.0.0
set stuff(dipMsk) 0.0.0.1
set stuff(gtwMsk) 0.0.0.0
set stuff(streamType) "ip"
set stuff(tos) 0
set stuff(streamIndex) 0
set stuff(udpSrc) 1
set stuff(udpDest) 2079
set stuff(tcpSrc) 16385
set stuff(tcpDest) 80
set stuff(posCrc32) 0
set stuff(posScramble) 1
set stuff(posEncap) HDLC
set stuff(posSpeed) OC12
set stuff(swwn) 1
set stuff(dwwn) 1
set stuff(login) PRIVATE
set stuff(topology) LOOP
set stuff(fcSpeed) 1
set stuff(fcBbcredit) 32
set stuff(incLen) 0
set stuff(randomdata) 0
set stuff(randomlen) 0
set stuff(dataintegrityerror) 0
set stuff(vpi) 0
set stuff(vci) 100
set stuff(pcr) 1000
set stuff(pvcIndex) 0
set stuff(numPvc) 1
set stuff(enc) SNAP
set stuff(qtyPvc) 0
set stuff(pvcQty) 0
set stuff(stepCount) 1
set stuff(limitCount) 10
set stuff(manipulate) $SMB::IP_INC_DST_IP_AND_DST_MAC
set stuff(flows) no
set stuff(perStreamCounters) 0
set stuff(vlanid) 2
set stuff(backgroundbyte) BB
set stuff(backgroundbyte2) CC
set stuff(signed) 1

# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS
# SET DEFAULTS

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

if { "0" == $numStreams } { set numStreams 1 }
if { "0" == $streamType } { set streamType "udp" }
if { "0" == $dmc } {
   #set dmc [list 0x00 0x00 0x00 0x00 0x00 0x00]
   if { $p == 0 } {
      set dmc [makemac "h=$h s=$s p=[expr $p+1]"]
   }
   if { [expr $p % 2] } {
      set dmc [makemac "h=$h s=$s p=[expr $p-1]"]
   } else {
      set dmc [makemac "h=$h s=$s p=[expr $p+1]"]
   }
}
if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
if { "0" == $dip } {
   set dip [makedip "h=$h s=$s p=$p"]
   if { $p == 0 } {
      set dmc [makemac "h=$h s=$s p=[expr $p+1]"]
   }
   if { [expr $p % 2] } {
      set dmc [makemac "h=$h s=$s p=[expr $p-1]"]
   } else {
      set dmc [makemac "h=$h s=$s p=[expr $p+1]"]
   }
}
if { "0" == $gtw } { set gtw [makegtw "h=$h s=$s p=$p"] }
if { "0" == $msk } { set msk "255 255 255 0" }
if { "0" == $dmcMsk } { set dmcMsk "0.0.0.0.0.1" }
if { "0" == $smcMsk } { set smcMsk "0.0.0.0.0.1" }
if { "0" == $sipMsk } { set sipMsk "0.0.0.1" }
if { "0" == $dipMsk } { set dipMsk "0.0.0.1" }
if { "0" == $len } { set len 64 }
if { "0" == $pps } { set pps 1000 }
if { "0" == $streamIndex } { set streamIndex 1 }
if { "0" == $udpSrc } { set udpSrc 1 }
if { "0" == $udpDest } { set udpDest 2079 }
if { "0" == $posCrc32 } { set posCrc32 0 }
if { "0" == $posEncap } { set posEncap HDLC }
if { "0" == $posSpeed } { set posSpeed OC12 }
if { "0" == $swwn } { set swwn 1 }
if { "0" == $dwwn } { set dwwn 1 }
if { "0" == $login } { set login PRIVATE }
if { "0" == $topology } { set topology LOOP }
# BW 2/2/2005  huge bug - this was not subtracting 4!
set len [expr $len -4]
set dmcMsk [split $dmcMsk .]
set smcMsk [split $smcMsk .]
set sipMsk [split $sipMsk .]
set dipMsk [split $dipMsk .]
set gtwMsk [split $gtwMsk .]
set items { dmc smc sip dip gtw msk }
foreach item $items {
  if { [string first . [subst $$item] ] > -1} { set $item  [split [subst $$item] .] }
}

set cardModel $bl::info(pure.$port.cardmodel)

## START Create first stream, and Multi stream, for IP, UDP, TCP


#dputs streamType:$streamType
if {[string first "ip" $streamType] != -1 } {
  if {[string first "vlan" $streamType] != -1 } {
    struct_new IP StreamIPVLAN
    set IP(VLAN_Vid) $vlanid
  } else {
    struct_new IP StreamIP
  }

  set IP(TypeOfService)  $tos
  set IP(ucActive)       1
  set IP(ucProtocolType) $SMB::L3_STREAM_IP
  dputs "len:$len"
  set IP(uiFrameLength)  $len
  set IP(ucTagField)     $signed
#  dputs "--->DMC:$dmc"
  set IP(DestinationMAC) $dmc
  set IP(SourceMAC)      $smc
  set IP(TimeToLive)     64
  set IP(DestinationIP)  $dip
  set IP(SourceIP)       $sip
  set IP(Gateway)        $gtw
  set IP(Netmask)        $msk
  set IP(ulARPGap)       1000

  switch $cardModel {
    "AT-9622" -
    "AT-9015" -
    "AT-9020" -
    "AT-9155C" -
    "AT-9155" -
    "AT-9155CS" {
    }
    "GX-1405" -
    "GX-1420" {
      struct_new gt GIGTransmit
      set gt(uiMainLength) $len
      set gt(ucPreambleByteLength) 8
      set gt(ucFramesPerCarrier) 1
      set gt(ulGap) 9600
      set gt(ucMainRandomBackground) 0
      set gt(uiLinkConfiguration) $SMB::GIG_AFN_FULL_DUPLEX
      set gt(ulBurstCount) $burst
      set gt(ulMultiburstCount) 0
      set gt(ulInterBurstGap) 0
      set gt(ucTransmitMode) 1
      set gt(ucEchoMode) 0
      set gt(ucPeriodicGap) 0
      set gt(ucCountRcverrOrOvrsz) 0
      set gt(ucGapByBitTimesOrByRate) 0
      set gt(ucRandomLengthEnable) 0
      set gt(uiVFD1BlockCount) 1
      set gt(uiVFD2BlockCount) 1
      set gt(uiVFD3BlockCount) 1
      bl::check HTSetStructure $SMB::GIG_STRUC_TX 0 0 0 gt 0 $h $s $p
      unset gt
      bl::check HTDataLength $len $h $s $p
      bl::tcpipBackground "port=$port sip=[join $sip .] dip=[join $dip .] smc=[join $smc .] \
      dmc=[join $dmc .] len=$len"
    }
    "FBC-3601" -
    "FBC-3602" {
    }
    default {
      if {[string first "vlan" $streamType] != -1 } {
        udputs "Creating first IP VLAN stream"
        bl::check HTSetStructure $SMB::L3_MOD_IP_STREAM_VLAN $streamIndex 0 0 IP 0 $h $s $p
      } else {
        udputs "Creating first IP stream"
        bl::check HTSetStructure $SMB::L3_MOD_IP_STREAM $streamIndex 0 0 IP 0 $h $s $p
      }

    }
  }

  udputs "Created IP Stream on $h/$s/$p"
  udputs "---------------------------------"
  udputs "[format %-37s "IP(TypeOfService)  $IP(TypeOfService)"] | [format %-37s "IP(DestinationIP)  $IP(DestinationIP)"]"
  udputs "[format %-37s "IP(ucActive)       $IP(ucActive)"] | [format %-37s "IP(SourceIP)       $IP(SourceIP)"]"
  udputs "[format %-37s "IP(ucProtocolType) $IP(ucProtocolType)"] | [format %-37s "IP(Gateway)        $IP(Gateway)"]"
  udputs "[format %-37s "IP(uiFrameLength)  $IP(uiFrameLength)"] | [format %-37s "IP(Netmask)        $IP(Netmask)"]"
  udputs "[format %-37s "IP(ucTagField)     $IP(ucTagField)"] "
  udputs "[format %-37s "IP(DestinationMAC) $IP(DestinationMAC)"] "
  udputs "[format %-37s "IP(SourceMAC)      $IP(SourceMAC)"]"
  udputs "[format %-37s "IP(TimeToLive)     $IP(TimeToLive)"] | [format %-37s "IP(ulARPGap)       $IP(ulARPGap)"]"
  udputs ""
  udputs "Number of streams: $numStreams"

  # And now define many streams if needed
  if { $numStreams > 1 } {
    if {[string first "vlan" $streamType] != -1 } {
      set IP(VLAN_Vid) 1
      puts "vlan!"
    }
    set IP(TypeOfService)   0
    set IP(ucActive)        0
    set IP(ucProtocolType)  0
    set IP(uiFrameLength)   $incLen
    set IP(ucTagField)      0
    set IP(DestinationMAC)  $dmcMsk
    set IP(SourceMAC)       $smcMsk
    set IP(TimeToLive)      0
    set IP(DestinationIP)   $dipMsk
    set IP(SourceIP)        $sipMsk
    set IP(Gateway)         $gtwMsk
    set IP(Netmask)         "0 0 0 0"
    set IP(ulARPGap)        0
    set IP(uiFrameLength)   $incLen

    switch $cardModel {
      "AT-9622" -
      "AT-9015" -
      "AT-9020" -
      "AT-9155C" -
      "AT-9155" -
      "AT-9155CS" {
      }
      "GX-1405" -
      "GX-1420" {
      }
      "FBC-3601" -
      "FBC-3602" {
      }
      default {
        if {[string first "vlan" $streamType] != -1 } {
          udputs "Defining [expr $numStreams -1] more VLAN IP streams from index [expr $streamIndex +0] dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_IP_STREAM_VLAN [expr $streamIndex +0] [expr $numStreams -1] 0 IP 0 $h $s $p
        } else {
          udputs "Defining [expr $numStreams -1] more IP streams from index [expr $streamIndex +0] dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_IP_STREAM [expr $streamIndex +0] [expr $numStreams -1] 0 IP 0 $h $s $p
        }
      }
    };#end switch card model
  };#endif many streams
  unset IP
};#end IP


if {[string first "udp" $streamType] != -1 } {
  if {[string first "vlan" $streamType] != -1 } {
    struct_new UDP StreamUDPVLAN
    set UDP(VLAN_Vid) $vlanid
  } else {
    struct_new UDP StreamUDP
  }
  set UDP(ucRandomData) $randomdata
  set UDP(TypeOfService)  $tos
  set UDP(ucActive)       1
  set UDP(ucProtocolType) $SMB::L3_STREAM_UDP
  set UDP(uiFrameLength)  $len
  set UDP(ucTagField)     1
  set UDP(DestinationMAC) $dmc
  set UDP(SourceMAC)      $smc
  set UDP(TimeToLive)     64
  set UDP(DestinationIP)  $dip
  set UDP(SourceIP)       $sip
  set UDP(Gateway)        $gtw
  set UDP(Netmask)        $msk
  set UDP(UDPSrc)         $udpSrc
  set UDP(UDPDest)        $udpDest
  set UPD(UDPLen)         1
  set UDP(ulARPGap)       1000

  switch $cardModel {
    "AT-9622" -
    "AT-9015" -
    "AT-9020" -
    "AT-9155C" -
    "AT-9155" -
    "AT-9155CS" {
    }
    "GX-1405" -
    "GX-1420" {
      struct_new gt GIGTransmit
      set gt(uiMainLength) $len
      set gt(ucPreambleByteLength) 8
      set gt(ucFramesPerCarrier) 1
      set gt(ulGap) 9600
      set gt(ucMainRandomBackground) 0
      set gt(uiLinkConfiguration) $SMB::GIG_AFN_FULL_DUPLEX
      set gt(ulBurstCount) $burst
      set gt(ucTransmitMode) 1
      set gt(ucRandomLengthEnable) 0
      bl::check HTSetStructure $SMB::GIG_STRUC_TX 0 0 0 gt 0 $h $s $p
      unset gt
      bl::check HTDataLength $len $h $s $p
      bl::tcpipBackground "port=$port sip=[join $sip .] dip=[join $dip .] smc=[join $smc .] \
      dmc=[join $dmc .] len=$len"
    }
    "FBC-3601" -
    "FBC-3602" {
    }
    default {
      if {[string first "vlan" $streamType] != -1 } {
        udputs "Defining base VLAN UDP stream"
        bl::check HTSetStructure $SMB::L3_MOD_UDP_STREAM_VLAN $streamIndex 0 0 UDP 0 $h $s $p
      } else {
        udputs "Defining base UDP stream"
        bl::check HTSetStructure $SMB::L3_MOD_UDP_STREAM $streamIndex 0 0 UDP 0 $h $s $p
      }
    }
  };#endswitch cardmodel

  udputs "Created UDP Stream on $h/$s/$p"
  udputs "---------------------------------"
  udputs "[format %-40s "UDP(TypeOfService)  $UDP(TypeOfService)"] | [format %-40s "UDP(DestinationIP)  $UDP(DestinationIP)"]"
  udputs "[format %-40s "UDP(ucActive)       $UDP(ucActive)"] | [format %-40s "UDP(SourceIP)       $UDP(SourceIP)"]"
  udputs "[format %-40s "UDP(ucProtocolType) $UDP(ucProtocolType)"] | [format %-40s "UDP(Gateway)        $UDP(Gateway)"]"
  udputs "[format %-40s "UDP(uiFrameLength)  $UDP(uiFrameLength)"] | [format %-40s "UDP(Netmask)        $UDP(Netmask)"]"
  udputs "[format %-40s "UDP(ucTagField)     $UDP(ucTagField)"] | [format %-40s "UDP(UDPSrc)         $UDP(UDPSrc)"]"
  udputs "[format %-40s "UDP(DestinationMAC) $UDP(DestinationMAC)"] | [format %-40s "UDP(UDPDest)        $UDP(UDPDest)"]"
  udputs "[format %-40s "UDP(SourceMAC)      $UDP(SourceMAC)"] | [format %-40s "UDP(UDPLen)         $UDP(UDPLen)"]"
  udputs "[format %-40s "UDP(TimeToLive)     $UDP(TimeToLive)"] | [format %-40s "UDP(ulARPGap)       $UDP(ulARPGap)"]"
  udputs ""

  # And now do Multi UDP Streams if needed
  if { $numStreams > 1 } {
    set UDP(TypeOfService)   0
    set UDP(ucActive)        0
    set UDP(ucProtocolType)  0
    set UDP(uiFrameLength)   $incLen
    set UDP(ucTagField)      0
    set UDP(DestinationMAC)  $dmcMsk
    set UDP(SourceMAC)       $smcMsk
    set UDP(TimeToLive)      0
    set UDP(DestinationIP)   $dipMsk
    set UDP(SourceIP)        $sipMsk
    set UDP(Gateway)         $gtwMsk
    set UDP(Netmask)         "0 0 0 0"
    set UDP(UDPSrc)        0
    set UDP(UDPDest)       0
    set UPD(UDPLen)          0
    set UDP(ulARPGap)        0
    set UDP(uiFrameLength)   $incLen
    switch $cardModel {
      "AT-9622" -
      "AT-9015" -
      "AT-9020" -
      "AT-9155C" -
      "AT-9155" -
      "AT-9155CS" {
      }
      "GX-1405" -
      "GX-1420" {
      }
      "FBC-3601" -
      "FBC-3602" {
      }
      default {

        if {[string first "vlan" $streamType] != -1 } {
          puts "Defining [expr $numStreams -1] more VLAN UDP streams dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_UDP_STREAM_VLAN [expr $streamIndex +0]  [expr $numStreams -1] 0 UDP 0 $h $s $p
        } else {
          puts "Defining [expr $numStreams -1] more UDP streams dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_UDP_STREAM [expr $streamIndex +0 ] [expr $numStreams -1] 0 IP 0 $h $s $p
        }

      }
    };#end switch cardmodel
  };#end if many streams
  unset UDP
};#end UDP


if {[string first "tcp" $streamType] != -1 } {
  if {[string first "vlan" $streamType] != -1 } {
    struct_new TCP StreamTCPVLAN
    set TCP(VLAN_Vid) $vlanid
  } else {
    struct_new TCP StreamTCP
  }
  set TCP(TypeOfService)  $tos
  set TCP(ucActive)       1
  set TCP(ucProtocolType) $SMB::L3_STREAM_TCP
  set TCP(uiFrameLength)  $len
  set TCP(ucTagField)     1
  set TCP(DestinationMAC) $dmc
  set TCP(SourceMAC)      $smc
  set TCP(TimeToLive)     64
  set TCP(DestinationIP)  $dip
  set TCP(SourceIP)       $sip
  set TCP(Gateway)        $gtw
  set TCP(Netmask)        $msk
  set TCP(SourcePort)     $tcpSrc
  set TCP(DestPort)       $tcpDest
  set TCP(ulARPGap)       1000
  switch $cardModel {
  "AT-9622" -
  "AT-9015" -
  "AT-9020" -
  "AT-9155C" -
  "AT-9155" -
  "AT-9155CS" {
  }
  "GX-1405" -
  "GX-1420" {
    bl::tcpipBackground "port=$port sip=[join $sip .] dip=[join $dip .] smc=[join $smc .] \
    dmc=[join $dmc .] len=$len"
  }
  "FBC-3601" -
  "FBC-3602" {
  }
  default {
    if {[string first "vlan" $streamType] != -1 } {
      udputs "Defining base VLAN TCP stream"
      bl::check HTSetStructure $SMB::L3_MOD_TCP_STREAM_VLAN $streamIndex 0 0 TCP 0 $h $s $p
    } else {
      udputs "Defining base TCP stream"
      bl::check HTSetStructure $SMB::L3_MOD_TCP_STREAM $streamIndex 0 0 TCP 0 $h $s $p
    }
  }
  }

  udputs "Created TCP Stream on $h/$s/$p"
  udputs "---------------------------------"
  udputs "TCP(TypeOfService)    $TCP(TypeOfService)"
  udputs "TCP(ucActive)         $TCP(ucActive)"
  udputs "TCP(ucProtocolType)   $TCP(ucProtocolType)"
  udputs "TCP(uiFrameLength)    $TCP(uiFrameLength)"
  udputs "TCP(ucTagField)       $TCP(ucTagField)"
  udputs "TCP(DestinationMAC)   $TCP(DestinationMAC)"
  udputs "TCP(SourceMAC)        $TCP(SourceMAC)"
  udputs "TCP(TimeToLive)       $TCP(TimeToLive)"
  udputs "TCP(DestinationIP)    $TCP(DestinationIP)"
  udputs "TCP(SourceIP)         $TCP(SourceIP)"
  udputs "TCP(Gateway)          $TCP(Gateway)"
  udputs "TCP(Netmask)          $TCP(Netmask)"
  udputs "TCP(SourcePort)       $TCP(SourcePort)"
  udputs "TCP(DestPort)         $TCP(DestPort)"
  udputs "TCP(ulARPGap)         $TCP(ulARPGap)"
  udputs ""

  # And now do multi stream for TCP if needed
  if { $numStreams > 1 } {
    set TCP(TypeOfService)   0
    set TCP(ucActive)        0
    set TCP(ucProtocolType)  0
    set TCP(uiFrameLength)   $incLen
    set TCP(ucTagField)      0
    set TCP(DestinationMAC)  $dmcMsk
    set TCP(SourceMAC)       $smcMsk
    set TCP(TimeToLive)      0
    set TCP(DestinationIP)   $dipMsk
    set TCP(SourceIP)        $sipMsk
    set TCP(Gateway)         $gtwMsk
    set TCP(Netmask)         "0 0 0 0"
    set TCP(SourcePort)      1
    set TCP(DestPort)        0
    set TCP(ulARPGap)        0
    set TCP(uiFrameLength)   $incLen
    switch $cardModel {
      "AT-9622" -
      "AT-9015" -
      "AT-9020" -
      "AT-9155C" -
      "AT-9155" -
      "AT-9155CS" {
      }
      "GX-1405" -
      "GX-1420" {
      }
      "FBC-3601" -
      "FBC-3602" {
      }
      default {
        if {[string first "vlan" $streamType] != -1 } {
          udputs "Defining [expr $numStreams -1] more VLAN TCP streams dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_TCP_STREAM_VLAN $streamIndex [expr $numStreams -1] 0 TCP 0 $h $s $p
        } else {
          udputs "Defining [expr $numStreams -1] more  TCP streams dipMsk:$dipMsk sipMsk:$sipMsk"
          bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_TCP_STREAM $streamIndex [expr $numStreams -1] 0 IP 0 $h $s $p
        }
      }
    }
  };#endif many streams
  unset TCP
};#end of TCP


# END DEFINING IP, UDP, or TCP streams and MUTLI DEFINING STREAMS


# START of STREAM EXTENSION
# And ATM, Fiber Channel, HTBurst, HTGap, and POS CRC, and EXTENSION for frame rate

switch $cardModel {
  "AT-9622" -
  "AT-9015" -
  "AT-9020" -
  "AT-9155C" -
  "AT-9155" -
  "AT-9155CS" {
    if { $qtyPvc > 0 } { set numStreams $qtyPvc }
    if { $pvcQty > 0 } { set numStreams $pvcQty }
    incr numStreams
    incr len -4
    udputs pps:$pps
    set pcr [atmConvertTxRate $pps "pps" $enc $len [atmGetLcr $port]]
    pdputs pcr:$pcr
    pdputs pvcIndex:$pvcIndex
    pdputs numStr:$numStreams
    atmMakeManyBlankStreams $h $s $p $vpi $vci $pvcIndex $numStreams $pcr
    for { set pvcIndex2 0 } { $pvcIndex2 < $numStreams } { incr pvcIndex2 } {
        atmMakeAal5Frame $h $s $p $len $enc $sip $dip $smc $dmc $pvcIndex2
    };#end for each PVC
    atmPerStreamBurst $h $s $p $pvcIndex $numStreams $burst
    atmGlobalTriggerForAal5 $h $s $p
    set startingPvc 0
    atmConnectPvcs $h $s $p $startingPvc $numStreams
    incr numStreams -1
    incr len 4
  }
  "FBC-3601A" -
  "FBC-3602A" -
  "FBC-3601" -
  "FBC-3602" {
  set fcPrivate 0
  set fcPublic 1
  if { $login == "PRIVATE" } {
    set fcLogin $fcPrivate
  } else {
    set fcLogin $fcPublic
  }

  set fcPointToPoint 0
  set fcLoop 1

  if { $topology == "LOOP" } {
    set fcTopology $fcLoop
  } else {
    set fcTopology $fcPointToPoint
  }

  set fcContinuous 0
  set fcBurst 1
  set fcGap 1000

  if { $burst == 0 } {
    set fcTxMode $fcContinuous
    set fcBurstcount 0
  } else {
    set fcBurstcount $burst
    set fcTxMode $fcBurst
  }

  setFcPortConfig $h $s $p $fcTopology $fcSpeed $fcBbcredit

  check HTTransmitMode $fcTxMode $h $s $p
  check HTBurstCount $fcBurstcount $h $s $p
  check HTGap $fcGap $h $s $p

  fcStream $h $s $p $swwn $dwwn $fcLogin $SMB::FC_STREAM_COS_3 $len $numStreams
  fcLink $h $s $p
  fcLogin $h $s $p
  fcDiscoverPrivate $h $s $p
  fcCommit $h $s $p
  set sip $swwn
  set dip $dwwn
  }
  "LAN-6101A/3101A" -
  "LAN-6101A" -
  "LAN-3101A" -
  "LAN-6101/3101" -
  "ML-7710"  -
  "GX-1420"  -
  "GX-1405"  -
  "GX-1420B"  -
  "GX-1405B"  -
  "LAN-6100" -
  "LAN-3100" -
  "LAN-6101" -
  "LAN-3101" {
    if { $burst != 0 } {
      bl::check HTTransmitMode $SMB::SINGLE_BURST_MODE $h $s $p
    } else {
      bl::check HTTransmitMode $SMB::CONTINUOUS_PACKET_MODE $h $s $p
    }
    bl::check HTBurstCount $burst $h $s $p

    if { $bl::info(pure.$port.streams) != "Trad." } {
      catch { unset ex }
      struct_new ex L3StreamExtension
      if { $flows == "yes" } {
        set ex(ucStepCount)            $stepCount
        set ex(ucIPManipulateMode)     $manipulate
        set ex(uiIPLimitCount)         $limitCount
      }
      set ex(ulFrameRate)     $pps
      set ex(ulBurstCount)    $burst
      set ex(ucRandomBGEnable) $randomdata
      if { $cardModel == "LAN-3101" || $cardModel == "LAN-6101" } {
        set ex(ucDataIntegrityErrorEnable) $dataintegrityerror
      }
      for { set ii $streamIndex } { $ii <= $numStreams } {incr ii } {
        udputs "Defining a stream extension at index $ii"
        bl::check HTSetStructure $SMB::L3_MOD_STREAM_EXTENSION $ii 0 0 ex 0 $h $s $p
      }
    }
  }
  "POS-6505" -
  "POS-6504" -
  "POS-3505" -
  "POS-3504" -
  "POS-3518" -
  "POS-3519" {
  catch { unset j }
  struct_new j POSCardLineConfig
  set j(ucCRC32Enabled) $stuff(posCrc32)
  set j(ucScramble) $stuff(posScramble)
  bl::check HTSetStructure $SMB::POS_CARD_LINE_CONFIG 0 0 0 j 0 $h $s $p
  catch { unset j }
  struct_new j POSCardPortEncapsulation
  set j(ucEncapStyle) $SMB::PROTOCOL_ENCAP_TYPE_HDLC_WITH_ETHERTYPE
  bl::check HTSetStructure $SMB::POS_CARD_PORT_ENCAP  0 0 0 j 0 $h $s $p
  bl::check HTScheduleMode $SMB::SCHEDULE_MODE_FRAME_RATE $h $s $p
  bl::check HTBurstCount $burst $h $s $p
  set pps [lindex [split $pps .] 0]
  catch { unset ex }
  udputs pps:$pps
  struct_new ex L3StreamExtension
  set ex(ulFrameRate)     $pps
  set ex(ulBurstCount)    $burst
  set ex(ucRandomBGEnable) $randomdata


# if { $cardModel == "POS-3505" || \
#     $cardModel == "POS-3504" || \
#     $cardModel == "POS-6505" || \
#     $cardModel == "POS-6504" } {
#   set ex(ucRandomLength) $randomlen
# }

  if { $burst > 0 } {
    set ex(ulTxMode) $SMB::L3_SINGLE_BURST_MODE
    bl::check HTTransmitMode $SMB::SINGLE_BURST_MODE $h $s $p
  } else {
    set ex(ulTxMode) $SMB::L3_CONTINUOUS_MODE
    bl::check HTTransmitMode $SMB::CONTINUOUS_PACKET_MODE $h $s $p
  }
  if { $cardModel == "POS-3505" || $cardModel == "POS-3504" } {
    for { set ii $streamIndex } { $ii <= $numStreams } {incr ii } {
      bl::check HTSetStructure $SMB::L3_MOD_STREAM_EXTENSION $ii 0 0 ex 0 $h $s $p
    }
  } else {
    set retval [bl::check HTSetStructure $SMB::L3_MOD_STREAM_EXTENSION $streamIndex 0 0 ex 0 $h $s $p]
    bl::check HTSetStructure $SMB::L3_DEFINE_MULTI_STREAM_EXTENSION $streamIndex [expr $numStreams - 1 ] 0 ex 0 $h $s $p
  }
  unset ex
  }
  "POS-6500B/3500B" -
  "POS-6500B/3500" -
  "POS-6500B" -
  "POS-3500B" -
  "POS-6500" -
  "POS-3500" {
  #Friday, January 19, 2001 4:23 PM
  #This, if uncommented, causes the POS-6500 to reject the L3StreamExtension.
  #So don't uncomment.
  #if { $i == "POS-6500" } { bl::check HTSetSpeed
  #$SMB::POS_SPEED_OC12 $libCh $libSlot $libPort }
  catch { unset j }
  struct_new j POSCardSetSpeed
  if { $stuff(posSpeed) == "OC3" } {
    set j(uiSpeed) $SMB::POS_SPEED_OC3
  } else {
    set j(uiSpeed) $SMB::POS_SPEED_OC12
  }
  bl::check HTSetStructure $SMB::POS_SET_SPEED 0 0 0 j 0 $h $s $p
  catch { unset j }
  struct_new j POSCardLineConfig
  set j(ucCRC32Enabled) $stuff(posCrc32)
  set j(ucScramble) $stuff(posScramble)
  bl::check HTSetStructure $SMB::POS_CARD_LINE_CONFIG 0 0 0 j 0 $h $s $p
  catch { unset j }
  struct_new j POSCardPortEncapsulation
  set j(ucEncapStyle) $SMB::PROTOCOL_ENCAP_TYPE_HDLC_WITH_ETHERTYPE
  bl::check HTSetStructure $SMB::POS_CARD_PORT_ENCAP 0 0 0 j 0 $h $s $p
  set pps [lindex [split $pps .] 0]
  catch { unset ex }
  struct_new ex L3StreamExtension
  if { $burst > 0 } {
    set ex(ulTxMode) $SMB::L3_SINGLE_BURST_MODE
  } else {
    set ex(ulTxMode) $SMB::L3_CONTINUOUS_MODE
  }
  set ex(ulFrameRate) $pps
  set ex(ulBurstCount) $burst
  set ex(ulMBurstCount) 0
  set ex(ulBGPatternIndex) 1
  set ex(ulBurstGap) 0
  set ex(uiInitialSeqNumber) 0

  for { set ii 0 } { $ii <= $numStreams } { incr ii } {
    bl::check HTSetStructure $SMB::L3_MOD_STREAM_EXTENSION $ii 0 0 ex 0 $h $s $p
  }
  unset ex
  }
  "LAN-3201" -
  "LAN-3710" -
  "LAN-3710AL" {
  set pps [lindex [split $pps .] 0]
  struct_new ex L3StreamExtension
  set ex(ulFrameRate) $pps
  set ex(ulTxMode) $SMB::L3_SINGLE_BURST_MODE
  if { $burst == 0 } {
    set ex(ulTxMode) $SMB::L3_CONTINUOUS_MODE
  }
  set ex(ulBurstCount) $burst
  set ex(ulMBurstCount) 0
  set ex(ulBGPatternIndex) 1
  set ex(ulBurstGap) 0
  set ex(uiInitialSeqNumber) 0
  # BW 1/9/2004 11:27 AM set streamIndex 1  I think this is already 1, or we should set it here
  puts sstreamindxx:$streamIndex
  set retval [bl::check HTSetStructure $SMB::L3_MOD_STREAM_EXTENSION $streamIndex 0 0 ex 0 $h $s $p]
  }
  "XLW-3721" -
  "XLW-3720" -
  "LAN-3324" -
  "LAN-3325" -
  "LAN-3302" -
  "LAN-3301" -
  "LAN-3300" -
  "LAN-3310" -
  "LAN-3311" {
    if { $burst > 0 } {
      #puts "setting single burst to $burst"
      bl::check HTTransmitMode $SMB::SINGLE_BURST_MODE $h $s $p
    } else {
      bl::check HTTransmitMode $SMB::CONTINUOUS_PACKET_MODE $h $s $p
    }
    bl::check HTScheduleMode $SMB::SCHEDULE_MODE_FRAME_RATE $h $s $p
    bl::check HTBurstCount $burst $h $s $p
    set pps [lindex [split $pps .] 0]

    # STREAM BACKGROUND!

    catch { unset bgnd }
    struct_new bgnd L3StreamBGConfig

    set sixteen 1
    for { set bgnd_index 0 } {$bgnd_index < 64 } { incr bgnd_index } {
      if { $backgroundbyte2 != -1 } {
        if { $sixteen <= 16 } {
          set bgnd(ucPattern.$bgnd_index) 0x$backgroundbyte
        }
        if { $sixteen > 16 && $sixteen <= 32 } {
          set bgnd(ucPattern.$bgnd_index) 0x$backgroundbyte2
        }
        incr sixteen
        if { $sixteen == 33 } { set sixteen 1 }
      } else {
        set bgnd(ucPattern.$bgnd_index) 0x$backgroundbyte
      }
    }

    bl::check HTSetStructure $SMB::L3_WRITE_STREAM_BG 0 0 0 bgnd 0 $h $s $p

    # STREAM EXTENSION!

    catch { unset ex }
    struct_new ex L3StreamExtension*$numStreams
    for { set i 0 } { $i < $numStreams } { incr i } {
      if { $pps != "random" } {
        set ex($i.ulFrameRate) $pps
      }
      set ex($i.ulBGPatternIndex) 0
      set ex($i.ucRandomBGEnable) $randomdata
      set ex($i.ulBurstCount)     $burst
    }
    udputs "Defining [expr $numStreams] extension(s) at index [expr $streamIndex -1]"


    catch { unset ex }
    struct_new ex L3StreamExtension*$numStreams


    for { set i 0 } { $i < $numStreams } { incr i } {
      if { $pps != "random" } {
        set ex($i.ulFrameRate) $pps
      }
      set ex($i.ulBGPatternIndex) 0
      set ex($i.ucRandomBGEnable) $randomdata
      set ex($i.ulBurstCount)     $burst
      #dputs "Writing Background"
      #bl::check HTSetStructure $SMB::L3_WRITE_STREAM_BG $i 0 0 bgnd 0 $h $s $p
    }
    udputs "Defining [expr $numStreams] extension(s) at index [expr $streamIndex -1]"
    bl::check HTSetStructure $SMB::L3_DEFINE_STREAM_EXTENSION [expr $streamIndex -1] 0 0 ex 0 $h $s $p
  }
}


# END of ATM, Fiber Channel, HTBurst, HTGap, and POS CRC, and EXTENSION for frame rate


# START Setting histogram

if { $perStreamCounters } {
  switch $cardModel {
    "AT-9622" -
    "AT-9015" -
    "AT-9020" -
    "AT-9155C" -
    "AT-9155" -
    "AT-9155CS" {
    }
    "GX-1405" {
    }
    "LAN-3710" -
    "LAN-3710AL" {
    }
    default {
      smartmetricsEnablePerStreamCounters "h=$h s=$s p=$p"
    }
  }
}

# END setting histogram


set psmc ""
set psmci 0
foreach thing $smc {
  set temp [string trim $thing 0x]
  if { $temp == "" } { set temp "00" }
  if { [string length $temp] == 1 } {  set temp 0$temp }
  if { [expr $psmci % 2] } {
    append psmc $temp.
  } else {
    append psmc $temp
  }
  incr psmci
}

set pdmc ""
set pdmci 0
foreach thing $dmc {
  set temp [string trim $thing 0x]
  if { $temp == "" } { set temp "00" }
  if { [string length $temp] == 1 } {  set temp 0$temp }
  if { [expr $pdmci % 2] } {
    append pdmc $temp.
  } else {
    append pdmc $temp
  }
  incr pdmci
}
set pdmc [string trim $pdmc .]
set psmc [string trim $psmc .]

vputs "port=[format %3d $port] $psmc->$pdmc [join $sip .]->[join $dip .]\/[masktoslash [join $msk .]] via [join $gtw .]"
vputs "              streamType=$streamType burst=$burst pps=$pps numStreams=$numStreams"
if { $bl::SHOW_STREAM_DETAILS } {
  vputs "          $burst\pkt $pps\pps $len\B #str:$numStreams ($h/$s/$p = $cardModel )"
  vputs "          stepCount=$stepCount limitCount=$limitCount"
}
set sip 0
set dip 0
set smc 0
set dmc 0
set gtw 0
};#endfor each port

return $retval

};#endproc streams


proc EXLayer2And3StreamMaker { dmc smc sip dip gtw msk burst len pps tos } {
pputs "EXLayer2And3StreamMaker"
set mcDmc [makeMcMac $dip]
return \
[list \
-SourceIP [split $sip .] \
-DestinationIP [split $dip .] \
-Netmask [split $msk .] \
-Gateway [split $gtw .] \
-SourceMAC [split $smc .] \
-DestinationMAC [split $mcDmc .] \
-ulBurstCount $burst \
-uiFrameLength $len \
-ulFrameRate $pps \
-TypeOfService $tos
]
}

}



###
# bl57-telnet.tcl
###

if { ! [info exists bl::TELNET_SOURCED] } {

namespace eval bl {
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#
# TELNET FUNCTIONS
# ----------------
#
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################


# readsocket usage:
#
#  puts "waiting 10 seconds for WR to start"
#  puts ""
#  readsocket $wrsocket 10proc
proc readsocket {  wasocket { i 1 } { quiet 0 } } {
  set fractionSeconds 1
  set retval ""
while { $i } {
  set x [read $wasocket]
  while { $i && $x == "" } {
    incr i -1
     after [expr 1000/$fractionSeconds]
    if { $quiet == 0 && $quiet != "quiet" } {
      puts -nonewline .; flush stdout
    }
    set x [read $wasocket]
  }
  if { $x != "" } {
     after [expr 1000/$fractionSeconds]
    incr i -1
    if { $quiet == 0 && $quiet != "quiet" } {
      puts -nonewline $x
    }
    append retval $x
  }
}
return $retval
}

proc se { sock send expect { maxSeconds 10 } { quiet 0 }  } {
dputs "------->send:$send expect:$expect"
if { $bl::QUIETFLAG } { set quiet 1 }
if { $send != "" } {
  puts $sock $send
  if { ! $quiet } {
    #puts $send
  }
}
if { $maxSeconds > 0 } {
  after 500
}
set u -1
set retval ""
flush $sock
set ee [read $sock]
#if { [string length $ee] < 1 } {
#  puts $sock \n
#}
if { $quiet == 1 } {
  set blahh 77 ;#tcl bug?
}
if { $quiet != 0 } {
  set blakkhh 77 ;#tcl bug?
}
if { $quiet == 0 && $quiet != "quiet" } {
  puts -nonewline $ee
}
set timerindex 0
set fractionSeconds 4
set maxtime [expr $fractionSeconds * $maxSeconds]
set output ""
while { $u < 0 && $timerindex < $maxtime } {
  incr timerindex
  set r [string first $expect $ee]
  if { $r != -1 } {
    if { $timerindex > 1 } {
      if { $quiet == 0 && $quiet != "quiet" } { puts -nonewline $ee }
      set output $retval$ee
    }
    incr u
    set retval 1
  } else {
    if { $quiet == 0 && $quiet != "quiet" } { puts -nonewline $ee }
    #puts "Got wrong thing... sock:$sock $ee<--  send:$send<-- expect:$expect<--"
    #flush $sock
  }
  if { $maxSeconds > 0 } {
    after [expr 1000/$fractionSeconds]
    #after 500
  }
  set ee [read $sock]
}
#if { $retval > -1 } {
#  return $ee
#} else {
#  return -1
#}
return $output
}

proc bl46semaybdontworkfordot1xprogram { sock send expect { maxSeconds 10 } { quiet 0 }  } {
dputs "------->send:$send expect:$expect"
if { $bl::QUIETFLAG } { set quiet 1 }
if { $send != "" } {
  puts $sock $send
}
if { $maxSeconds > 0 } {
  after 500
}
set u -1
set retval -1
flush $sock
set ee [read $sock]
#if { [string length $ee] < 1 } {
#  puts $sock \n
#}
if { $quiet == 1 } {
  set blahh 77 ;#tcl bug?
}

if { $quiet == 0 && $quiet != "quiet" } {
  puts -nonewline $ee
}
set timerindex 0
set fractionSeconds 4
set maxtime [expr $fractionSeconds * $maxSeconds]
while { $u < 0 && $timerindex < $maxtime } {
  incr timerindex
  set r [string first $expect $ee]
  if { $r != -1 } {
    if { $timerindex > 1 } {
      if { $quiet == 0 && $quiet != "quiet" } { puts -nonewline $ee }
    }
    incr u
    set retval 1
  } else {
    #puts ""
    #puts "Got wrong thing... sock:$sock $ee<--  send:$send<-- expect:$expect<--"
    #flush $sock
  }
  if { $maxSeconds > 0 } {
    after [expr 1000/$fractionSeconds]
  }
  set ee [read $sock]
}
#if { $retval > -1 } {
#  return $ee
#} else {
#  return -1
#}
return $ee
}

proc pse {  sock send expect { maxSeconds 50 } { quiet 0 } } {
 puts [se $sock $send $expect $maxSeconds $quiet ]
}



proc readit { x } { puts [read $x]; flush stdout; after 500 }
proc sayit { x y } { puts $x $y; after 500; readit $x }


proc unlock { params } {
  pputs "unlock"
  set stuff(smbip) -1
  set stuff(myip) -1
#  set stuff(slot) -1
  #set stuff(maxArpRetries) 1
  eval $bl::macro1
  set bl::QUIETFLAG 0
  set sock [bl::telnet $smbip]
  bl::se $sock "login" >>
  bl::se $sock "su" word:
  bl::se $sock "SMB-6000" SU>>
  set output [bl::se $sock "show users" SU>>]
  foreach port $ports {
    eval $bl::macro2
    set bl::QUIETFLAG 0
    puts dddddddd:[llength [split $output \n]]
    foreach line [split $output \n] {
      if { [string first "TSU" $line] == -1 } {
        puts "not tsu"
        puts "line:$line  myip:$myip"
        if { [string first $myip $line] > -1 } {
          puts "my ip"
          set cards [split [lindex $line 3] ,]
          set mycard [expr [bl::getslot $port] +1]
          foreach card $cards {
            puts "$card == $mycard ?"
            if { $card == $mycard } {
              set user [lindex $line 0]
              bl::se $sock "user close $user" SU>>
            }
          }
        }
      }
    }
  }
  bl::se $sock "quit" >> 1
}


proc share { params } {
  pputs "share"
  set stuff(numusers) 4
  set stuff(smbip) -1
  set stuff(myip) -1
#  set stuff(slot) -1
  #set stuff(maxArpRetries) 1
  eval $bl::macro1
  set bl::QUIETFLAG 0
  set sock [bl::telnet $smbip]
  eval $bl::macro2
  set bl::QUIETFLAG 0
  bl::se $sock "login" >>
  bl::se $sock "su" word:
  bl::se $sock "SMB-6000" SU>>
  foreach port $ports {
    set mycard [expr [bl::getslot $port] +1]
    bl::se $sock "cards share $mycard $numusers" SU>>
  }
  bl::se $sock "quit" >> 1
}



proc nslookup { smbip { max 2 } } {
  bl::rputs -nonewline "nslooking up $smbip..."
  flush stdout
  set sssttt no_dns_entry
  set dname ?
  set retval [catch { set sssttt [exec nslookup $smbip] } err]
  foreach line [split $sssttt \n] {
    if { [string first "Name:" $line] > -1 } {
      set dname [string trim [lindex [split $line :] 1]]
    }
  }
  #if { $dname == "?" } { return $dname }
  bl::rputs "found $dname"
  return $dname
}

proc telnet { ciscoip {port 23} { debug 0} } {
  set x [catch { set cc [socket -async $ciscoip $port] }  err]
  if { $x == 1 } {
     return -1
  }
  if { [string first "error" $err] > -1 } {
    return -1
  }
  #fconfigure $cc  -blocking 0 -buffering none -translation binary
  fconfigure $cc  -blocking 0
  set errCheck [bl::NegotiateTerm 5 $cc $debug]
  if { $errCheck != -1 } {
    flush $cc
    read $cc
    return $cc
  } else {
    return -1
  }
}


proc opentelnet { ciscoip {port 23} } {
  set err ""
  catch { set cc [socket $ciscoip $port] }  err
  if { $err > "" } {
    #puts cc:$cc
    #return -1
  }
  return $cc
}

proc ciscoshowcpu { i } {
#fconfigure $i -blocking 0 -buffering none
#fconfigure $i -buffering line
#ppp $i ""
ggg $i
ggg $i
ppp $i "show proc cpu"
ggg $i
ggg $i
ggg $i
ppp $i \n
}

proc sendexpect { cc send expect { quiet 0 } } {
#puts "send:$send expect:$expect"
set in $send
if { $in > "" } {
  puts $cc $in
}
after 250
if { $send != "exit" && $send != "\n" } {
  set x [gets $cc]
}
set r -1
set counter 0
while { -1 == $r && $counter < 10 } {
  incr counter
  #puts counter:$counter
  after 250
  set ee [read $cc]
  #puts eelen:[string length $ee]
  if { ! $quiet } {
    puts -nonewline $ee
    flush stdout
    puts \n
  }
  set r [string first $expect $ee]
  if { $r == -1 } { flush stdout; flush $cc } else { puts $cc " " }
  #puts r:$r
}
return $ee
}

proc smblogin { sock {loginpass login} {enablepass SMB-6000} { quiet 0 } } {
  #sendexpect $sock "cisco" word
  sendexpect $sock $loginpass >> $quiet
  sendexpect $sock su word: $quiet
  sendexpect $sock $enablepass SU>> $quiet
  #sendexpect $sock "show ip int brie" #
  #sendexpect $sock "exit" ""
}

proc smbopen { ciscoip {port 23} } {
  set sock [opentelnet $ciscoip $port]
  if { $sock < 0 } {
    return -1
  }
  fconfigure $sock -blocking 0 -buffering none -translation auto
  #fconfigure stdin -blocking 0 -buffering none
  gets $sock
  #puts $sock ""
  after 1000
  return $sock
}



proc ciscologin2 { sock {loginpass cisco} {enablepass cisco} { quiet 0 } } {
  #sendexpect $sock "cisco" word
  sendexpect $sock cisco > $quiet
  sendexpect $sock enable word $quiet
  sendexpect $sock cisco "#" $quiet
  #sendexpect $sock "show ip int brie" #
  #sendexpect $sock "exit" ""
}


proc ciscoopen { ciscoip {port 23} } {
  set sock [opentelnet $ciscoip $port]
  if { $sock < 0 } {
    return -1
  }
  fconfigure $sock -blocking 0 -buffering none -translation auto
  #fconfigure stdin -blocking 0 -buffering none
  gets $sock
  #puts $sock ""
  after 1000
  return $sock
}

proc tellcisco { ciscoip send expect {quiet 1 } } { ciscosend $ciscoip $send $expect $quiet }

proc ciscosend { ciscoip send expect {quiet 1 } } {
  set sock [ciscoopen $ciscoip]
  ciscologin2 $sock cisco cisco 1
  set cpu [sendexpect $sock $send $expect $quiet]
  ciscoclose $sock
  #set cpu [lindex [split $cpu \n] 0]
  return $cpu
}



proc ciscoclose { sock } { close $sock }

proc generaltelnet { ciscoip {port 23} { loginpass cisco } {enablepass cisco}  } {
set cc [socket -async $ciscoip $port]
fconfigure $cc -blocking 0 -buffering none
#-buffering none
#fconfigure $cc -buffering line
fconfigure stdin -blocking 0 -buffering none
set in ""
#gets $cc ee
#after 250
set ee ""
set in "\n"
set prompt1 "word"
while { 1 } {
  gets stdin in
  #set in [readline]
  puts $cc $in
  flush $cc
  #gets $cc ee
  set ee [read $cc];
  puts -nonewline $ee
  flush stdout
#  set ee [read $cc];
#  puts -nonewline $ee
}
close $cc
}

###############################################
# Negotiate with the VTA
###############################################
proc NegotiateTerm { negs handle { Debug 1 } } {
   for {set k 0} {$k < $negs} {incr k} {
      set timer 0
      set i ""
      while {$i == ""} {
       #Read until you can't read no more
       if { [catch { flush $handle } blah] } {
         return -1
       }
       set i [read $handle]
       if { $Debug } { puts i:$i }
       if { $i == ""} { puts $handle "" }
       #Did we go too far
       if {[regexp "LOGIN" [string toupper $i]] || \
           [regexp "NAME"  [string toupper $i]]} {
           return 1
       }
       after 500
       incr timer
       flush stdout
      }
      #Parse it
      set str ""
      for {set j 0} {$j < [string length $i]} {incr j 3} {
         set opt [string range $i $j [expr $j + 3]]
         #Prepare response: 255 <response> <option>
         set respond 252

         #Is this a VTA negotiation?
         set firstByteStr [string range $opt 0 0]
         set chkByte [string range $opt 1 1]
         set doerByte [string range $opt 2 2]
         if {$firstByteStr == [binary format c 255]} {
            #Set correct response
            if {$chkByte == [binary format c 251]} {set respond 254}

            if {$Debug} {
               set firstByte 0
               set secondByte 0
               set thirdByte 0
               binary scan $firstByteStr c firstByte
               binary scan $chkByte c secondByte
               binary scan $doerByte c thirdByte
               puts "VTA Rcv: [expr ($firstByte + 0x100 ) % 0x100] [expr ($secondByte + 0x100 ) % 0x100] [expr ($thirdByte + 0x100 ) % 0x100]"
            }
            #Prepare response
            append str "[binary format cc 255 $respond]$doerByte"
         } else {
            if {$Debug} {
               set firstByte 0
               set secondByte 0
               set thirdByte 0
               binary scan $firstByteStr c firstByte
               binary scan $chkByte c secondByte
               binary scan $doerByte c thirdByte
               puts "Returning VTA Rcv: [expr ($firstByte + 0x100 ) % 0x100] [expr ($secondByte + 0x100 ) % 0x100] [expr ($thirdByte + 0x100 ) % 0x100]"
            }
            #Clear Buffer
            puts $handle ""
            return
         }
      }
      #Send response
      puts -nonewline $handle $str
      after 500
   }
}

proc expectlike2 { ciscoip { loginpass cisco } {enablepass cisco}  } {
#
# ****** THIS IS THE GOOD ONE # BW 6/6/2002 3:20 PM
#
#
set cc [socket -async $ciscoip 23]
fconfigure $cc -blocking 0 -buffering none
#-buffering none
#fconfigure $cc -buffering line
set in ""
#gets $cc ee
#after 250
set ee ""
set in "\n"
set prompt1 "word"
fconfigure stdin -blocking 0 -buffering none
while { 1 } {
  puts -nonewline ""; flush stdout; gets stdin in
  if { $in > "" } {
    puts $cc $in
  }
  after 200
  set x [gets $cc]
  after 200
  set ee [read $cc];
  set ee [string trim $ee \n]
  set jj [string length $ee]
  if { $jj > 0 } {
    set ee [string trim $ee]
    puts -nonewline $ee
  }
}
close $cc
}

proc expectlike { ciscoip { loginpass cisco } {enablepass cisco}  } {
set cc [socket -async $ciscoip 23]
fconfigure $cc -blocking 0 -buffering line
#-buffering none
#fconfigure $cc -buffering line
#fconfigure stdin -blocking 0 -buffering none
set in ""
#gets $cc ee
#after 250
set ee ""
set in "\n"
set prompt1 "word"
while { 1 } {
  puts -nonewline "Enter what you would like to say:"; flush stdout; gets stdin in
  #gets stdin in
  puts -nonewline "Enter new prompt, or just hit <enter> to use existing prompt $prompt1:"; flush stdout; gets stdin pp
  if { $pp != "\n" && $pp != "" } {
    set prompt1 $pp
  }
  puts "Saying $in"
  puts $cc $in
  flush $cc
  set r -1
  while { -1 == $r } {
    incr counter
    after 100
    set ee [read $cc];
    puts -nonewline $ee
    flush stdout
    set r [string first $prompt1 $ee]
    #puts "prompt1:$prompt1 ee:$ee r:$r"
  }
}
close $cc
}

#while { 1 } {
#  puts -nonewline "Enter what you would like to say:"; flush stdout; gets stdin in
#  puts -nonewline "Enter new prompt, or just hit <enter> to use existing prompt $prompt1:"; flush stdout; gets stdin pp
#  #gets stdin in
#  if { $pp != "\n" && $pp != "" } {
#    set prompt1 $pp
#  }
#  puts "Saying $in"
#  puts $cc $in
#  flush $cc
#  set r -1
#  while { -1 == $r } {
#    set ee [read $cc];
#    puts -nonewline $ee
#    flush stdout
#    set r [string first $prompt1 $ee]
#    puts "prompt1:$prompt1 ee:$ee r:$r"
#  }
#}

proc readline {} {
  set inchar ""
  set instring "\n"
  while { $inchar != "\n" } {
    set inchar [read stdin 1]
    if { [regexp \[a-z\[:space:\]\[:punct:\]A-Z0-9\-\] $inchar] } {
      append instring $inchar
    }
  };#endwhile we haven't reached the end of line
  return $instring
}


proc warmRebootChassis { smbip { password SMB-6000 }  } { telnetResetSmb  $smbip $password }

proc telnetResetSmb { smbip { password SMB-6000 }  } {
pputs "telnetResetSmb"
puts $smbip
puts $password
set i [socket $smbip 23]
fconfigure $i -blocking 0
fconfigure $i -buffering line
ggg $i
ggg $i
ppp $i "login"
ggg $i
ppp $i "su"
ggg $i
ppp $i $password
ggg $i
ggg $i
ppp $i \n
ggg $i
ppp $i "reboot"
ggg $i
close $i
}

proc warmRebootModule { smb ip slot { password SMB-6000 }} {
  telnetResetSlot $smbip $slot $password
}

proc telnetResetPort { smbip slot { password SMB-6000 } } { telnetResetSlot $smbip $slot $password }

proc telnetResetSlot { smbip slot { password SMB-6000 } } {
pputs "telnetResetSlot"
set i [socket $smbip 23]
fconfigure $i -blocking 0
fconfigure $i -buffering line
ggg $i
ggg $i
ppp $i "login"
ggg $i
ppp $i "su"
ggg $i
ppp $i $password
ggg $i
ggg $i
ppp $i \n
ggg $i
ppp $i "card reset $slot"
ggg $i
ggg $i
ggg $i
ggg $i
ppp $i \n
after 1000
ppp $i quit
#puts "*********\n\n"
#puts "HEY! the card is resetting.  To REALLY make sure this works"
#puts -nonewline "You should reset the chassis too now.  Do you want to ( y/n )?"
#flush stdout
#gets stdin in
#if { [string tolower $in] == "y" } {
#  ppp $i "reboot"
#} else {
#  ppp $i exitsu
#  ggg $i
#}
close $i
}


proc telnetUserClose { smbip slot { password SMB-6000 } } {
pputs "telnetUserClose"
set i [socket $smbip 23]
fconfigure $i -blocking 0
fconfigure $i -buffering line
ggg $i
ggg $i
ppp $i "login"
ggg $i
ppp $i "su"
ggg $i
ppp $i $password
ggg $i
ggg $i
ppp $i \n
ggg $i
set [j -ppp $i "show users"]
set j [ggg $i]
puts j:$j
set j [ggg $i]
puts j:$j
gets stdin in
exit
ggg $i
ggg $i
ppp $i \n
after 1000
ppp $i quit
#puts "*********\n\n"
#puts "HEY! the card is resetting.  To REALLY make sure this works"
#puts -nonewline "You should reset the chassis too now.  Do you want to ( y/n )?"
#flush stdout
#gets stdin in
#if { [string tolower $in] == "y" } {
#  ppp $i "reboot"
#} else {
#  ppp $i exitsu
#  ggg $i
#}
close $i
}



}

set bl::TELNET_SOURCED 1
}



###
# bl57-trigger.tcl
###

namespace eval bl {


#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#
# TRIGGER FUNCTIONS
# -----------------
#
#
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################

proc trigger { params } {
pputs "trigger"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
struct_new ts HTTriggerStructure
set ts(Offset) 0
set ts(Range) 6
# Will match 11 22 33 44 55 66
set ts(Pattern.0) 0x66
set ts(Pattern.1) 0x55
set ts(Pattern.2) 0x44
set ts(Pattern.3) 0x33
set ts(Pattern.4) 0x22
set ts(Pattern.5) 0x11
bl::check HTTrigger $SMB::HTTRIGGER_1 $SMB::HTTRIGGER_ON ts $h $s $p
set ts(Offset) 48
# Will match FF EE DD CC BB AA
set ts(Pattern.0) 0xAA
set ts(Pattern.1) 0xBB
set ts(Pattern.2) 0xCC
set ts(Pattern.3) 0xDD
set ts(Pattern.4) 0xEE
set ts(Pattern.5) 0xFF
bl::check HTTrigger $SMB::HTTRIGGER2 $SMB::HTTRIGGER_ON ts $h $s $p
unset ts
}
}


###############################################################################################
#
# proc sipTrigger
# -------------------
# purpose: to set the trigger on a receive port to look for a particular sip on incoming packets
# parameters: h s p sip
# returns: nothing
# usage: trigger 0 5 0 10.0.0.2
#############################################################################################
proc sipTrigger { params } {
set stuff(sip) "10.0.0.1"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
pputs "sipTrigger"
eval $bl::macro2
struct_new ts HTTriggerStructure
set ts(Offset) 208
set ts(Range) 4
set classA [lindex [split $sip .] 0]
set classB [lindex [split $sip .] 1]
set classC [lindex [split $sip .] 2]
set classD [lindex [split $sip .] 3]

# Will match 33 44 55 66
set ts(Pattern.0) $classD
set ts(Pattern.1) $classC
set ts(Pattern.2) $classB
set ts(Pattern.3) $classA
bl::check HTTrigger $SMB::HTTRIGGER_1 $SMB::HTTRIGGER_ON ts $h $s $p
unset ts
}
}

proc sipTriggerForEthernet { params } {
pputs "sipTriggerForEthernet"
set stuff(sip) "10.0.0.1"

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
vputs "port=$port trigger=$sip"
struct_new ts HTTriggerStructure
set ts(Offset) 208
set ts(Range) 4
set classA [lindex [split $sip .] 0]
set classB [lindex [split $sip .] 1]
set classC [lindex [split $sip .] 2]
set classD [lindex [split $sip .] 3]
set ts(Pattern.0) $classD
set ts(Pattern.1) $classC
set ts(Pattern.2) $classB
set ts(Pattern.3) $classA
bl::check HTTrigger $SMB::HTTRIGGER_1 $SMB::HTTRIGGER_ON ts $h $s $p
unset ts
}
}


};#end namespace for trigger



###
# bl57-vfd.tcl
###

namespace eval bl {

#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#
#
#
# VFD FUNCTIONS
# -------------
#
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################



proc l3background { params } {
  set stuff(frame_data) c
  eval $bl::macro1
  #puts frame_data:$frame_data
  set frame_data [split $frame_data .]
  set datalen [llength $frame_data]
  struct_new background Int*$datalen
  foreach port $ports {
    eval $bl::macro2
    set i 0
    foreach byte $frame_data {
      set hexbyte 0x$byte
      #puts hexbyte:$hexbyte
      set background($i) $hexbyte
      incr i
    }
    #puts frame_data:$frame_data
    #puts datalen:$datalen
    #bl::check HTFillPattern $datalen background $h $s $p
    bl::check HTSetStructure $SMB::L3_WRITE_STREAM_BG 0 0 0 \
    myL3StreamBGConfig \
    0 \
    $iHub $iSlot $iPort
  }
}


proc background { params } {
  set stuff(frame_data) c
  eval $bl::macro1
  #puts frame_data:$frame_data
  set frame_data [split $frame_data .]
  set datalen [llength $frame_data]
  struct_new background Int*$datalen
  foreach port $ports {
    eval $bl::macro2
    set i 0
    foreach byte $frame_data {
      set hexbyte 0x$byte
      puts "$i hexbyte:$hexbyte"
      set background($i) $hexbyte
      incr i
    }
    #puts frame_data:$frame_data
    #puts datalen:$datalen
    bl::check HTFillPattern $datalen background $h $s $p
  }
}


proc background_terametrics { params } {
  set stuff(pattern) AA
  set stuff(pattern2) -1
  eval $bl::macro1
  for { set i 0 } { $i < 64 } { incr i } {
    if { $pattern2 != -1 } {
      if { [expr $i % 2] } {
        set bg(ucPattern.$i) 0x$pattern
      } else {
        set bg(ucPattern.$i) 0x$pattern2
      }
    } else {
      set bg(ucPattern.$i) 0x$pattern
    }
  }
  bl::check HTSetStructure $::L3_WRITE_STREAM_BG 0 0 0 bg 0 $h $s $p
}

proc createframe { params } {
pputs "createframe"
set stuff(hsp) 0
set stuff(numStreams) 0
set stuff(len) 64
set stuff(dmc) 0
set stuff(smc) 0
set stuff(sip) 0
set stuff(dip) 0
set stuff(streamType) 0
set stuff(protocol) "udp"
set stuff(tos) 0
set stuff(streamIndex) 0
set stuff(udpSrc) 1
set stuff(udpDest) 2079
set stuff(randomdata) 0
set stuff(randomlen) 0

eval $bl::macro1
if { "0" == $numStreams } { set numStreams 1 }
if { "0" == $dmc } { set dmc [list 0x00 0x00 0x00 0x00 0x00 0x00] }
if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
if { "0" == $dip } { set dip [makedip "h=$h s=$s p=$p"] }
if { "0" == $streamType } { set streamType "udp" }
if { "0" == $len } { set len 64 }
if { "0" == $udpSrc } { set udpSrc 1 }
if { "0" == $udpDest } { set udpDest 2079 }


foreach port $ports {
eval $bl::macro2
catch { unset myspec }
struct_new myframe FrameSpecType
set myframe(iEncap) $SMB::ENCAPETHERNET;
set myframe(iSize) 1560;
switch $protocol {
  "ip"  { set temp $SMB::FRAMEPROTOCOLIP }
  "udp" { set temp $SMB::FRAMEPROTOCOLUDP }
  "tcp" { set temp $SMB::FRAMEPROTOCOLTCP }
}
set myframe(iProtocol) $temp
set myframe(iPattern) $SMB::PATAAAA
set frameId [bl::check NSCreateFrame myframe]
set sip [split $sip .]
set dip [split $dip .]
set smc [split $smc .]
set dmc [split $dmc .]
set tos [hexit $tos]
set protocol 17
set ttl 64
puts [array get myframe]
bl::check NSModifyFrame $frameId $SMB::FRAMEDSTMACADDR sip 6
bl::check NSModifyFrame $frameId $SMB::FRAMESRCMACADDR sip 6
bl::check NSModifyFrame $frameId $SMB::FRAMESRCIPADDR sip 4
puts [array get myframe]
bl::check NSModifyFrame $frameId $SMB::FRAMEDSTIPADDR sip 4
structWrite stdout myframe
puts [array get myframe]
exit
bl::check NSModifyFrame $frameId $SMB::FRAMETYPESERVICE tos 1
bl::check NSModifyFrame $frameId $SMB::FRAMEPROTOCOL protocol 1
bl::check NSModifyFrame $frameId $SMB::FRAMETIMETOLIVE ttl 1
bl::check HTFrame $frameId $h $s $p 0
}
}

proc udpbackgroundvlan { params } {
set stuff(protocol) "udp"
set stuff(smc) "0"
set stuff(dmc) "0"
set stuff(sip) "0"
set stuff(dip) "0"
set stuff(len) 64
set stuff(vlanid) -1

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
if { "0" == $dmc } { set dmc "0x00.0x00.0x00.0x00.0x00.0x00" }
if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
if { "0" == $dip } { set dip [makedip "h=$h s=$s p=$p"] }
incr len -4
set datalen $len
set datalist ""

for { set i 0 } { $i < $datalen } { incr i } {
  set frame(ucFrameData.$i) 0xAA
}

foreach item [split $dmc .] { lappend datalist 0x$item }
foreach item [split $smc .] { lappend datalist 0x$item }

# Ethernet Type
if { $vlanid > -1 } {
  lappend datalist 0x81
  lappend datalist 0x00
  lappend datalist 0x00
  lappend datalist [format 0x%0x $vlanid]
}
lappend datalist 0x08
lappend datalist 0x00

switch $protocol {
"ethernet" {}
"udp"   {
    lappend datalist 0x45
    lappend datalist 0x00
    set firsthalf  [format 0x%x [expr $datalen / 256]]
    set secondhalf [format 0x%x [expr $datalen % 256]]
    lappend datalist $firsthalf
    lappend datalist $secondhalf
    lappend datalist 0x0f
    lappend datalist 0x14
    lappend datalist 0x00
    lappend datalist 0x00
    lappend datalist 0x80
    lappend datalist 0x11
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    if { [string first . $sip] > -1 } {
      set sip [split $sip .]
    }
    if { [string first . $dip] > -1 } {
      set dip [split $dip .]
    }
    foreach item $sip {
      lappend datalist $item
    }
    foreach item $dip {
      lappend datalist $item
    }
#    set i 0
#    foreach item $datalist { puts "$i: $item"; incr i }
#    puts ""
#    puts len:[llength $datalist]
#    #exit
    if { $vlanid == -1 } { set headerend 34 } else { set headerend 38 }
    #for { set i 14 } { $i < 34 } { incr i } ##
    for { set i 0 } { $i < $headerend } { incr i } {
      set frame(ucFrameData.$i) [lindex $datalist $i]
    }
#   puts here!
    puts $datalist
    puts [lrange $datalist 18 38]
    exit
    if { $vlanid == -1 } {
      calcChecksum frame 14 34 24 ;#iphdr start, iphdr finish, iphdrchksum index
    } else {
      calcChecksum frame 18 38 28
    }

    struct_new data Int*$datalen
    for {set i 0} {$i < $datalen} {incr i} {
      set rr $frame(ucFrameData.$i)
      set rr [string trim 0x $rr]
      #puts $rr
      puts here!rr:$rr
      set data($i) $rr
    }
    bl::check HTFillPattern $datalen data $h $s $p
    unset data
  }
}
}
}

proc stream128_ether_ip { params } {
  set stuff(protocol) "ip"
  set stuff(smc) "0"
  set stuff(dmc) "0"
  set stuff(sip) "0"
  set stuff(dip) "0"
  set stuff(len) 64
  set stuff(vlanid) -1
  set stuff(stream_index) 0

  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    if { "0" == $dmc } { set dmc "0x00.0x00.0x00.0x00.0x00.0x00" }
    if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
    if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
    if { "0" == $dip } { set dip [makedip "h=$h s=$s p=$p"] }
    incr len -4
    set datalen $len
    set datalist ""

    for { set i 0 } { $i < $datalen } { incr i } {
      set frame(ucFrameData.$i) 0xDD
    }

    foreach item [split $dmc .] { lappend datalist $item }
    foreach item [split $smc .] { lappend datalist $item }

    # Ethernet Type
    if { $vlanid > -1 } {
      lappend datalist 0x81
      lappend datalist 0x00
      lappend datalist 0x00
      lappend datalist [format 0x%0x $vlanid]
    }
    lappend datalist 0x08
    lappend datalist 0x00

    lappend datalist 0x45
    lappend datalist 0x00
    set firsthalf  [format 0x%x [expr $datalen / 256]]
    set secondhalf [format 0x%x [expr $datalen % 256]]
    lappend datalist $firsthalf
    lappend datalist $secondhalf
    lappend datalist 0x0f
    lappend datalist 0x14
    lappend datalist 0x00
    lappend datalist 0x00
    lappend datalist 0x80
    lappend datalist 0x11
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    if { [string first . $sip] > -1 } {
      set sip [split $sip .]
    }
    if { [string first . $dip] > -1 } {
      set dip [split $dip .]
    }
    foreach item $sip {
      lappend datalist 0x$item
    }
    foreach item $dip {
      lappend datalist 0x$item
    }
    if { $vlanid == -1 } { set headerend 34 } else { set headerend 38 }

    for { set i 0 } { $i < $headerend } { incr i } {
      set frame(ucFrameData.$i) [lindex $datalist $i]
    }

    if { $vlanid == -1 } {
      calcChecksum frame 14 34 24 ;#iphdr start, iphdr finish, iphdrchksum index
      set frame(ucFrameData.24) [format 0x%0x $frame(ucFrameData.24)]
      set frame(ucFrameData.25) [format 0x%0x $frame(ucFrameData.25)]
    } else {
      calcChecksum frame 18 38 28
      set frame(ucFrameData.28) [format 0x%0x $frame(ucFrameData.28)]
      set frame(ucFrameData.29) [format 0x%0x $frame(ucFrameData.29)]
    }


    for { set i 35 } { $i < 128 } { incr i } {
      set frame(ucFrameData.$i) [format 0x%0x $i]
    }

    struct_new str StreamSmartBits128
    set str(ucActive) 1
    set str(ucRandomLength) 0
    set str(ucRandomData) 0
    set str(ucProtocolType) $SMB::STREAM_PROTOCOL_SMARTBITS
    set str(ucTagField) 0
    set str(uiFrameLength)  $datalen
    set str(uiVFD3Offset)   0
    set str(uiVFD3Range)    $datalen
    set str(ucVFD3Enable)   $SMB::HVFD_ENABLED
    for { set i 0 } { $i < 128 } { incr i } {
      puts "byte $i: $frame(ucFrameData.$i)"
      lappend yy $frame(ucFrameData.$i)
    }
    set str(ProtocolHeader) $yy
    bl::check HTSetStructure $SMB::L3_MOD_SMARTBITS_128_STREAM $stream_index 0 0 str 0 $h $s $p
    unset str
  }
}



proc tcpipBackground { params } {
pputs "tcpipBackground"

set stuff(protocol) "udp"
set stuff(smc) "0"
set stuff(dmc) "0"
set stuff(sip) "0"
set stuff(dip) "0"
set stuff(len) 64
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
if { "0" == $dmc } { set dmc "0x00.0x00.0x00.0x00.0x00.0x00" }
if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
if { "0" == $dip } { set dip [makedip "h=$h s=$s p=$p"] }
incr len -4
set datalen $len
for { set i 0 } { $i < $datalen } { incr i } {
  set frame(ucFrameData.$i) 0xAA
}
foreach item [split $dmc .] {
lappend datalist $item
}
foreach item [split $smc .] {
lappend datalist $item
}
lappend datalist 0x08
lappend datalist 0x00
switch $protocol {
"ethernet" {}
"udp"   {
    lappend datalist 0x45
    lappend datalist 0x00
    set firsthalf  [format 0x%x [expr $datalen / 256]]
    set secondhalf [format 0x%x [expr $datalen % 256]]
    lappend datalist $firsthalf
    lappend datalist $secondhalf
    lappend datalist 0x0f
    lappend datalist 0x14
    lappend datalist 0x00
    lappend datalist 0x00
    lappend datalist 0x80
    lappend datalist 0x11
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
    if { [string first . $sip] > -1 } {
      set sip [split $sip .]
    }
    if { [string first . $dip] > -1 } {
      set dip [split $dip .]
    }
    foreach item $sip {
      lappend datalist $item
    }
    foreach item $dip {
      lappend datalist $item
    }
#   puts $datalist
#   puts ""
#   puts len:[llength $datalist]
#   exit
    for { set i 0 } { $i < 34 } { incr i } {
    #for { set i 14 } { $i < 34 } { incr i } ##
      set rr [lindex $datalist $i]
      set frame(ucFrameData.$i) $rr
    }
    calcChecksum frame 14 34 24
    struct_new data Int*$datalen
    for {set i 0} {$i < $datalen} {incr i} {
      set rr $frame(ucFrameData.$i)
      #puts $rr
      set data($i) $rr
    }
    bl::check HTFillPattern $datalen data $h $s $p
    unset data
  }
}
}
}


proc tcpipBackgroundwvlan { params } {
  pputs "tcpipBackground"

  set stuff(protocol) "tdp"
  set stuff(smc) "0"
  set stuff(dmc) "0"
  set stuff(sip) "0"
  set stuff(dip) "0"
  set stuff(len) 60
  set stuff(vlanid) -1
  eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    if { "0" == $dmc } { set dmc "0x00.0x00.0x00.0x00.0x00.0x00" }
    if { "0" == $smc } { set smc [makemac "h=$h s=$s p=$p"] }
    if { "0" == $sip } { set sip [makesip "h=$h s=$s p=$p"] }
    if { "0" == $dip } { set dip [makedip "h=$h s=$s p=$p"] }

    #We don't calculate the checksum
    incr len -4

    #fill the background with AA
    for { set i 0 } { $i < $len } { incr i } {
      set frame(ucFrameData.$i) 0xAA
    }

    # Ethernet
    # Ethernet
    # Ethernet
    # Ethernet
    set layer2 ""
    foreach item [split $dmc .] {       lappend layer2 $item     }
    foreach item [split $smc .] {       lappend layer2 $item     }

    # Ethernet Type
    if { $vlanid == -1 } {
      lappend layer2 0x81
      lappend layer2 0x00
      lappend layer2 0x00
      lappend layer2 [format 0x%0x $vlanid]
    }
    lappend layer2 0x08
    lappend layer2 0x00


    #And put it in the frame
    for {set i 0} {$i < [llength $layer2] } {incr i} {
      set frame(ucFrameData.$i) [lindex $layer2 $i]
    }

    set startofip [llength $layer2]

    # IP Header
    # IP Header
    # IP Header
    set layer3 ""
    lappend layer3 0x45
    lappend layer3 0x00
    if { $vlanid > -1 } {
      set firsthalf  [format 0x%0x [expr ($datalen-14) / 256]]
      set secondhalf [format 0x%0x [expr ($datalen-14) % 256]]
    } else {
      set firsthalf  [format 0x%0x [expr ($datalen-18) / 256]]
      set secondhalf [format 0x%0x [expr ($datalen-18) % 256]]
    }
    lappend layer3 $firsthalf
    lappend layer3 $secondhalf
    lappend layer3 0x0f
    lappend layer3 0x14
    lappend layer3 0x00
    lappend layer3 0x00
    lappend layer3 0x80
    switch $protocol {
      "tcp" {lappend layer3 0x06 }
      default { lappend layer3 0x11 } ;#udp
    }
    lappend layer3 0x00 ;#temp checksum, gets overwritten with real one
    lappend layer3 0x00 ;#temp checksum, gets overwritten with real one
    if { [string first . $sip] > -1 } {
      set sip [split $sip .]
    }
    if { [string first . $dip] > -1 } {
      set dip [split $dip .]
    }
    foreach item $sip {
      lappend layer3 $item
    }
    foreach item $dip {
      lappend layer3 $item
    }


    #And put it in the frame
    for { set i $startofip } { $i < [llength $layer3] } { incr i } {
      set frame(ucFrameData.$i) [lindex $layer3 $i]
    }

    #IP Header Checksum -easy
    calcChecksum frame $startofip [llength $layer3] [expr $startofip + 10]

    # Layer 4
    switch $protocol {
      "tcp" {
        set firsthalf  [format 0x%0x [expr $srcport / 256]]
        set secondhalf [format 0x%0x [expr $srcport % 256]]
        lappend datalist $firsthalf
        lappend datalist $secondhalf
        set firsthalf  [format 0x%0x [expr $dstport / 256]]
        set secondhalf [format 0x%0x [expr $dstport % 256]]
        lappend datalist $firsthalf
        lappend datalist $secondhalf
        lappend datalist 0x00
        lappend datalist 0x00
        lappend datalist 0x00
        lappend datalist 0xFF
        lappend datalist 0x00
        lappend datalist 0x00
        lappend datalist 0x00
        lappend datalist 0xFF
        lappend datalist 0x50
        lappend datalist 0x10
        lappend datalist 0x00
        lappend datalist 0x04
        lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
        lappend datalist 0x00 ;#temp checksum, gets overwritten with real one
        }
      "udp" {
        set firsthalf  [format 0x%0x [expr $srcport / 256]]
        set secondhalf [format 0x%0x [expr $srcport % 256]]
        lappend datalist $firsthalf
        lappend datalist $secondhalf
        set firsthalf  [format 0x%0x [expr $dstport / 256]]
        set secondhalf [format 0x%0x [expr $dstport % 256]]
        lappend datalist $firsthalf
        lappend datalist $secondhalf
      }

    }


    if { $protocol == "tcp" } {
      #TCP Header Checksum -not as easy

      # Take off the ethernet header and vlan header, if there is one
      set tcpdatalen [expr $datalen - 20 ]
      if { $vlanid > -1 } {
        set tcpdatalen [expr $tcpdatalen - 4]
      }

      # if the data length is not even add a byte of zeroes to the data to make it even
      set tcpdatalist [lrange $datalist 20 end]

      if { [expr [llength $tcpdatalist] % 2] != 0 } {
        lappend tcpdatalist 0x00
      }

      # create & PRE-pend the pseudo header ( ip addresses, zero, type )
      foreach item $sip {
        lappend sudodatalist $item
      }
      foreach item $dip {
        lappend sudodatalist $item
      }
      lappend sudodatalist 0x00
      lappend sudodatalist 0x17
      lappend sudodatalist $tcpdatalength
      set tcpdata2 $sudodatalist$tcpdatalist

      #get the checksum on the whole lot
      set tcpchecksum [calcTCPChecksum $tcpdata2]

      #Now, put it at offset 17 into the TCP frame

      for {set i 0} {$i < $tcpdatalen} {incr i} {
      }
    }


    struct_new data Int*$datalen
    for {set i 0} {$i < $datalen} {incr i} {
      set rr $frame(ucFrameData.$i)
      set rr [string trim 0x $rr]
      puts here!$rr
      set data($i) $rr
    }
    bl::check HTFillPattern $datalen data $h $s $p
    unset data
  }
}

proc vfd { params } {
pputs "vfd"
set stuff(data) "7.7.7.7.7.7"
set stuff(vfd) 1
set stuff(configuration) "static"
set stuff(offset) "dmc"
set stuff(datacount) 20
set stuff(vid) 2
set stuff(numvlans) 1
set stuff(vp) 0
set stuff(vc) 0
set stuff(vlansmc) 0

eval $bl::macro1
#puts data:$data
foreach port $ports {
eval $bl::macro2
catch { unset vfdstruct }
struct_new vfdstruct HTVFDStructure
  #set vfdstruct(Configuration) $SMB::HVFDSTATIC
  switch [string tolower $configuration] {
    "static" { set temp $SMB::HVFD_STATIC }
    "increment" -
    "incr" -
    "inc" { set temp $SMB::HVFD_INCR }
    "decrement" -
    "decr" -
    "dec" { set temp $SMB::HVFD_DECR }
    "random" -
    "rand" { set temp $SMB::HVFD_RANDOM }
    "off" -
    "none" { set temp $SMB::HVFD_NONE }
  }
#  puts temp:$temp
  set vfdstruct(Configuration) $temp

  switch [string tolower $offset] {
    "dmc" { set offset 0 }
    "smc" { set offset 6 }
    "sip" { set offset 26 }
    "dip" { set offset 30 }
    "vid" { set offset 14 }
    "check" -
    "checksum" -
    "crc" { set offset 24 }
  }
  set offset [expr $offset * 8]

  set vfdstruct(Offset) $offset

  set vlanflag 0

  if { [string tolower $data] == "vlan" } {
    set vlanflag 1
    set data ""
 #   puts startingvid:$vid
    for { set i 0 } { $i < [expr ($numvlans * 2)-1] } { incr i 2 } {

  #    puts "vid:$vid vp:$vp vc:$vc"

      set leftbyte [expr $vid / 256]
      set rightbyte  [expr $vid % 256]
      #put vlan priority into the left byte
      #puts "$leftbyte - $rightbyte"
      set leftbyte [expr $leftbyte | [expr $vp << 5]]
      #puts "$leftbyte - $rightbyte"
      #put vc into the left byte
      set leftbyte [expr $leftbyte | [expr $vc << 4]]
      #puts "$leftbyte - $rightbyte"

      lappend data $leftbyte
      lappend data $rightbyte
      incr vid
      if { $vid > 4095 } {
        break
        ;# set vid 2
      }
    }
  } else {
    set data [split $data .-,]
  }

 foreach item $data {
    if { $offset > 48 && [string is digit $item] } {
      lappend hexdata [format 0x%0x $item]
    } else {
      lappend hexdata 0x$item
    }
  }
  #puts hexdata:$hexdata
  #puts vfd:$vfd
  set datalen [llength $hexdata]

  if { $vfd != "3" } {
    set vfdstruct(Range) $datalen
    catch { unset vfd1Data }
    struct_new vfd1Data Int*$datalen

    for { set i 0 } { $i < $datalen } { incr i } {
      set j [expr $datalen - $i - 1]
      set j2 [lindex $hexdata $j]
      #pdputs --->$j2<----
      set vfd1Data($i.i) $j2
    }

    set vfdstruct(Data) vfd1Data
    set vfdstruct(DataCount) $datacount
  }

  if { $vfd == "1" } {
    bl::check HTVFD $SMB::HVFD_1 vfdstruct $h $s $p
  } elseif { $vfd == "2" } {
    bl::check HTVFD $SMB::HVFD_2 vfdstruct $h $s $p
  } elseif { $vfd == "3" } {
    struct_new vfd3Data Int*$datalen
    for { set i 0 } { $i < $datalen  } { incr i } {
      set vfd3Data($i.i) [lindex $hexdata $i]
      #puts vfd:$i.i-->[lindex $hexdata $i]
    }
    if { $port == 29 } { puts $hexdata }
    if { $port == 26 } { puts $hexdata }

    set vfdstruct(Range) 1
    if { $vlanflag } {
      set vfdstruct(Range) 2
    }
    if { $offset == 48 } {
      puts yes!
      set vfdstruct(Range) 6
    }
    if { $vlansmc } {
      puts yes!2
      set vfdstruct(Range) 10
    }
    puts $vfdstruct(Offset)
    puts $vfdstruct(Range)
    #puts datalen:$datalen
    set vfdstruct(Data) vfd3Data
    set vfdstruct(DataCount) $datalen
    set vfdstruct(Configuration) $SMB::HVFD_ENABLED
    bl::check HTVFD $SMB::HVFD_3 vfdstruct $h $s $p
  }
}
};#endproc vfd

proc vfdvlanl3 { params } { return [vfdl3vlan $params] }
proc vfdl3vlan { params } {
pputs "vfdl3"
set stuff(vfd) 1
set stuff(vid) 2
set stuff(vp) 0
set stuff(vc) 0
set stuff(numvlans) 10
set stuff(numstreams) 1
eval $bl::macro1
foreach port $ports {
eval $bl::macro2

catch { unset vfdstruct }
struct_new vfdstruct NSVFD
set offset 14
set offset [expr $offset * 8 + 5]
set vfdstruct(uiOffset) $offset
set vfdstruct(ulCycleCount) $numvlans
#set vfdstruct(uiBlockCount) 1
set vfdstruct(ucStepValue) 1
#set vfdstruct(ucStepShift) 0
#set vfdstruct(ucSubnetAware) 0
#set vfdstruct(ucSubnetMaskLength) 0
#set vfdstruct(ucEnableCarryChaining) 0
set leftbyte   [expr $vid / 256];#split vlan id into left and right bytes
set rightbyte  [expr $vid % 256]
set leftbyte [expr $leftbyte | [expr $vp << 5]];#put vlan priority into the left byte
set leftbyte [expr $leftbyte | [expr $vc << 4]];#put vc into the left byte
set data [list 0x[format %x $leftbyte] 0x[format %x $rightbyte] 0 0 0 0 ]
set range 2
set vfdstruct(uiRange) $range
set vfdstruct(ucPattern) $data
set vfdstruct(ucType) $SMB::L3_VFD1
set vfdstruct(ucMode) $SMB::L3_VFD_INCR
puts "Setting $numvlans vlans on $numStreams streams on $h/$s/$p"
set streamIndex 1
for { set streamIndex 1 } { $streamIndex <= $numStreams } { incr streamIndex } {
  puts "Setting at $streamIndex vid:$vid"
  bl::check HTSetStructure $SMB::L3_MOD_VFD $streamIndex 0 0 vfdstruct 0 $h $s $p
}
};#end of macro looping through ports
};#endproc vfdl3



};#end namespace eval bl for VFD



###
# bl57-wanppp.tcl
###
namespace eval bl {

############# WAN STRUFF #############

proc wanResetCard { params } {

eval $bl::macro1
#puts "wanReset ports:$ports"
foreach port $ports {
eval $bl::macro2
#puts "Resetting card $h $s $p "
set cardmodel $bl::info(lib.$h/$s/$p.cardmodel)
if {$cardmodel == "WN-3441A" || $cardmodel == "WN-3442A"} {
   wsLIBCMD HTSetCommand $SMB::WN_T1E1_LINE_DEL_ALL 0 0 0 "" $h $s $p
}
wsLIBCMD HTSetCommand $SMB::WN_CHANNEL_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_PVC_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_STREAM_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_LMI_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_PVC_DEL_ALL 0 0 0 "" $h $s $p
wsLIBCMD HTSetCommand $SMB::WN_TRIGGER_DEL_ALL 0 0 0 "" $h $s $p
}
}


proc wanDs3LineConfig { params } {
pputs "ds3_line_config"
set stuff(hsp) 0
set stuff(clockSource) "internal"

eval $bl::macro1
struct_new MyDS3LineCfg WNDS3LineCfg
foreach port $ports {
eval $bl::macro2
if {$clockSource == "internal" } {
 puts "     Setting with internal clock source"
 set clockSource $SMB::WN_CARD_CLK_INTERNAL
} else {
 puts "     Setting with loop clock source"
 set clockSource $SMB::WN_LOOP_TIMED_CLOCK
}
set MyDS3LineCfg(ucActive) 1
set MyDS3LineCfg(ucClocking) $clockSource
set MyDS3LineCfg(ucLoopbackEnable) $SMB::WN_LOOPBACK_DISABLED
#set MyDS3LineCfg(ucLineEncoding) $SMB::WN_DS3_ENCODING_B3ZS
#set MyDS3LineCfg(ucLineBuildout) $SMB::WN_DS3_BUILDOUT_LT225
set MyDS3LineCfg(ucChannelized) $SMB::WN_DS3_UNCHANNELIZED
wsLIBCMD HTSetStructure $SMB::WN_DS3_LINE_CFG 0 0 0 MyDS3LineCfg 0 $h $s $p
}
unset MyDS3LineCfg
}

proc wanDs3SetLineState  { params } {
set stuff(hsp) 0
set stuff(mode) "enable"

eval $bl::macro1
struct_new DS3LineCtrl WNDS3LineCtrl
foreach port $ports {
eval $bl::macro2
if {$mode == "disable" } {
 puts "     Disabling DS3 $h $s $p"
 set mode 0
} else {
 puts "     Enabling DS3 $h $s $p"
 set mode 1
}
set DS3LineCtrl(ucEnable) $mode
wsLIBCMD HTSetStructure $SMB::WN_DS3_LINE_CTRL 0 0 0 DS3LineCtrl 0 $h $s $p
}
}

proc wanChannelConfig { params } {
set stuff(hsp) 0
set stuff(channel) 0
set stuff(slotsPerChannel) 0
set stuff(firstslot) 0

struct_new ChanPhysCfg WNChannelPhysCfg
struct_new ChanAttribCfg WNChannelAttribCfg

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set ChanPhysCfg(ulChannelNo) $channel
  set ChanPhysCfg(ulCount)     1
  ###################################################
  # Given T1 with four slotsPerChannel, for channel 0 firstSlot will be zero
  # and channel will be zero, so start will be 0 + (0 * 4) = 0
  # The for loop will start at 0 ($start) and continue while less then 4
  # This will give channel 0 slots 0,1,2,3
  # Channel 1 will have a firstSlot of 0 and a channel of 1.  This will
  # make start 0 + (1 * 4) = 4
  # This will give channel 1 slots 4,5,6,7
  ####################################################
  set start [expr $firstslot + ($channel * $slotsPerChannel)]
  for {set i $start} {$i < [expr $start + $slotsPerChannel]} {incr i} {
     set ChanPhysCfg(ucTimeSlots.$i) 1 ;#enable
  }
  set ChanPhysCfg(ucCRCOff)   0
  set ChanPhysCfg(ucUseCRC32) 0
  wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_PHYS_CFG 0 0 0 ChanPhysCfg 0 $h $s $p
  set ChanAttribCfg(ulChannelNo) $channel
  set ChanAttribCfg(ulCount) 1
  set ChanAttribCfg(ucEnable) 1
  set ChanAttribCfg(ucConnType) $SMB::WN_CONN_PPP
  set ChanAttribCfg(ucTXMode)   $SMB::WN_TX_CONTINUOUS
  set ChanAttribCfg(ucFCSErr) 0
  set ChanAttribCfg(ucAbortFlag) 0
  set ChanAttribCfg(ulBurstCount)      0
  wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_ATTRIB_CFG 0 0 0 ChanAttribCfg 0 $h $s $p
}
}

proc  wanSetChannelState { params } {
set stuff(hsp) 0
set stuff(channel) 0
set stuff(mode) enable
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
if {$mode == "disable" } {
    puts "     Disabling T1E1 Channel $channel on Line/Port $P "
    set mode 0
  } else {
    puts "     Enabling T1E1 Channel $channel on Port/Line $P "
    set mode 1
  }
  struct_new chCtrl WNChannelCtrl
  set chCtrl(ulLineNo)    $p
  set chCtrl(ulChannelNo) $channel
  set chCtrl(ulCount)     1
  set chCtrl(ucEnable)    $mode
 wsLIBCMD HTSetStructure $SMB::WN_CHANNEL_CTRL 0 0 0 chCtrl 0 $h $s $p
}
}

proc wanStartConfig { params } {

eval $bl::macro1
  foreach port $ports {
    eval $bl::macro2
    wsLIBCMD HTSetCommand $SMB::WN_START_CFG 0 0 0 "" $h $s $p
  }
}

proc wanSetStreamState { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(count) 1
set stuff(mode) 1
struct_new StreamCtrl WNStreamCtrl

eval $bl::macro1
foreach port $ports {
eval $bl::macro2
   set StreamCtrl(ulStreamNo) $stream
   set StreamCtrl(ulCount) 1
   set StreamCtrl(ucEnable) $mode

   wsLIBCMD HTSetStructure $SMB::WN_STREAM_CTRL 0 0 0 StreamCtrl 0 $h $s $p
}
}

proc wanSetStreamMap { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(channel) 0
set stuff(dlci) 0
struct_new StrmExtCfg  WNStreamExtCfg
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set StrmExtCfg(ulCount) 1
  set StrmExtCfg(ulDLCI) $dlci
  set StrmExtCfg(ulLineNo) $p
  set StrmExtCfg(ulChannelNo) $channel
  set StrmExtCfg(ucEncapType) $SMB::WN_RFC1662_RTD_PPP
  set StrmExtCfg(ucCR)     0
  set StrmExtCfg(ucFECN)      0
  set StrmExtCfg(ucBECN)      0
  set StrmExtCfg(ucDE)     0
  set StrmExtCfg(ulFrameRate) 90
  wsLIBCMD HTSetStructure $SMB::WN_STREAM_EXT_CFG $stream 1 0 StrmExtCfg 0 $h $s $p
}
}



proc wanSetStreamstate { params } {
set stuff(hsp) 0
set stuff(stream) 0
set stuff(mode) 1
set stuff(count) 1
struct_new StreamCtrl WNStreamCtrl
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  set StreamCtrl(ulCount) $count
  set StreamCtrl(ucEnable) $mode
  wsLIBCMD HTSetStructure $SMB::WN_STREAM_CTRL $stream 0 0 StreamCtrl 0 $h $s $p
}
}

proc wanCommit { params } {
set stuff(hsp) 0
struct_new StreamCtrl WNStreamCtrl
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
wsLIBCMD HTSetCommand $SMB::WN_COMMIT_CFG 0 0 0 "" $h $s $p
}
}

proc wanDs3DisplayLineinfo { params } {
set stuff(hsp) 0
struct_new lineStatus WNDS3LineStatus
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
  wsLIBCMD HTGetStructure $SMB::WN_DS3_LINE_STATUS 0 0 0 lineStatus 0 $h $s $p
  puts -nonewline "   Slot $s Status               ==> "
  switch $lineStatus(ucStatus) {
     0 {puts "LINE/PORT_UP"}
     1 {puts "LINE/PORT DOWN"}
     2 {puts "LINE/PORT DISABLED"}
     default {puts "UNKNOWN LINE STATE $lineStatus(ucStatus)"}
  }
   return $lineStatus(ucStatus)
}
}

proc wanDisplayChannelinfo { params } {
set stuff(hsp) 0
set stuff(chanNum) 0
struct_new chanStatus WNChannelStatus
eval $bl::macro1
foreach port $ports {
eval $bl::macro2
   set chanStatus(ulLineNo) $p
   set chanStatus(ulChannelNo) $chanNum
   wsLIBCMD HTGetStructure $SMB::WN_CHANNEL_STATUS 0 0 0 chanStatus 0 $h $s $p
   puts -nonewline "   Slot $S Line $P Channel $chanNum Status     ==> "
   switch $chanStatus(ucStatus) {
      1 {puts "CHANNEL DOWN"}
      2 {puts "CHANNEL UP"}
      3 {puts "CHANNEL DISABLED"}
      default {puts "UNKNOWN CHANNEL STATE $chanStatus(ucStatus)"}
   }
   return $chanStatus(ucStatus)
}
}

########## PPP FUNCT #######3

proc RetrievePPPStats { params } {
bl::pputs "RetrievePPPStats {cc cpid Start NumSess SetupRate Detail} "
set stuff(hsp) 0
set stuff(Start) 0
set stuff(NumSessions) 1
set stuff(SetupRate) 10
set stuff(Detail) 0

catch { unset PPPInfo }
struct_new PPPInfo PPPStatusInfo*$NumSess
catch { unset PPPSearch }
struct_new PPPSearch PPPStatusSearchInfo
catch { unset PPPIP }
struct_new PPPIP PPPStatusSearchInfo


eval $bl::macro1
foreach port $ports {
eval $bl::macro2
set addon 214748

# misc variables
set lcp ""
set ipcp ""
set ipxcp ""
set failure ""
set pppoe ""
set mode ""
set weack ""
set wegot ""

# Initialize the Min, Max and Avg latency measurements
set ::MinLatency 0
set ::MaxLatency 0
set ::AvgLatency 0
set SumLatencies 0



set iRsp [HTGetStructure $::PPP_STATUS_INFO $Start $NumSess 0 PPPInfo $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPInfo
  exit
}

set PPPSearch(uipppStartIndex) 0
set PPPSearch(uipppCount) $NumSess
set PPPSearch(uipppReturnItemId) $::PPP_STATUS_LATENCY
set PPPSearch(uipppSearchItemId) $::PPP_STATUS_STREAM_INDEX
set PPPSearch(ullpppSearchRangeLow.low) 0
set PPPSearch(ullpppSearchRangeHigh.low) $::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPSearch $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}
set PPPIP(uipppStartIndex) 0
set PPPIP(uipppCount) $NumSess
set PPPIP(uipppReturnItemId) $::PPP_STATUS_LOCAL_IPADDR
set PPPIP(uipppSearchItemId) $::PPP_STATUS_STREAM_INDEX
set PPPIP(ullpppSearchRangeLow.low) 0
set PPPIP(ullpppSearchRangeHigh.low) $::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPSearch $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}
# Get total latency value
set iRsp [HTGetStructure $::PPP_STATUS_INFO $Start 1 0 PPPInfo $h $s $p]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPSearch
  unset PPPInfo
  unset PPPIP
  exit
}


if {$Detail == 1} {
  puts "PPP Instance, LCP State, IPCP State, IPXCP State, Failure Code, Magic Number, Our IP Address,\
        Peer's IP Address, Requested Options, Acked Options, MRU, MTU,\
        PPPoE State, PPPoE Mode, PPPoE Session ID, Source MAC, Dest MAC, Latency"
  puts ""
}

puts ""
puts -nonewline "Step 8/8: Getting dynamic PPP-server assigned IP addresses..."; flush stdout
set bl::REPORT_FLAG 0

for {set j $Start} {$j < $NumSess} {incr j} {
  puts -nonewline "."; flush stdout
  if {$Detail == 1} {
    set latency [expr $PPPInfo($j.ullpppLatency.low)/10000]
  } else {
    set latency [expr $PPPSearch(ullpppItem.$j.low)/10000]
  }
  set SumLatencies [expr ($SumLatencies + $latency)]


  # Figure out the Min. Latency
  if {$::MinLatency == 0} {
    set ::MinLatency $latency
  } elseif {$::MinLatency > $latency} {
    set ::MinLatency $latency
  }

  # Figure out the Max. Latency
  if {$::MaxLatency < $latency} {
    set ::MaxLatency $latency
  }
  if {$Detail == 1} {
  # Decode PPP state
  set temp $PPPInfo($j.ucppplcpState)
  if {$temp == $::PPP_LCP_UP} {
    set lcp "LCP Up"
  } elseif {$temp == $::PPP_LCP_DOWN} {
    set lcp "LCP Down"
  } elseif {$temp == $::PPP_LCP_AUTHENTICATING} {
    set lcp "LCP Authenticating"
  }

  set temp $PPPInfo($j.ucpppipcpState)
  if {$temp == $::PPP_NCP_UP} {
    set ipcp "IPCP Up"
  } elseif {$temp == $::PPP_NCP_DOWN} {
    set ipcp "IPCP Down"
  }

  set temp $PPPInfo($j.ucpppipxcpState)
  if {$temp == $::PPP_NCP_UP} {
    set ipxcp "IPXCP Up"
  } elseif {$temp == $::PPP_NCP_DOWN} {
    set ipxcp "IPXCP Down"
  }

  set temp $PPPInfo($j.ucState)
  if {$temp == $::PPP_OE_INACTIVE} {
    set pppoe "Inactive"
  } elseif {$temp == $::PPP_OE_STARTED} {
    set pppoe "Started"
  } elseif {$temp == $::PPP_OE_PADO_SENT} {
    set pppoe "PADO Sent"
  } elseif {$temp == $::PPP_OE_PADR_SENT} {
    set pppoe "PADR Sent"
  } elseif {$temp == $::PPP_OE_SESSION_STATE} {
    set pppoe "Session State"
  }

  # Decode failure code
  set temp $PPPInfo($j.ucppplcpFailCode)
  if {$temp == $::LCP_CLOSE_REASON_UNKNOWN} {
    set failure "Unknown"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_NO_RSP} {
    set failure "Authentication failure: no response"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_LOCAL_REJ} {
    set failure "Authentication failure: local reject"
  } elseif {$temp == $::LCP_CLOSE_AUTH_FAILURE_PEER_REJ} {
    set failure "Authentication failure: peer reject"
  } elseif {$temp == $::LCP_CONFIG_FAILURE} {
    set failure "LCP configuration failure"
  } elseif {$temp == $::LCP_CONFIG_TIMEOUT} {
    set failure "LCP configuration timeout"
  } elseif {$temp == $::NCP_CONFIG_FAILURE} {
    set failure "NCP configuration failure"
  } elseif {$temp == $::NCP_CONFIG_TIMEOUT} {
    set failure "NCP configuration timeout"
  } elseif {$temp == $::NO_FAILURE} {
    set failure "No failure"
  } elseif {$temp == $::PPP_OE_TIMEOUT_NO_RSP} {
    set failure "PPPoE timeout: no response"
  } elseif {$temp == $::PPP_OE_GEN_ERR} {
    set failure "Generic error"
  } elseif {$temp == $::PPP_OE_SVC_ERR} {
    set failure "Service name error"
  } elseif {$temp == $::PPP_OE_AC_ERR} {
    set failure "AC system error"
  } elseif {$temp == $::PPP_OE_NO_AC} {
    set failure "No AC found"
  }

  set temp $PPPInfo($j.ucMode)
  if {$temp == $::PPP_OE_CLIENT} {
    set mode "Client"
  } else {
    set mode "Disabled"
  }

  # decode PPP options
  set wegot [decodeOpt $PPPInfo($j.ulpppWeGot)]
  set wegot "($wegot)"
  set weack [decodeOpt $PPPInfo($j.ulpppWeAcked)]
  set weack "($weack)"
  if { ! $bl::DEBUG_FLAG } {
    set bl::QUIET_FLAG 1
  } else {
    set bl::QUIET_FLAG 0
  }
  puts -nonewline "$PPPInfo($j.ulpppInstance), $lcp, $ipcp, $ipxcp, $failure, 0x[format %08x $PPPInfo($j.ulpppMagicNumber)], "
  for {set i 0} {$i < 4} {incr i} {
    puts -nonewline "$PPPInfo($j.ucpppOurIPAddr.$i)"
    if {$i != 3} {
       puts -nonewline "."
    } else {
       puts -nonewline ", "
    }
  }

  for {set i 0} {$i < 4} {incr i} {
    puts -nonewline "PEERIP: $PPPInfo($j.ucpppPeerIPAddr.$i)"
    if {$i != 3} {
       puts -nonewline "."
    } else {
       puts -nonewline ", "
    }
  }

  puts -nonewline "$wegot, $weack, $PPPInfo($j.uipppMRU), $PPPInfo($j.uipppMTU), $pppoe, $mode, $PPPInfo($j.uiSessionID), "

  for {set i 0} {$i < 6} {incr i} {
    puts -nonewline "0x[format %02x $PPPInfo($j.ucSourceMAC.$i)]"
    if {$i != 5} {
       puts -nonewline "-"
    } else {
       puts -nonewline ", "
    }
  }

  for {set i 0} {$i < 6} {incr i} {
    puts -nonewline "0x[format %02x $PPPInfo($j.ucDestMAC.$i)]"
    if {$i != 5} {
       puts -nonewline "-"
    } else {
       puts -nonewline ", "
    }
  }

  puts "$latency"
  }

set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.0) [expr $PPPIP(ullpppItem.$j.low) & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.1) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 8)] & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.2) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 16)] & 0xFF]
set bl::info(lib.PPP.$h/$s/$p.ATMStream.$j.DestIPAddress.3) [expr [expr ($PPPIP(ullpppItem.$j.low) >> 24)] & 0xFF]

set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.0) $PPPInfo($j.ucpppOurIPAddr.0)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.1) $PPPInfo($j.ucpppOurIPAddr.1)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.2) $PPPInfo($j.ucpppOurIPAddr.2)
set bl::(lib.PPP.IPAddrs.$h/$s/$p.$::AbsIdx.LocalIPAddr.3) $PPPInfo($j.ucpppOurIPAddr.3)
set temp $PPPInfo(0.ullpppTotalLatency.low)
if {$temp < 0 } {
  set temp [expr ($temp & 0x7FFFFFFF)/10000]
  set ::TotalLatency [expr $temp + $addon]
} else {
  set ::TotalLatency [expr $temp/10000] ;# specify in msec
}
set bl::info(lib.PPP.totalLatency.$PPPInfo(0.ullpppTotalLatency.high))
}
}
unset PPPInfo
unset PPPSearch
unset PPPIP
}

################################################################################
proc RetrieveLocalIP { params } {
set stuff(hsp) 0
set stuff(CurrEthPortID) 0
set stuff(Start) 1
set stuff(NumSess) 1

catch { unset PPPIP }
struct_new PPPIP PPPStatusSearchInfo

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

set PPPIP(uipppStartIndex) 0
set PPPIP(uipppCount) $NumSess
set PPPIP(uipppReturnItemId) $SMB::PPP_STATUS_LOCAL_IPADDR
set PPPIP(uipppSearchItemId) $SMB::PPP_STATUS_STREAM_INDEX
set PPPIP(ullpppSearchRangeLow.low) 0
set PPPIP(ullpppSearchRangeHigh.low) $SMB::MAX_STREAMS_PER_PORT
set iRsp [HTGetStructure $SMB::PPP_STATUS_SEARCH_INFO $Start $NumSess 0 PPPIP $h $s1 $p1]
if {$iRsp < 0} {
  puts "Error in getting PPP Status info..."
  unset PPPInfo
  unset PPPIP
  exit
}
set classA       [expr  $PPPIP(ullpppItem.$j.low) & 0xFF]
set classB [expr [expr ($PPPIP(ullpppItem.$j.low) >> 8)] & 0xFF]
set classC [expr [expr ($PPPIP(ullpppItem.$j.low) >> 16)] & 0xFF]
set classD [expr [expr ($PPPIP(ullpppItem.$j.low) >> 24)] & 0xFF]
}
unset PPPIP
return "ClassA.ClassB.ClassC.ClassD"
}

################################################################################
# decodeOpt:: This procedure decodes the PPP options into text
#
################################################################################
proc decodeOpt { params } {
set stuff(temp) 0
set stuff(CurrEthPortID) 0
set stuff(Start) 1
set stuff(NumSess) 1

# decode PPP options
set pppOpt "None"

if {[expr ($temp & $::PPPO_USEPAPAUTH)] == $::PPPO_USEPAPAUTH} {
  set pppOpt "PAP"
}

if {[expr ($temp & $::PPPO_USECHAPAUTH)] == $::PPPO_USECHAPAUTH} {
  if {$pppOpt != "None"} {
    set pppOpt "CHAP,$pppOpt"
  } else {
    set pppOpt "CHAP"
  }
}

if {[expr ($temp & $::PPPO_MRU)] == $::PPPO_MRU} {
  if {$pppOpt != "None"} {
    set pppOpt "MRU,$pppOpt"
  } else {
    set pppOpt "MRU"
  }
}

if {[expr ($temp & $::PPPO_USEMAGIC)] == $::PPPO_USEMAGIC} {
  if {$pppOpt != "None"} {
    set pppOpt "Magic#,$pppOpt"
  } else {
    set pppOpt "Magic#"
  }
}

 return $pppOpt

}


#############################################################################
# proc SetPPPCtrl
#
# Configure passive modes and setup session rate
#############################################################################
proc SetPPPCtrl { params } {
set stuff(hsp) 0
set stuff(SetupRate) 10
set stuff(action) 1

catch { unset PPPCtrlCfg }
struct_new PPPCtrlCfg PPPControlCfg

eval $bl::macro1
foreach port $ports {
eval $bl::macro2

set PPPCtrlCfg(ulpppInstance) 0     ;# Starting stream index
set PPPCtrlCfg(ulpppCount) 0
set PPPCtrlCfg(ucpppAction) $action
set PPPCtrlCfg(ulpppEchoFreq) 0
set PPPCtrlCfg(ulpppEchoErrFreq) 0
set PPPCtrlCfg(ucpppLCPPassiveMode) 0
set PPPCtrlCfg(ucpppIPCPPassiveMode) 0

set temp $SetupRate
if { $SetupRate > 50 } { set temp 50 }
if { $SetupRate <= 0 } { set temp 1 }
set PPPCtrlCfg(ulpppInterConnDelay) [expr 1000/$temp]

set iRsp [HTSetStructure $::PPP_SET_CTRL 0 0 0 PPPCtrlCfg 0 $h $s $p]
if {$iRsp < 0} {
    puts "Error in setting PPP control..."
    unset PPPCtrlCfg
    exit
 }
}
unset PPPCtrlCfg
}



proc PPPConfigRequestNew { params } {
  set stuff(hsp) 0
  set stuff(Start)  0
  set stuff(NumStreams) 1
  set stuff(authent) MagicNumber
  set stuff(ourId) SMB
  set stuff(ourPw) SMB
  set stuff(peerId) SMB
  set stuff(peerPw) SMB
  set stuff(ServiceNameLen) 3
  set stuff(ServiceName) SMB
  set stuff(sip) 10.0.0.2
  set stuff(dip) 20.0.0.2

  catch { unset PPPCfg }
  struct_new PPPCfg PPPParamCfg

  eval $bl::macro1
  foreach port $ports {
  eval $bl::macro2

  ## LCP Negotiation options
  #foreach option $authent {
  #  if {$option == "MRU"} {
  #    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_MRU]
  #    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_MRU]
  #  } elseif {$option == "CHAP"} {
  #    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USECHAPAUTH]
  #    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USECHAPAUTH]
  #  } elseif {$option == "PAP"} {
  #    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USEPAPAUTH]
  #    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USEPAPAUTH]
  #  } elseif {$option == "MagicNumber"} {
  #    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USEMAGIC]
  #    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USEMAGIC]
  #  } else {
  #    set PPPCfg(uipppWeWish) [expr $PPPCfg(uipppWeWish) | $SMB::PPPO_USENONE]
  #    set PPPCfg(uipppWeMust) [expr $PPPCfg(uipppWeMust) | $SMB::PPPO_USENONE]
  #  }
  #}
  #
  ## LCP Supported options
  #foreach option $authent {
  #  if {$option == "MRU"} {
  #    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_MRU]
  #  } elseif {$option == "CHAP"} {
  #    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USECHAPAUTH]
  #  } elseif {$option == "PAP"} {
  #    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USEPAPAUTH]
  #  } elseif {$option == "MagicNumber"} {
  #    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USEMAGIC]
  #  } else {
  #    set PPPCfg(uipppWeCan)  [expr $PPPCfg(uipppWeCan) | $SMB::PPPO_USENONE]
  #  }
  #}
  #
  ## LCP parameters
  #set PPPCfg(ucpppEnablePPP) 1
  #set PPPCfg(ucpppCHAPAlgo) $SMB::PPP_CHAPMS;
  #set PPPCfg(uipppMRU) $SMB::PPP_CONFIGURE_MRU       ;# 1500
  #set PPPCfg(uipppMaxFailure) $SMB::PPP_CONFIGURE_MAXFAILURE   ;# 5
  #set PPPCfg(uipppMaxConfigure) $SMB::PPP_CONFIGURE_MAXCONFIGURE   ;# 10
  #set PPPCfg(uipppMaxTerminate) $SMB::PPP_CONFIGURE_MAXTERMINATE ;# 2
  #set PPPCfg(ulpppMagicNumber)  $SMB::PPP_CONFIGURE_MAGICNUMBER  ;# 0
  #
  #
  ## IP parameters
  #set PPPCfg(ucpppIPEnable) 1
  #set PPPCfg(ucpppNegotiateIPAddr) 0
  #
  #set i -1
  #foreach quadrant [split $sip .] {
  #  incr i
  #  set pppCfg(ucpppOurIPAddr.$i) $quadrant
  #}
  #
  #
  #set i -1
  #foreach quadrant [split $dip .] {
  #  incr i
  #  set pppCfg(ucpppPeerIPAddr.$i) $quadrant
  #}
  #
  #
  #set pppCfg(uipppRestartTimer) 0x03
  #set pppCfg(uipppRetryCount) 0x05
  #
  #
  #set pppCfg(ulpppInstance) 0x00
  #set pppCfg(ulpppCount) 0x00   ;# Not used for PPP/ATM - use the PPP Copy, Modify, Fill commands
  #
  #
  #set PPPCfg(ucModFrame) 0
  #
  #
  #set PPPCfg(ucpppOurID._char_) $ourId
  #set PPPCfg(ucpppOurPW._char_) $ourPw
  #set PPPCfg(ucpppPeerIDr._char_) $peerId
  #set PPPCfg(ucpppPeerPWr._char_) $peerPw


  set iRsp [HTSetStructure $SMB::PPP_SET_CONFIG 0 0 0 PPPCfg 0 $h $s $p]
  if {$iRsp < 0} {
    puts "Error in issuing PPP Config Request..."
    unset PPPCfg
    exit
  }

  catch { unset PPPCopy }
  struct_new PPPCopy PPPParamsCopy
  set PPPCopy(uipppSrcStrNum) $Start
  set PPPCopy(uipppDstStrNum) [expr $Start + 1]
  set PPPCopy(uipppDstStrCount) [expr $NumStreams - 1]

  set iRsp [HTSetStructure $SMB::PPP_PARAMS_COPY 0 0 0 PPPCopy 0 $h $s $p]
  if {$iRsp < 0} {
    puts "Error in issuing PPP Config Request..."
    unset PPPCfg
    unset PPPCopy
    exit
  }
  unset PPPCopy
  unset PPPCfg
  }
};#end proc PPPConfigRequestNew

};#end namespace BL for WAN and PPP




##params: lease has a prefix of: -
##see, either side of the dash put the character you want to demarkate the value you're after
#proc chopit { $line $params } {
#   set ll [llength $params]
#   set i 0
#   while { $i < $ll } {
#      set param [lindex $params $i]
#      set val [lindex [split $param :] 1]
#      set param [lindex [split $param :] 0]
#      set ss $param
#      set ssl [string length $ss]
#      set s [string first $ss $line]
#      if { $s > -1 } {
#         #found it!
#         set line [string range $line [expr $s+$ssl] end]
#         set leftside [lindex [split $val -] 0]
#         set rightside [lindex [split $val -] 1]
#         set leftpos [string first $line $leftside]
#         set rightpos [string first [string range $line [expr $leftpos+1] end] $rightpos]
#         set val [string range $line $leftpos $rightpos]
#         lappend ret_vals $val
#         set remainingparams [lrange $params [expr $i+1] [llength $params]]
#         puts here->[chopit $line $remainingparams]
#      }
#      return $ret_vals
#   }
#}


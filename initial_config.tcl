create script initial_config.tcl {
    proc script::run {} {
        getFeedback
    }
    
    proc getFeedback {} {
        puts "Welcome to the Walmart BIGIP:LTM Initial Configuration Script!"
        puts ""
        puts "This script will set the initial configuration of the BIGIP:LTM"
        puts "so that Enterprise Manager can connect and put the full configuration."
        puts ""
        puts ""
        puts "Is this an HA Pair (y/n)? "
        set hapair [gets stdin]
        puts ""
        puts "VLAN and Self IP Related Questions"
        puts ""
        puts ""
        puts "How many VLANs? "
        set numVLANs [gets stdin]
        puts "Is this LTM going to be in an HA pair? "
        set hapair [gets stdin]
        if { $numVLANs > 0 }{
                for {set x 0} {$x < $numVLANs} {incr x} {
                    puts "VLAN Name: "
                    set vlanname [gets stdin]
                    puts "VLAN Tag: "
                    set vlantag [gets stdin]
                    puts "Interface or Trunk Name? "
                    set interface [gets stdin]
                    puts "Self IP Name for VLAN (this is a string)? "
                    set ipname [gets stdin]
                    puts "Self IP Address for VLAN? "
                    set ipaddr [gets stdin]
                    puts "Subnet Mask for Self IP? "
                    set netmask [gets stdin]
                    if {$hapair eq "y"}{
                        puts "Floating IP Name for VLAN (this is a string)? "
                        set floatername [gets stdin]
                        puts "Floating IP Address for VLAN? "
                        set floaterip [gets stdin]
                    }
                    tmsh::begin_transaction
                    tmsh::create /net vlan $vlanname tag $vlantag interfaces add \{ $interface \}
                    tmsh::create /net self $ipname address $ipaddr/$netmask vlan $vlanname allow-service default traffic-group traffic-group-local-only
                    tmsh::commit_transaction
                    if {$hapair eq "y"}{
                        tmsh::begin_transaction
                        tmsh::create /net self $floatername address $floaterip/$netmask vlan $vlanname allow-service default traffic-group traffic-group-1
                        tmsh::commit_transaction
                    }
                }
            }
        puts "Do You Wish to Configure DNS (y/n)? "
        set configdns [gets stdin]
        if { $configdns eq "y" }{
            puts "Enter All Name Servers (space delimited): "
            set nsips [split [gets stdin] " "]
            puts "Enter Domain Suffixes (space delimited): "
            set suffix [split [gets stdin] " "]
            tmsh::begin_transaction
            tmsh::modify /sys dns name-servers add { $nsips } search add { $suffix }
            tmsh::commit_transaction
        }
        puts "Do You Wish to Configure NTP (y/n)? "
        set configntp [gets stdin]
        if { $configntp eq "y" }{
            puts "What TimeZone? "
            set tz [gets stdin]
            puts "Enter All NTP Servers (space delimited): "
            set ntpips [split [gets stdin] " "]
            tmsh::begin_transaction
            tmsh::modify /sys ntp timezone $tz servers add { $ntpips }
            tmsh::commit_transaction
        }
        puts "You Have Completed Provisioning This F5 Networks Device. Below is the configuration of this Device."
        puts ""
        puts ""
        tmsh::display [tmsh::list all-properties]
    }
}
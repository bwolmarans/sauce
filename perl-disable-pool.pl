use SOAP::Lite;
use UNIVERSAL 'isa';
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

# Description: Enables/Disables a pool member in all pools of all BIG-IP devices managed by EM.
# Usage: test-icontrolproxy-pool-member-state.pl host uid pwd pool_member enable|disable
 
#----------------------------------------------------------------------------
# Validate Arguments
#----------------------------------------------------------------------------
my $sHost = $ARGV[0];        # EM Host
my $sUID = $ARGV[1];        # EM User (administrator role)
my $sPWD = $ARGV[2];        # EM Password
my $sPoolMember = $ARGV[3];    # BIG-IP Pool Member
my $sState = $ARGV[4];        # BIG-IP Pool Member State: enable/disable
 
my $proxy_uri = sprintf("https://%s:443/iControl/iControlPortal.cgi", $sHost);
my $soap = SOAP::Lite->proxy($proxy_uri);
 
sub SOAP::Transport::HTTP::Client::get_basic_credentials {
    return $sUID => $sPWD;
}
 
sub checkResponse {
    my ($resp) = (@_);
    die "$resp->faultcode $resp->faultstring\n" if $resp->fault;
       
    if (@{$resp->result}) {
        print "\tItem: $_\n" foreach (@{$resp->result});
    }
    else {
        printf "\tResult: %s\n", $resp->result;
    }
}
 
sub getPoolList()
{
    $soapResponse = $soap->uri("urn:iControl:LocalLB/Pool")->get_list();
    &checkResponse($soapResponse);
    my @pool_list = @{$soapResponse->result};
     
    return @pool_list;
}
 
sub getMemberLists()
{
    my (@pool_list) = (@_);
     
    # Get the list of pool members for all the pools.
    $soapResponse = $soap->uri("urn:iControl:LocalLB/Pool")->get_member
    (
        SOAP::Data->name(pool_names => [@pool_list])
    );
    &checkResponse($soapResponse);
    @member_lists = @{$soapResponse->result};
     
    return @member_lists;
}
 
sub findPoolsFromMember()
{
    my ($node_addr_port) = (@_);
    my ($node_addr, $node_port) = split(/:/, $node_addr_port, 2);
    my @pool_match_list;
     
    my @pool_list = &getPoolList();
    my @member_lists = &getMemberLists(@pool_list);
 
    for $i (0 .. $#pool_list)
    {
        $pool = @pool_list[$i];
        foreach $member (@{@member_lists[$i]})
        {
            $addr = $member->{"address"};
            $port = $member->{"port"};
             
            if ( ($node_addr eq $addr) && ($node_port eq $port) )
            {
                push @pool_match_list, $pool;
            }
        }
    }
    return @pool_match_list;
}
 
sub setPoolMemberState()
{
    my ($node_addr_port, $state) = (@_);
    my ($node_addr, $node_port) = split(/:/, $node_addr_port, 2);
    my @pool_list = &findPoolsFromMember($node_addr_port);
    my $member = { address => $node_addr, port => $node_port };
    my $ENABLED_STATE = "STATE_ENABLED";
     
    if ( $state eq "disable" )
    {
        $ENABLED_STATE = "STATE_DISABLED";
    }
     
    my $MemberMonitorState  = { member => $member, monitor_state => $ENABLED_STATE };
    my @MemberMonitorStateList;
    push @MemberMonitorStateList, $MemberMonitorState;
     
    my @MemberMonitorStateLists;
    for $i (0 .. $#pool_list)
    {
        push @MemberMonitorStateLists, [@MemberMonitorStateList];
    }
     
    # Make call to set_monitor_state 
    $soapResponse = $soap->uri("urn:iControl:LocalLB/PoolMember")->set_monitor_state(
        SOAP::Data->name(pool_names => [@pool_list]),
        SOAP::Data->name(monitor_states => [@MemberMonitorStateLists])
    );
    &checkResponse($soapResponse);
     
    print "Pool member $node_addr_port set to $ENABLED_STATE in pools: ";
    foreach $pool (@pool_list)
    {
        print "$pool, ";
    }
    print "\n";
}
 
#----------------------------------------------------------------------------
# Main application entry point.
#----------------------------------------------------------------------------
 
# EM: get devices.
print "\nGet devices...\n";
my $resp = $soap->uri('urn:iControl:Management/EM')->get_devices();
my $device_list = $resp->result;
 
# EM: generate a context ID.
print "\nGenerate context ID...\n";
$resp = $soap->uri("urn:iControl:Management/EM")->get_context_id();
my $context_id = $resp->result;

# Append context ID to SOAP URI.
$proxy_uri = sprintf("%s?context_id=%s", $proxy_uri, $context_id);
$soap = SOAP::Lite->proxy($proxy_uri);
 
# Iterate through the device list.
foreach (@{$device_list}) {
 
    # Get current device address.
    my $device = $_;
 
    # EM: set device context (to proxy to).
    print "\nSet device context...\n";
    $resp = $soap->uri("urn:iControl:Management/EM")->set_device_context(SOAP::Data->name("ip_address" => $device));
    &checkResponse($resp);
     
    # Set pool member state.
    &setPoolMemberState($sPoolMember, $sState);
}

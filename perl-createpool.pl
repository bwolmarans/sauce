#use SOAP::Lite + trace => qw(method debug);
use SOAP::Lite;
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

#----------------------------------------------------------------------------
# Validate Arguments
#----------------------------------------------------------------------------
my $sHost = $ARGV[0];
my $sUID = $ARGV[1];
my $sPWD = $ARGV[2];
my $sPool = $ARGV[3];
my $sMemberList = $ARGV[4];

sub usage()
{
  die ("Usage: PoolMember.pl host port uid pwd [poolname member1:ip,member2:ip,...])\n");
}

if ( ($sHost eq "") or ($sUID eq "") or ($sPWD eq "") )
{
  usage();
}

#----------------------------------------------------------------------------
# Transport Information
#----------------------------------------------------------------------------
sub SOAP::Transport::HTTP::Client::get_basic_credentials
{
  return "$sUID" => "$sPWD";
}

$Pool = SOAP::Lite
  -> uri('urn:iControl:LocalLB/Pool')
  -> readable(1)
  -> proxy("https://$sHost/iControl/iControlPortal.cgi");

#----------------------------------------------------------------------------
# Attempt to add auth headers to avoid dual-round trip
#----------------------------------------------------------------------------
eval { $Pool->transport->http_request->header
(
  'Authorization' =>
  'Basic ' . MIME::Base64::encode("$sUID:$sPWD", '')
); };

#----------------------------------------------------------------------------
# Main logic
#----------------------------------------------------------------------------
if ( "" eq $sPool )
{
  #------------------------------------------------------------------------
  # No pool supplied.  Query pool list and display members for given pool
  #------------------------------------------------------------------------
  $soapResponse = $Pool->get_list();
  &checkResponse($soapResponse);
  @pool_list = @{$soapResponse->result};
  $soapResponse = $Pool->get_member
  (
    SOAP::Data->name(pool_names => [@pool_list])
  );
  @memberListAofA = @{$soapResponse->result};
  for $i (0 .. $#pool_list)
  {
    $pool = @pool_list[$i];
    @memberListA = @{@memberListAofA[$i]};
    
    print "POOL $pool\n";
    foreach $member (@memberListA)
    {
      $addr = $member->{"address"};
      $port = $member->{"port"};
      
      print "  -> $addr:$port\n";
    }
  }
}
elsif ( "" ne $sMemberList )
{
  #------------------------------------------------------------------------
  # Pool and member list supplied, try to create new pool
  #------------------------------------------------------------------------
  @MemberDefA;
  
  @memberListA = split(/,/, $sMemberList, 5);
  foreach $memberItem (@memberListA)
  {
    ($memberAddr, $memberPort) = split(/:/, $memberItem, 2);
    $member =
    {
      address => $memberAddr,
      port => $memberPort
    };
    push @memberDefA, $member;
  }
  
  push @memberDefAofA, [@memberDefA];
  
    $soapResponse = $Pool->create(
    SOAP::Data->name(pool_names => [$sPool]),
    SOAP::Data->name(lb_methods => ["LB_METHOD_ROUND_ROBIN"]),
    SOAP::Data->name(members => [@memberDefAofA])
  );
  &checkResponse($soapResponse);
  
  print "Pool $sPool created successfully\n";
}
else
{
  #------------------------------------------------------------------------
  # Pool supplied, but no member list so error out.
  #------------------------------------------------------------------------
  &usage;
}

#----------------------------------------------------------------------------
# checkResponse makes sure the error isn't a SOAP error
#----------------------------------------------------------------------------
sub checkResponse()
{
  my ($soapResponse) = (@_);
  if ( $soapResponse->fault )
  {
    print $soapResponse->faultcode, " ", $soapResponse->faultstring, "\n";
    exit();
  }
}
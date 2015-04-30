#!/usr/bin/perl
#use SOAP::Lite + trace => qw(method debug);
use SOAP::Lite;

BEGIN { push (@INC, ".."); }

#use iControlTypeCast;

#----------------------------------------------------------------------------
# Validate Arguments
#----------------------------------------------------------------------------
my $sHost = $ARGV[0];
my $sPort = $ARGV[1];
my $sUID = $ARGV[2];
my $sPWD = $ARGV[3];
my $sProtocol = "https";

if ( ("80" eq $sPort) or ("8080" eq $sPort) )
{
	$sProtocol = "http";
}

if ( ($sHost eq "") or ($sPort eq "") or ($sUID eq "") or ($sPWD eq "") )
{
	die ("Usage: ConfigSyncStatus.pl host port uid pwd\n");
}

#----------------------------------------------------------------------------
# Transport Information
#----------------------------------------------------------------------------
sub SOAP::Transport::HTTP::Client::get_basic_credentials-->
{
	return "$sUID" => "$sPWD";
}

$DBVariable = SOAP::Lite
	-> uri('urn<!--:iControl:Management/DBVariable')-->
	-> proxy("$sProtocol://$sHost:$sPort/iControl/iControlPortal.cgi");
eval { $DBVariable->transport->http_request->header
(
	'Authorization' => 
		'Basic ' . MIME::Base64::encode("$sUID:$sPWD", '')-->
); };

&getConfigSyncStatus();

#----------------------------------------------------------------------------
# getDBVariable
#----------------------------------------------------------------------------
sub getDBVariable()
{
	(@dbKeys) = @_;

	$soapResponse = $DBVariable->query
		(
			SOAP::Data->name(variables => [@dbKeys])
		);
	&checkResponse($soapResponse);

	@VariableNameValueList = @{$soapResponse->result};

	my @ValueArray;

	foreach $VariableNameValue (@VariableNameValueList)
	{
		$name = $VariableNameValue->{"name"};
		$value = $VariableNameValue->{"value"};
		push @ValueArray, $value;
	}

	return @ValueArray;
}


#----------------------------------------------------------------------------
# getConfigSyncStatus
#----------------------------------------------------------------------------
sub getConfigSyncStatus()
{
	@dbKeys = (
		"configsync.autodetect",
		"configsync.localconfigtime",
		"configsync.peerconfigtime",
		"configsync.localsyncedtime",
		"configsync.state");
	(@dbValues) = &getDBVariable(@dbKeys);

	print "CONFIG SYNC STATUS --\n";
	if ( "disable" eq @dbValues[0] )
	{
		#Standalone
		print "    Status:  disabled\n";
		print "    Last change (Self):  ", &getLocalTime(@dbValues[1]), "\n";
	}
	else
	{
		#HA Pair
		print "    Status:  @dbValues[4]\n";
		print "    Last change (Self):  ", &getLocalTime(@dbValues[1]), "\n";
		print "    Last change (Peer):  ", &getLocalTime(@dbValues[2]), "\n";
		print "    Last Configsync:  @dbValues[3]\n";
	}
}

#----------------------------------------------------------------------------
# getLocalTime
#----------------------------------------------------------------------------
sub getLocalTime()
{
	($timeNumber) = (@_);
	
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime($timeNumber);
	$timeString = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec);

	return $timeString;
}

#----------------------------------------------------------------------------
# checkResponse
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
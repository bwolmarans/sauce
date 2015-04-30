use REST::Client;
use MIME::Base64;
use JSON;

# define program-wide variables
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

use constant BIGIP_ADDRESS => 'test-ltm-03.element.local';
use constant BIGIP_USER => 'admin';
use constant BIGIP_PASS => 'admin';

use constant SLEEP_TIME => 20;

use constant VS_NAME => 'test-http-virtual_perl';
use constant VS_ADDRESS => '1.1.1.4';
use constant VS_PORT => '80';

use constant POOL_NAME => 'test-http-pool_perl';
use constant POOL_LB_METHOD => 'least-connections-member';
use constant POOL_MEMBERS => qw(10.0.0.1:80 10.0.0.2:80 10.0.0.3:80);

# create/delete subroutines
sub create_pool {
    my ($bigip, $name, $members, $lb_method) = @_;

    # convert member format
    foreach $member(@$members) {$member = {'kind' => 'ltm:pool:members', 'apiName' => $member}};

    # define pool properties
    my %payload;
    $payload{'kind'} = 'tm:ltm:pool:poolstate';
    $payload{'apiName'} = $name;
    $payload{'description'} = 'A Perl REST::Client test pool';
    $payload{'loadBalancingMode'} = $lb_method;
    $payload{'monitor'} = 'http';
    $payload{'members'} = $members;

    my $json = encode_json \%payload;

    $bigip->POST('ltm/pool', $json);
}

sub create_http_virtual_server {
    my ($bigip, $name, $address, $port, $pool) = @_;

    # define virtual properties
    my %payload;
    $payload{'kind'} = 'tm:ltm:virtual:virtualstate';
    $payload{'apiName'} = $name;
    $payload{'description'} = 'A Perl REST::Client test virtual server';
    $payload{'destination'} = $address . ':' . $port;
    $payload{'mask'} = '255.255.255.255';
    $payload{'ipProtocol'} = 'tcp';
    $payload{'sourceAddressTranslation'} = { 'type' => 'automap' };
    $payload{'profiles'} = [
        { 'kind' => 'ltm:virtual:profile', 'apiName' => 'http' },
        { 'kind' => 'ltm:virtual:profile', 'apiName' => 'tcp' }
    ];
    $payload{'pool'} = $pool;

    my $json = encode_json \%payload;

    $bigip->POST('ltm/virtual', $json);
}

sub delete_pool {
    my ($bigip, $name) = @_;

    $bigip->DELETE('ltm/pool/' . $name);
}

sub delete_virtual {
    my ($bigip, $name) = @_;

    $bigip->DELETE('ltm/virtual/' . $name);
}

# REST resource for BIG-IP that all other requests will use
my $bigip = REST::Client->new();
$bigip->addHeader('Content-Type', 'application/json');
$bigip->addHeader('Authorization', 'Basic ' . encode_base64(BIGIP_USER . ':' . BIGIP_PASS));
$bigip->setHost('https://' . BIGIP_ADDRESS . '/mgmt/tm');
print "created REST resource for BIG-IP at" . BIGIP_ADDRESS . "...\n";

# create pool
&create_pool($bigip, POOL_NAME, [POOL_MEMBERS], POOL_LB_METHOD);
print "created pool \"" . POOL_NAME . "\" with members " . join(", ", POOL_MEMBERS) . "...\n";

# create virtual
&create_http_virtual_server($bigip, VS_NAME, VS_ADDRESS, VS_PORT, POOL_NAME);
print "created virtual server \"" . VS_NAME . "\" with destination " . VS_ADDRESS . ":" . VS_PORT . "...\n";

# sleep for a little while
print "sleeping for " . SLEEP_TIME . " seconds, check for successful creation...\n";
sleep(SLEEP_TIME);

# delete virtual
&delete_virtual($bigip, VS_NAME);
print "deleted virtual server \"" . VS_NAME . "\"...\n";

# delete pool
&delete_pool($bigip, POOL_NAME);
print "deleted pool \"" . POOL_NAME . "\"...\n";
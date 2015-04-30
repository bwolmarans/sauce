# create virtual
create_http_virtual(bigip, VS_NAME, VS_ADDRESS, VS_PORT, POOL_NAME)
print "created virtual server \"%s\" with destination %s:%s..." % (VS_NAME, VS_ADDRESS, VS_PORT)
 
 
def create_http_virtual(bigip, name, address, port, pool):
    payload = {}
 
    # define test virtual
     payload['kind'] = 'tm:ltm:virtual:virtualstate'
     payload['name'] = name
     payload['description'] = 'A Python REST client test virtual server'
     payload['destination'] = '%s:%s' % (address, port)
     payload['mask'] = '255.255.255.255'
     payload['ipProtocol'] = 'tcp'
     payload['sourceAddressTranslation'] = { 'type' : 'automap' }
     payload['profiles'] = [ 
         { 'kind' : 'ltm:virtual:profile', 'name' : 'http' }, 
         { 'kind' : 'ltm:virtual:profile', 'name' : 'tcp' }
     ]
     payload['pool'] = pool
  
     bigip.post('%s/ltm/virtual' % BIGIP_URL_BASE, data=json.dumps(payload))
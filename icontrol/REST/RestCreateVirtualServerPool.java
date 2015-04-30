import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.json.simple.JSONObject;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.client.filter.HTTPBasicAuthFilter;
import com.sun.jersey.client.urlconnection.HTTPSProperties;

public class RestCreateVirtualServerPool {
	// define program-wide variables
	private static final String BIGIP_ADDRESS = "test-ltm-03.element.local";
	private static final String BIGIP_USER = "admin";
	private static final String BIGIP_PASS = "admin";
	
	private static final int SLEEP_TIME = 20;
	
	private static final String VS_NAME = "test-http-virtual_java";
	private static final String VS_ADDRESS = "1.1.1.2";
	private static final int VS_PORT = 80;
	
	private static final String POOL_NAME = "test-http-pool_java";
	private static final String POOL_LB_METHOD = "least-connections-member";
	private static final String[] POOL_MEMBERS = new String[] { "10.0.0.1:80", "10.0.0.2:80", "10.0.0.3:80" };
	
	public static void main(String[] args) {	
		// REST resource for BIG-IP that all other requests will use
		ClientConfig config = configureClient();
		Client client = Client.create(config);
		
		// add HTTP basic auth credentials
		client.addFilter(new HTTPBasicAuthFilter(BIGIP_USER, BIGIP_PASS));
		
		// define REST interface URL and content type
		WebResource bigip = client.resource("https://" + BIGIP_ADDRESS + "/mgmt/tm/");
		System.out.println("created REST resource for BIG-IP at " + BIGIP_ADDRESS + "...");

		// create pool
		createPool(bigip, POOL_NAME, POOL_MEMBERS, POOL_LB_METHOD);
		System.out.println("created pool \"" + POOL_NAME + "\" with " + POOL_MEMBERS.length + " members...");

		// create virtual
		createHTTPVirtual(bigip, VS_NAME, VS_ADDRESS, VS_PORT, POOL_NAME);
		System.out.println("created virtual server \"" + VS_NAME + "\" with destination " + VS_ADDRESS + ":" + VS_PORT + "...");
		
		// sleep for a little while
		System.out.println("sleeping for " + SLEEP_TIME + " seconds, check for successful creation...");
		try {
			Thread.sleep(SLEEP_TIME * 1000);
		} catch (InterruptedException e) {
			System.out.println("Execution interrupted. Exiting...");
		}
		
		// delete virtual
		deleteVirtual(bigip, VS_NAME);
		System.out.println("deleted virtual server \"" + VS_NAME + "\"...");

		// delete pool
		deletePool(bigip, POOL_NAME);
		System.out.println("deleted pool \"" + POOL_NAME + "\"...");
	}
	
	// create/delete methods	
	@SuppressWarnings("unchecked")
	private static void createPool (WebResource bigip, String name, String[] members, String lbMethod) {
		JSONObject payload = new JSONObject();
		
		// convert member format
		LinkedList<HashMap<String, String>> payloadMembers = new LinkedList<HashMap<String, String>>(); 
		
		for(String member : members){
			HashMap<String,String> payloadMember = new HashMap<String,String>();
			payloadMember.put("apiName", member);
			payloadMember.put("kind", "ltm:pool:members");
			payloadMembers.add(payloadMember);
		}
		
		// define pool properties
		payload.put("apiName", name);
		payload.put("kind", "tm:ltm:pool:poolstate");
		payload.put("description", "A Ruby rest-client test pool");
		payload.put("loadBalancingMode", lbMethod);
		payload.put("monitor", "http");
		payload.put("members", payloadMembers);

		bigip.path("ltm/pool").type("application/json").post(payload.toString());
	}
	
	@SuppressWarnings("unchecked")
	private static void createHTTPVirtual (WebResource bigip, String name, String address, int port, String pool) {
		JSONObject payload = new JSONObject();
		
		// create correct structure for SNAT automap
		Map<String, String> snat = new HashMap<String, String>();
		snat.put("type", "automap");

		// define profiles
		LinkedList<HashMap<String, String>> profiles = new LinkedList<HashMap<String, String>>();
		
		HashMap<String, String> httpProfile = new HashMap<String, String>();
		httpProfile.put("kind", "ltm:virtual:profile");
		httpProfile.put("apiName", "http");
		
		HashMap<String, String> tcpProfile = new HashMap<String, String>();
		tcpProfile.put("kind", "ltm:virtual:profile");
		tcpProfile.put("apiName", "tcp");
		
		profiles.add(httpProfile);
		profiles.add(tcpProfile);
		
		// define virtual properties
		payload.put("kind", "tm:ltm:virtual:virtualstate");
		payload.put("apiName", name);
		payload.put("description", "A Java REST client test virtual server");
		payload.put("destination", address + ":" + port);
		payload.put("mask", "255.255.255.255");
		payload.put("ipProtocol", "tcp");
		payload.put("sourceAddressTranslation", snat);
		payload.put("pool", pool);
		
		bigip.path("ltm/virtual").type("application/json").post(payload.toString());
	}
	
	private static void deletePool (WebResource bigip, String name) {
		bigip.path("ltm/pool/" + name).type("application/json").delete();
	}
	
	private static void deleteVirtual (WebResource bigip, String name) {
		bigip.path("ltm/virtual/" + name).type("application/json").delete();
	}
	
	// configure parameters for Jersey REST client	
	private static ClientConfig configureClient() {
		TrustManager[] certs = new TrustManager[] {
            new X509TrustManager() {
				@Override
				public X509Certificate[] getAcceptedIssuers() {
					return null;
				}
				@Override
				public void checkServerTrusted(X509Certificate[] chain, String authType)
						throws CertificateException {
				}
				@Override
				public void checkClientTrusted(X509Certificate[] chain, String authType)
						throws CertificateException {
				}
			}
	    };
		
	    SSLContext ctx = null;
	    
	    try {
	        ctx = SSLContext.getInstance("TLS");
	        ctx.init(null, certs, new SecureRandom());
	    } catch (java.security.GeneralSecurityException ex) {
	    	// do nothing
	    }
	    
	    HttpsURLConnection.setDefaultSSLSocketFactory(ctx.getSocketFactory());
	    
	    ClientConfig config = new DefaultClientConfig();
	    
	    try {
		    config.getProperties().put(HTTPSProperties.PROPERTY_HTTPS_PROPERTIES, new HTTPSProperties(
		        new HostnameVerifier() {
					@Override
					public boolean verify(String hostname, SSLSession session) {
						return true;
					}
		        },
		        ctx
		    ));
	    } catch(Exception e) {
	    	// do nothing
	    }
	    
	    return config;
	}
}
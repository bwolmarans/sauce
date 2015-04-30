import javax.crypto.*;
import java.security.*;
import javax.crypto.spec.SecretKeySpec;
/* for user brett key nUVNRhKUEBLlbvFLW7+xSJ5kINXmdzzL8/iToS5A */

class blah {
	public static void main(String[] arguments) throws Exception {
		System.out.println("Let's do something using Java technology.");
		byte[] kSigning = getSignatureKey("nUVNRhKUEBLlbvFLW7+xSJ5kINXmdzzL8/iToS5A","20150429","us-east-1","doobydoobydoo");
		System.out.println(kSigning);

	}

	static byte[] HmacSHA256(String data, byte[] key) throws Exception  {
		 String algorithm="HmacSHA256";
		 Mac mac = Mac.getInstance(algorithm);
		 mac.init(new SecretKeySpec(key, algorithm));
		 return mac.doFinal(data.getBytes("UTF8"));
	}

	static byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception  {
		 byte[] kSecret = ("AWS4" + key).getBytes("UTF8");
		 byte[] kDate    = HmacSHA256(dateStamp, kSecret);
		 byte[] kRegion  = HmacSHA256(regionName, kDate);
		 byte[] kService = HmacSHA256(serviceName, kRegion);
		 byte[] kSigning = HmacSHA256("aws4_request", kService);
		 return kSigning;
	}

}


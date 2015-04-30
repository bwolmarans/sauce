import java.security.*;
import javax.crypto.*;
/**
 * Calculate the HMAC of the blob using the specified NTLMv2 hash and challenge
 * @param challenge byte[]
 * @param v2hash byte[]
 * @return byte[]
 * @exception Exception
 */
public final byte[] calculateHMAC(byte[] challenge,byte[] v2hash) throws Exception {
  byte[] blob=new byte[(m_len - HMAC_LEN) + CHALLENGE_LEN];
  System.arraycopy(challenge,0,blob,0,CHALLENGE_LEN);
  System.arraycopy(m_blob,m_offset + OFFSET_HEADER,blob,CHALLENGE_LEN,m_len - HMAC_LEN);
  Mac hmacMd5=Mac.getInstance("HMACMD5");
  SecretKeySpec blobKey=new SecretKeySpec(v2hash,0,v2hash.length,"MD5");
  hmacMd5.init(blobKey);
  return hmacMd5.doFinal(blob);
}
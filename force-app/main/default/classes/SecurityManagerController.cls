/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-09-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

// HAMC이란? 암호화 해시 함수와 비밀 키를 결합하여 메시지 인증 코드를 생성하는 보안 알고리즘(Hash-based Message Authentication Code)
// MD5란? 암호화 해시 함수의 하나로 , 입력된 데이터를 고정된 길이의 해시 값으로 변환하는 알고리즘(Message-Digest Algorithm 5)
// HMAC-SHA256 알고리즘과 MD5 해싱을 활용하여 요청 데이터를 암호화하고 인증 서명을 생성하는 데 사용
public with sharing class SecurityManagerController {
    public static final String MACENCRIPTION = 'HmacSHA256';
	public static final String MD5 = 'MD5';

    // HMAC 키를 생성하는 메인함수
    /*  
        messagePayload: 요청의 본문 데이터, 
        content_type: 데이터의 콘텐츠 타입, 
        resquestType: HTTP 요청 타입, 
        endpoint: 요청의 엔드포인트 URL, 
        secretKey: HMAC 서명에 사용하는 비밀 키,
        principal: 인증을 위해 함께 반환되는 식별자 
    */
	public String generateHMACKey(String messagePayload,String content_type,String requestType,String endpoint,String secretKey,String principal){
		String salt				= generateSalt();
		String timestamp		= generateTimeStamp(Datetime.now());
		String contentMd5		= generateMD5Digest(messagePayload);
		String contentType		= content_type;
		String signatureData	= generateSignature(requestType,contentMD5,contentType,salt,timestamp,endpoint);
		Blob data				= crypto.generateMac(MACENCRIPTION, Blob.valueOf(signatureData), Blob.valueOf(secretKey));  // HMAC-SHA256을 사용해 서명 생성
		String signature		= EncodingUtil.base64Encode(data);  // Base64로 인코딩된 서명과 추가정보를 반환
		return principal+':'+ signature + ':' + salt + ':' + timestamp;
	}

	// 난수 생성
	private String generateSalt(){
		return String.valueOf(Crypto.getRandomInteger());
	}

    // 현재 시간의 타임스탬프를 생성
	private String generateTimeStamp(Datetime datetimeValue){
		return string.valueof(datetimeValue.getTime() / 1000);
	}

    // 입력된 메시지(messagePayload)의 다이제스트를 생성하여 메시지 무결성 확인
    private String generateMD5Digest(String messagePayload){
		return EncodingUtil.convertToHex(Crypto.generateDigest(MD5, Blob.valueOf(messagePayload)));
	}

    // 요청 데이터를 조합하여 서명 데이터 생성
	private String generateSignature(String requestType,String contentMD5,String contentType,String salt,String timestamp,String endpoint){
		return String.valueof(''+requestType+'\n' + contentMD5 + '\n' + contentType + '\n' + salt + '\n' + timestamp + '\n' + endpoint);
	}
}
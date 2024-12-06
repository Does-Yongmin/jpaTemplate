package com.does.util.http.feign.request;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MessageRequest {

    /**
     * 롯데 카카오 알림톡 발송 API 요청 클래스
     *
     * URI : /sendMessage
     * METHOD : POST
     */

    private String key;             // (필수) API KEY
    private MsgType msgType;        // (필수) 전송 타입 [SMS, LMS, MMS, KKO(카카오톡)]
    private String destPhone;       // (필수) 수신번호 - 발신은 물산 0232135000 고정, 허가되지 않은 번호로 발신 불가
    private String msgBody;         // (필수) 전송할 내용 - KKO의 경우 템플릿 코드에 등록된 양식과 일치해야 함.
    private String templateCode;    // (KKO 인 경우 필수) L.Message 에 등록된 알림톡 템플릿
    private String reBody;          // (KKO 인 경우 필수) 알림톡 발송 실패시 대체할 내용 - 여기 내용이 문자로 날아감

    public enum MsgType{
        SMS, LMS, MMS, KKO
    }

    ///////////////////////////////////////////////////////////////

    /**
     * 메세지 발송 관련 (request json 직렬화시에는 포함되지 않도록 json ignore 처리)
     */


    /**
     *카카오 알림톡 발송 템플릿 메세지 (줄바꿈은 \r\n 으로 처리)
     *
     * 발송하는 메세지 내용은 카카오 알림톡 템플릿에 등록된 것과 동일한 양식이여야 하기 때문에, 변경 금지
     */
    @JsonIgnore public static String MSG_TEMPLATE_ADMIN_AUTH = "[롯데물산 STS]\r\n임시비밀번호(인증번호) 입니다.\r\n{0}";
    @JsonIgnore public static String MSG_TEMPLATE_C_AUTH   = "[롯데물산]\r\n인증번호 입니다.\r\n{0}";
    @JsonIgnore public static String MSG_TEMPLATE_ADMIN_APPROVAL = "[LWT 관리자페이지]\r\n가입하신 계정의 회원 승인이 완료되었습니다.\r\nID: {0}";


    /**
     * 롯데물산 STS 임시비밀번호 or 인증번호 텔플릿 코드
     *
     * [롯데물산 STS]
     * 임시비밀번호(인증번호)입니다.
     * #{tmp_pwd}
     */
    @JsonIgnore public static final String KKO_TEMPLATE_CODE_STS    = "LMSG_20190725111805193474";

    /**
     * 고객의 소리, 비즈문의 인증번호 템플릿 코드
     *
     * [롯데물산]
     * 인증번호입니다.
     * #{인증번호}
     */
    @JsonIgnore private static final String KKO_TEMPLATE_CODE_C    = "LMSG_20210105112245223808";

    /**
     * 관리자 승인시 발송되는 템플릿 코드
     *
     * [LWT 관리자페이지]
     * 가입하신 계정의 회원 승인이 완료되었습니다.
     * ID: #{id}
     */
    @JsonIgnore public static final String KKO_TEMPLATE_CODE_ADMIN_APPROVAL = "LMSG_20241023171609797837";
}

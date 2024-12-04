package com.does.biz.domain.facility;

import com.does.biz.domain.core.Base;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacilityVO {

	private String affiliateFloor;					// 중복 선택 가능. 콤마로 구분 (예: "B1F,1F,2F")
	private String codeType;						// 중복 선택 가능. 콤마로 구분 (예: "L001M001,L001M002")
	private String poiId;							// 중복 선택 가능. 콤마로 구분
	
//	private FacilityLangInfoVO facilityLangInfoKo = FacilityLangInfoVO.builder().lang("KO").build();
//	private FacilityLangInfoVO facilityLangInfoEn = FacilityLangInfoVO.builder().lang("EN").build();
//	private FacilityLangInfoVO facilityLangInfoJp = FacilityLangInfoVO.builder().lang("JP").build();
//	private FacilityLangInfoVO facilityLangInfoCn = FacilityLangInfoVO.builder().lang("CN").build();
	
	private String phoneNumber;						// 대표전화. 콤마로 구분 (예: "02-1234-5678,032-1234-5678,1544-1818")
	private String pageUrl;							// 매장 및 시설 홈페이지 URL
	
	private Integer orderNum;                		// 정렬 순서. 작을수록 위에 노출
	private String approveYn;						// 매장 승인 여부 (Y/N)
	
	private	Date approveDate;						// 매장 승인일
	private	String approver;						// 승인자 계정아이디
	private	String approverIp;						// 승인자 접속 IP

}

package com.does.biz.domain.core;

import com.does.crypt.SHA256;
import com.does.crypt.SeedCBC;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@MappedSuperclass
@Getter
@Slf4j
public abstract class Base {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "SEQ")
	protected Long seq;
	
	@Column(name = "USE_YN")
	protected String useYn;
	
	@Column(name = "CREATE_DATE")
	protected Date createDate;
	
	@Column(name = "CREATEOR")
	protected String creator;
	
	@Column(name = "CREATEOR_IP")
	protected String creatorIp;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// @Setter 는 꼭 필요한 경우에만 추가
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	@Setter
	@Column(name = "UPDATE_DATE")
	protected Date updateDate;
	
	@Setter
	@Column(name = "UPDATER")
	protected String updater;
	
	@Setter
	@Column(name = "UPDATER_IP")
	protected String updaterIp;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 아래는 필요한 메소드
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private static final boolean has(MultipartFile o)	{	return o != null && !o.isEmpty();	}
	private static final boolean has(String o)			{	return o != null && !o.trim().isEmpty();	}
	private static final boolean has(List o)			{	return o != null && !o.isEmpty() && o.stream().anyMatch(Objects::nonNull);	}
	private static final boolean has(Map o)				{	return o != null && !o.isEmpty();	}
	private static final boolean has(Object[] o)		{	return o != null && o.length > 0;	}
	protected static final boolean has(Object o) {
		if (o instanceof MultipartFile)	return has((MultipartFile) o);
		if (o instanceof String)		return has((String) o);
		if (o instanceof List)			return has((List) o);
		if (o instanceof Map)			return has((Map) o);
		if (o instanceof Object[])		return has((Object[]) o);
		
		return o != null;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	protected static final SimpleDateFormat SDF_ymdhms	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	protected static final SimpleDateFormat SDF_ymd		= new SimpleDateFormat("yyyy-MM-dd");
	protected static final SimpleDateFormat SDF_hms		= new SimpleDateFormat("HH:mm:ss");
	
	public static final String ymdhms(Date date)	{	return date == null ? "" : SDF_ymdhms.format(date);	}
	public static final String ymd(Date date)		{	return date == null ? "" : SDF_ymd.format(date);	}
	public static final String hms(Date date)		{	return date == null ? "" : SDF_hms.format(date);	}
	
	protected static final boolean isY(String src)		{	return "Y".equalsIgnoreCase(src);	}
	protected static final String setYn(String src)		{	return isY(src) ? "Y" : "N";	}
	protected static final String setYn(boolean isY)	{	return isY ? "Y" : "N";	}
	
	public void setUseYn(String useYn)	{	this.useYn = setYn(useYn);	}
	public void setUseYn(boolean useYn)	{	this.useYn = setYn(useYn);	}
	
	public String getCreateDatePretty()	{	return ymdhms(createDate);	}
	public String getUpdateDatePretty()	{	return ymdhms(updateDate);	}
	public String getDatePretty(Date d)	{	return ymdhms(d);	}
	
	public boolean isNew()	{	return !has(seq);	}
	public boolean isUse()	{	return isY(useYn);	}
	
	public String getCreatorMasked() {
		return maskSecondIndexChars(creator);
	}
	public String getUpdaterMasked() {
		return maskSecondIndexChars(updater);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public static String getDateTextMonthPretty(String inputDateString) {
		try {
			return getDateFromDateTime(inputDateString);
		} catch (DateTimeParseException e) {
			try {
				return getDateFromDate(inputDateString);
			} catch (DateTimeParseException ex) {
				// 파싱 실패 시 입력 문자열 그대로 반환
				return inputDateString;
			}
		}
	}
	
	/**
	 * '2024-01-05 12:00:00' 형태를 'January 5, 2024' 로 변환하는 함수
	 * */
	public static String getDateFromDateTime(String inputDateTimeString) {
		LocalDateTime dateTime = LocalDateTime.parse(inputDateTimeString, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		return dateTime.format(DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH));
	}
	
	/**
	 * '2024-01-05' 형태를 'January 5, 2024' 로 변환하는 함수
	 * */
	public static String getDateFromDate(String inputDateString) {
		LocalDate date = LocalDate.parse(inputDateString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		return date.format(DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH));
	}
	
	public static String convertFromStringToURL(String rawString) {
		return convertFromStringToURL(rawString, null);
	}
	
	public static String convertFromStringToURL(String rawString, String baseExcludeChars) {
		if (baseExcludeChars == null) {
			baseExcludeChars = "['\"`’,“”.™?()]";					// 제외할 문자를 여기에 추가
		}
		
		String encodedString = rawString == null ? "" : rawString;
		String decodedString = StringEscapeUtils.unescapeHtml4(encodedString);
		
		return decodedString
			.replaceAll(baseExcludeChars, "")    			// 예외 문자 삭제
			.replaceAll("[^a-zA-Z0-9\\s-]", "-")   	// 영문 숫자를 제외한 나머지 특수문자는 하이픈으로 치환
			.replaceAll("\\s", "-")                	// 공백 문자를 하이픈으로 치환
			.replaceAll("-{2,}", "-")           	// 하이픈이 연속적으로 2개 이상 인접해 있으면 1개로 치환
			.replaceAll("^-", "")              		// 처음에 하이픈이 있으면 제거
			.replaceAll("-$", "")              		// 마지막에 하이픈이 있으면 제거
			.toLowerCase();
	}
	
	public static String maskSecondIndexChars(String rawString) {
		StringBuilder result = new StringBuilder();
		
		for (int i = 0; i < rawString.length(); i++) {
			if (i == 1) {
				result.append('*');
			} else {
				result.append(rawString.charAt(i));
			}
		}
		
		return result.toString();
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	protected static final String decrypt(String enc) {
		String dec = enc == null ? "" : enc;
		try {
			dec = SeedCBC.decrypt(dec);
		} catch (ArrayIndexOutOfBoundsException e) {
			log.debug("암호화 되어 있지 않은 문자열로 복호화 실패 : {}", e.getMessage());
		} catch (Exception e) {
			/*
			    비밀번호 해싱을 제외하고는 모든 데이터 암호화 하지 않는 것으로 수정함
			    그러나 기존에 쌓인 개발 DB 데이터를 운영 DB 로 이관했기 때문에, 암호화된 항목(이름, 전화번호, 이메일)들이 존재하여
			    해당 데이터들은 복호화 할 수 있도록 로직을 유지함

				암호화 되지 않은 데이터를 복호화 하려고 할때 이 부분 로그가 찍힘. 그래서 debug 로 로깅 레벨 조절함
			 */
			log.debug("복호화중 에러 발생 : {}", e.getMessage());
		}
		return dec;
	}
	
	protected static final String encrypt(String src) {
		return SeedCBC.encrypt(decrypt(src), false);
	}
	
	/**
	 * SHA 알고리즘으로 해싱한 값을 반환한다.
	 */
	protected static final String hashing(String src) {
		return SHA256.encrypt(src);
	}
}
package com.does.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class DateUtil {
	
	public static String getDate(String inputDateString) {
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

	/**
	 * 주어진 두 날짜의 차이 일 수를 계산하여 반환한다.
	 * @param date1
	 * @param date2
	 * @return
	 */
	public static long calculateDaysGap(Date date1, Date date2){
		long diffInMillies = Math.abs(date1.getTime() - date2.getTime());
		long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

		return diffInDays;
	}
}

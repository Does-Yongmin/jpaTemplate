<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.does.util.StrUtil" %>
<%!
	public static String imgAccept() {
		String[] arr = { " .jpg", " .gif", " .png" };
		return String.join(",", arr);
	}
	public static String movAccept() {
		String[] arr = { " .mp4", " .mov" };
		return String.join(",", arr);
	}
	public static String mediaAccept() {
		String[] arr = { " .mp3" };
		return String.join(",", arr);
	}
	public static String docAccept() {
		String[] arr = { " .ppt", " .pptx", " .doc", " .docx", " .xsl", " .xlsx", " .hwp", " .hwpx", " .pdf", " .zip" };
		return String.join(",", arr);
	}

	public static String image(int w, int h) {
		return String.format("이미지 파일 권장 사이즈는 <span class='red'>%dpx * %dpx</span> 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w, h);
	}
	public static String imageRecommend(int w, int h, String msg) {
		return String.format("이미지 파일 권장 사이즈는 <span class='red'>%dpx * %dpx (%s)</span> 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w, h, msg);
	}
	public static String imageCntLimit(int w, int h, int cnt) {
		return String.format("이미지 파일 권장 사이즈는 <span class='red'>%dpx * %dpx</span> 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 <span class='red'>최대 %d개</span> 등록이 가능합니다.", w, h, cnt);
	}
	public static String imageWidthHeight(int w1, int h1, int w2, int h2) {
		return String.format("이미지 파일 권장 사이즈는 가로 <span class='red'>%dpx * %dpx</span>, 세로 <span class='red'>%dpx * %dpx</span> 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w1, h1, w2, h2);
	}
	public static String image(int w, int h1, int h2) {
		return String.format("이미지 파일 권장 사이즈는 <span class='red'>%dpx * (%d ~ %d)px</span> 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w, h1, h2);
	}
	public static String image(int w1, int h1, int w2, int h2) {
		return String.format("이미지 파일 사이즈는 <span class='red'>%dpx * %dpx</span> (권장 사이즈 <span class='red'>%dpx * %dpx</span>) 이고, <strong>"+imgAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w1, h1, w2, h2);
	}
	public static String imageDynamic(String name, String standard, String pair) {
		return String.format("%s%s <span class='red'>%s</span> 기준으로 %s%s 동적으로 변경되며, <strong>%s</strong> 파일에 한해 등록이 가능합니다.", name, StrUtil.getJosaIsOf(name), standard, pair, StrUtil.getJosaGaOf(pair), imgAccept());
	}

	public static String video(int w, int h) {
		return String.format("영상 파일 권장 사이즈는 <span class='red'>%dpx * %dpx</span> 이고, <strong>"+movAccept()+"</strong> 파일에 한해 등록이 가능합니다.", w, h);
	}

	public static String fileOptionalLimitKB(int s) {
		return String.format("파일 권장 용량은 <span class='red'>%dKB</span> 입니다.", s);
	}
	public static String fileLimitKB(int s) {
		return String.format("파일 용량은 <span class='red'>%dKB</span> 까지 등록이 가능합니다.", s);
	}
	public static String fileLimit(int s) {
		return String.format("파일 용량은 <span class='red'>%dMB</span> 까지 등록이 가능합니다.", s);
	}
	public static String fileLimit(String name1, int s1, String name2, int s2) {
		return String.format("파일 용량은 %s <span class='red'>%dMB</span>, %s <span class='red'>%dMB</span> 까지 등록이 가능합니다.", name1, s1, name2, s2);
	}

	public static String inputLimit(String name, int length) {
		return String.format("%s%s 최대 <span class='red'>%d자 이내</span>로 입력해주시기 바랍니다.", name, StrUtil.getJosaIsOf(name), length);
	}
	public static String inputLimit(String name, int length, int line) {
		return String.format("%s%s <span class='red'>한 줄에 최대 %d자, %d줄 이내</span>로 입력해주시기 바랍니다.", name, StrUtil.getJosaIsOf(name), length, line);
	}

	public static String attach(String type) {
		return String.format("<strong>%s</strong> 파일에 한해 등록이 가능합니다.", type);
	}
%>
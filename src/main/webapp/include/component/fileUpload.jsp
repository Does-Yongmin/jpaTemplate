<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="com.does.component.AttachPathResolver" %>
<%@ include file="/include/taglib.jsp" %>
<%--
	용도 : 상세페이지에서 첨부파일을 업로드해야 할 때 사용.

	설명 : Model 로 넘어온 file 용 객체를 ${data.fileP} 로 받아 'attach' 라는 별칭으로 사용한다.
		   t_required	: 이 첨부파일이 필수값인지 여부.
		   t_ment		: 이 첨부파일의 권장사이즈나 용량 등에 대한 가이드 문구.
		   				  여러개를 쓸 경우 배열로 처리됨.
		   t_fileName	: data 객체 내에서 첨부파일 변수의 이름. 예시에서는 AttachVO fileP; 와 같이 선언됨.
		   t_tag		: 이 파일을 저장할 때 함께 저장할 태그 정보. ex) PC, MOBILE, THUMB 등.
		   t_accept		: 이 파일의 타입 정보.

	사용 : 상세페이지에서 첨부파일 업로드 기능이 들어갈 부분에 아래 코드를 상황에 맞게 추가.

	<c:set var="attach" value="${data.fileP}" scope="request"/>
	<jsp:include page="/include/uploadForm.jsp">
		<jsp:param name="t_required"	value="true"/>
		<jsp:param name="t_ment"		value="<%=image(3840, 2160)%>"/>
		<jsp:param name="t_ment"		value="<%=fileLimit(2)%>"/>
		<jsp:param name="t_fileName"	value="fileP"/>
		<jsp:param name="t_tag"			value="PC"/>
		<jsp:param name="t_accept"		value="<%=imgAccept()%>"/>
	</jsp:include>
--%>
<%!
	private static String _printTag(String name, String tag) {
		return tag != null ? String.format("<input type='hidden'	name='%s.tag'	value='%s'>", name, tag) : "";
	}

	private static String _printMent(HttpServletRequest request, String key) {
		String[] ment = request.getParameterValues(key);
		return Arrays.stream(ment).filter(s -> s != null && !s.isEmpty()).map(s -> String.format("<div class='ment'>%s</div>", s)).collect(Collectors.joining());
	}
%>
<%
	String __serverName = request.getServerName();
	int __serverPort = request.getServerPort();
	String __serverNameAndPort = __serverName + (__serverPort == 80 ? "" : ":" + __serverPort);
	String __referer = request.getHeader("referer");

/*	if (__referer == null || !__serverNameAndPort.equals(__referer.replaceAll("^https?://([^/]+).*$", "$1"))) {
		return;
	}*/

	String name = request.getParameter("t_fileName");
	String tag = request.getParameter("t_tag");
	String accept = request.getParameter("t_accept");
	boolean required = "true".equals(request.getParameter("t_required"));
	request.setAttribute("required", required);

	request.setAttribute("name", name);
	request.setAttribute("accept", accept);

	out.clearBuffer();
%>

<c:set var="name" value="${fn:escapeXml(name)}" />
<c:set var="accept" value="${fn:escapeXml(accept)}" />

<div>
	<%=_printMent(request, "t_ment")%>
	<div class="file_input_div">
		<%=_printTag(name, tag)%>
		<input type="hidden" name="<c:out value="${name}"/>.fileId" value="${fn:escapeXml(attach.fileId)}">
		<input type="file" name="<c:out value="${name}"/>.file" accept="<c:out value="${accept}"/>">
		<c:if test="${not empty attach.fileId}">
			<div class="uploaded">
				<a href="<c:out value="${AttachPathResolver.getOrgUri(attach)}"/>" data-type="${fn:escapeXml(attach.fileType)}" download="<c:out value="${attach.orgName}"/>" target="blank"><c:out value="${attach.orgName}"/></a>
				<c:if test="${required eq false}">
				<a href="javascript:deleteFile('${fn:escapeXml(attach.fileId)}');" class="delFile mot3">ⓧ</a>
				</c:if>
			</div>
		</c:if>
	</div>
</div>
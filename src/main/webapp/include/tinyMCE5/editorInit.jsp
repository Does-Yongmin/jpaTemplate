<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
	'editor' 클래스가 있는 요소에 TinyMCE5 에디터를 적용
--%>

<spring:eval expression="@environment.getProperty('editor.min.js')" var="tinymce"/>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/<c:out value="${tinymce}"/>" referrerpolicy="origin"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/editor.js"></script>
<script>
	$.tinymce5(".editor", {
		uploadUri	: "<c:out value="${cPath}"/>/editor/upload",
		contentCss	: "<c:out value="${cPath}"/>/assets/tinyMCE5/boilerplate.css"
	});
</script>
<%-- 이 아래 리소스들은 인터넷이 되는 환경에서는 필요없음. --%>
<link rel="stylesheet" type="text/css" 		href="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/content.min.css"/>
<link rel="stylesheet" type="text/css" 		href="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/skin.min.css"/>

<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/theme.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/icons.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/list.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/advlist.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/link.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/autolink.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/image.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/media.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/code.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/table.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/searchreplace.min.js"></script>
<script charset="utf-8" 					src="<c:out value="${cPath}"/>/assets/tinyMCE5/assets/plugins/wordcount.min.js"></script>
<%-- 이 위에 리소스들은 인터넷이 되는 환경에서는 필요없음. --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>

<input type="text" name="searchText" value="<c:out value="${search.searchText}" escapeXml="false"/>" autocomplete="off" placeholder="<c:out value="${param.searchText}" escapeXml="false"/>"/>

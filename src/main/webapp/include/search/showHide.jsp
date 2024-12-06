<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<label><input type="radio" name="searchShow" value=""  checked> 전체</label>
<label><input type="radio" name="searchShow" value="Y" ${search.searchShowYn eq 'Y' ? 'checked' : ''}> 게시</label>
<label><input type="radio" name="searchShow" value="N" ${search.searchShowYn eq 'N' ? 'checked' : ''}> 비게시</label>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style></style>
</head>
<body>
<h3>신고 처리</h3>
</hr>
<div>
	작성자 아이디 ${reportInfo.userId} 신고 대상자 ${reportInfo.reportUserId}
	<select name="searchCategory" id="searchCategory">
		 <option value="defalut">이용제한선택</option>
         <option value="">경고</option>
         <option value="">영구제한</option>
      </select>
</div>
<div>
	<h4>신고 내용</h4>
	</br>
	${reportInfo.reportContent}
</div>
<div>
	<h4>신고 처리</h4>
</div>

</body>
<script></script>
</html>
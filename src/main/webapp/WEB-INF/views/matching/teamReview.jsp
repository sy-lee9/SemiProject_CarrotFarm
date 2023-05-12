<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style>
</style>
</head>
<body>
	<h2>당근농장 리뷰</h2>
	<form action="teamReview.do" method="post" id="form">
		<input type="text" name="matchingIdx" value="${matchingIdx}" hidden />
		<input type="text" name="teamId" value="${teamIdx}" hidden />
		${myTeamName}의 팀장님 	${yourTeamName} 팀에게 어울리는 리뷰를 골라 주세요
		
		<c:forEach items="${tagList}" var="tagList">
			<br/>
			<input type="checkbox" name="${tagList.tagIdx}" value="${tagList.tagContent}"/>${tagList.tagContent}
		</c:forEach>
		<button>제출</button>
	</form>

</body>
<script>

</script>
</html>
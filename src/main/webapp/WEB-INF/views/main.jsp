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

	<button onclick="location.href='adminUser'">어드민 유저</button>
	<button onclick="location.href='adminTeam'">어드민 팀</button>
	<button onclick="location.href='adminTag'">어드민 태그</button>
	<button onclick="location.href='adminCategory'">어드민 카테고리</button>
	<button onclick="location.href='adminReport'">어드민 신고</button>
	
	<c:set var="loginId" value="${sessionScope.loginId}" />
	<c:if test="${loginId != null}">
		<button onclick="location.href='logout'">로그아웃</button>
	</c:if>
	<c:if test="${loginId == null}">
		<button onclick="location.href='login.go'">로그인</button>
	</c:if>
	
	<button onclick="location.href='userinfo.go'">회원정보</button>
	<button onclick="location.href='userprofile.go?userId=${sessionScope.loginId}'">회원 프로필</button>
</body>
<script>

var msg = "${msg}";
if(msg != ""){
	alert(msg);
}

var check = "${sessionScope.adminRight}";
console.log(check);
</script>
</html>
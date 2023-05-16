<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	
</style>
</head>
<body>
	<h3>회원 프로필</h3>
	
	<div id="inline">
		<img width="200" src="/photo/${profileInfo.photoName}"/>
	</div>
	
	<div id="inline">
		<table>
			<tr>
				<th>닉네임</th>
				<td>${profileInfo.nickName}</td>
			</tr>
			<tr>
				<th>키</th>
				<td>${profileInfo.height}</td>
			</tr>
			<tr>
				<th>포지션</th>
				<td>${profileInfo.position}</td>
			</tr>
			<tr>
				<th>선호 지역</th>
				<td>${profileInfo.gu}</td>
			</tr>
			<tr>
				<th>선호 시간</th>
				<td>${profileInfo.favTime}</td>
			</tr>
			<tr>
				<th>매너 점수</th>
				<td>${mannerPoint}</td>
			</tr>
		</table>
	</div>
	

	<div>
		<table>
			<tr>
				<th>참여 경기 목록</th>
			</tr>
			<c:if test="${profileGames eq '[]'}"> 
				<tr>
					<th colspan="4">등록된 글이 없습니다.</th>
				</tr>
			</c:if>
			<c:forEach items="${profileGames}" var="bbs" end="4">
				<tr>
					<td>${bbs.gu}</td>
					<td>${bbs.subject}</td>
					<td>${bbs.gameDate}</td>
					<td>${bbs.gamePlay}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	<c:set var="loginId" value="${sessionScope.loginId}" />
	<c:if test="${loginId != null}">
		<button onclick="window.open('userReport.go?userId=${profileInfo.userId}&userIdx=${profileInfo.userIdx}','회원 신고','width=600px,height=400px')">신고</button>
	</c:if>
	<input type="button" onclick="window.close()" id="closeBtn" value="닫기"/>
</body>
<script>
var profileGames ="${profileGames}";
console.log(profileGames);
</script>
</html>
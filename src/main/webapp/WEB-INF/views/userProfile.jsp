<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>

</style>
</head>
<body>

<div style="float: right;">
	<jsp:include page="loginBox.jsp"></jsp:include>
</div>
<jsp:include page="GNB.jsp"></jsp:include>
	<h3>회원 프로필</h3>
	
	<div id="inline">
		<img width="300" src="/photo/${profileInfo.photoName}"/>
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
		</table>
	</div>
	
	<div>		
		<table>
			<tr>
				<th>MVP 선정 횟수</th>
				<td>${user.userMvp}</td>
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
	<button onclick="window.open('userReport.go?userId=${profileInfo.userId}&userIdx=${profileInfo.userIdx}','회원 신고','width=600px,height=400px')">신고</button>

</body>
<script>
var profileGames ="${profileGames}";
console.log(profileGames);
</script>
</html>
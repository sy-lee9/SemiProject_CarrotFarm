<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
	table{
		width: 1000;
		height: 300;
		margin: 30;
	}
	th,td{
		text-align: center;
	}
	td{
		height: 10;
	}
	#gameDate{
		margin: 30;
	}
</style>
</head>
<body>
	<a href="teamJoinAppAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
	<a href="gameMatchingAppAlarm.go?teamIdx=${teamIdx}">경기 참가신청 알림</a>
	<a href="appGameUpdateAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
	<a href="matchingInviteAlarm.go?teamIdx=${teamIdx}">경기 초대 알림</a>
	<br/>
	<hr/>
	<br/>
	<table>
		<colgroup>
			<col width="10%"/>
			<col width="25%"/>
			<col width="25%"/>
			<col width="25%"/>
			<col width="15%"/>
		</colgroup>
		<thead>
			<tr>
				<th>팀명</th>
				<th>제목</th>
				<th>장소</th>
				<th>경기일시</th>
				<th>경기방식</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list}" var="team">
				<tr>
					<td><a href="teamPage.go?teamIdx=${team.teamIdx}">${team.teamName}</a></td>
					<td><a href="../matching/detail.go?matchingIdx=${team.matchingIdx}">${team.subject}</a></td>
					<td>${team.location}</td>
					<td>${team.gameDate}</td>
					<td>${team.gamePlay}:${team.gamePlay}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

</script>
</html>
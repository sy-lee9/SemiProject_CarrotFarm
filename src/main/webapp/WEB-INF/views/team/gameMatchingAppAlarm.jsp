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
		height: 100;
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
			<col width="25%"/>
			<col width="25%"/>
			<col width="25%"/>
			<col width="25%"/>
		</colgroup>
		<thead>
			<tr>
				<th>신청한 모집글</th>
				<th>팀명</th>
				<th>활동지역</th>
				<th>매너점수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list}" var="team">
				<tr>
					<td><a href="../matching/detail.go?matchingIdx=${team.matcingIdx}">${team.subject}</a></td>
					<td><a href="#" onclick="window.open('teamPagePop.go?teamIdx=${team.teamIdx}', '팀페이지팝업창', 'width=1000px,height=600px');">${team.teamName}</a></td>
					<td>${team.gu}</td>
					<td>${team.teamManner}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

</script>
</html>
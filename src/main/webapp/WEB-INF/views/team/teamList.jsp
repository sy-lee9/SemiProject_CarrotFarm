<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>	
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	th,td{
		text-align: center;
	}
</style>
</head>
<body>
	<button onclick="location.href='team/teamRegist.go'">팀 개설하기</button>
	<table>
		<thead>
			<tr>
				<th>모집상태</th>
				<th>주활동지역</th>
				<th>팀 프로필</th>
				<th>팀 이름</th>
				<th>팀 소개글</th>
				<th>팀원</th>
				<th>매너점수</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${list eq null}">
				<tr>
					<th colspan="7">등록된 팀이 없습니다.</th>
				</tr>
			</c:if>
			<c:forEach items="${list}" var="team">
				<tr>
					<td>${team.teamMatchState}</td>
					<td>${team.locationIdx}</td>
					<td>
						<a href="team/detail.do?idx=${team.teamIdx}"><img src="/t01/${team.photoName}"/></a>
					</td>
					<td>${team.teamName}</td>
					<td>${team.teamIntroduce}</td>
					<td>${team.teamUser}</td>
					<td>${team.teamManner}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

</script>
</html>
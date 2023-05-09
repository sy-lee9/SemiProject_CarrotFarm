<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
	table{
		width: 500;
		height: 500;
	}
	th,td{
		text-align: center;
	}
	a{
		margin: 20;
	}
</style>
</head>
<body>
	<input type="hidden" name="teamIdx" value="${teamIdx}"/>
	<a href="teamAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
	<a href="#">경기 참가신청 알림</a>
	<a href="gameAppAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
	<br/>
	<hr/>
	<br/>
	<table>
		<colgroup>
			<col width="40%"/>
			<col width="60%"/>
		</colgroup>
		<thead>
			<tr>
				<th>제목</th>
				<th>변경내용</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${list eq null}">
				<tr>
					<th colspan="2">신청한 경기가 없습니다.</th>
				</tr>
			</c:if>
			<c:forEach items="${list}" var="bbs">
				<tr>
					<td><a href="../matching/detail.go?matchingIdx=${bbs.matchingIdx}">${bbs.subject}</a></td>
					<td>모집글이 ${bbs.alarmContent}되었습니다.</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

</script>
</html>
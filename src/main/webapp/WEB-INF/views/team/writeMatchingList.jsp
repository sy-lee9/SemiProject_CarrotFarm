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
		height: 700;
		margin: 20;
	}
	th,td{
		text-align: center;
		padding: 10;
	}
	a{
		margin: 20;
	}
</style>
</head>
<body>
	<input type="hidden" name="teamIdx" value="${teamIdx}"/>
	<table>
		<colgroup>
			<col width="20%"/>
			<col width="30%"/>
			<col width="40%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th>경기지역</th>
				<th>제목</th>
				<th>경기일시</th>
				<th>작성자</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${list eq null}">
				<tr>
					<th colspan="4">모집중인 경기가 없습니다.</th>
				</tr>
			</c:if>
			<c:forEach items="${list}" var="matching">
				<tr>
					<td>${matching.gu}</td>
					<td><a href="../matching/detail.go?matchingIdx=${matching.matchingIdx}">${matching.subject}</a></td>
					<td>${matching.gameDate}</td>
					<td>${matching.writerId}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

</script>
</html>
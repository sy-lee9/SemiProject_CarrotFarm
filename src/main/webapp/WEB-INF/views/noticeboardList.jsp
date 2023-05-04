<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<link rel="stylesheet" href="resources/css/commons.css" type = "text/css">
<style>
	table{
		width:100%;
	}

	table, td, th{
		border : 1px solid;
		border-collapse : collapse;
		padding: 5px;
	}
</style>
</head>
<body>
	<button onclick="location.href='noticeboardWrite.go'">등록</button>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회수</th>
				<th>작성일</th>		
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list}" var="board">
				<tr>
					<td>${board.boardIdx}</td>
					<td><a href = "noticeboardDetail.do?bidx=${board.boardIdx}">${board.subject}</a></td>
					<td>${board.userId}</td>
					<td>${board.bHit}</td>
					<td>${board.writeTime}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>
</script>
</html>
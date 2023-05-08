<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<link rel="stylesheet" href="resources/css/commons.css">
<style></style>
</head>
<body>
	<form action="noticeboardUpdate.do" method="post" enctype="multipart/form-data">
		<input type = "hidden" name="bidx" value="${dto.boardIdx}"/>
		<table>
			<tr>
				<th>제목</th>
				<td><input type="text" name="subject" value = "${dto.subject}"/></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${loginId}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content">${dto.content}</textarea></td>
			</tr>
			<tr>
				<th>사진</th>
				<td>
					<c:if test="${dto.photoName eq null}">
						<input type="file" name="photo"/>
					</c:if>
					<c:if test="${dto.photoName ne null}">
						<img src = "/photo/${dto.photoName}"/>
					</c:if>
				</td>
			</tr>
			<tr>
				<th colspan="2">
					<input type = "button" onclick="location.href='./noticeboardList.do'" value="리스트"/>
					<button>저장</button>
				</th>
			</tr>	
		</table>
	</form>
</body>
<script></script>
</html>
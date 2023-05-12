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
	<form action="freeboardUpdate.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
		<input type = "hidden" name="bidx" value="${dto.boardIdx}"/>
		<table>
			<tr>
				<th>제목</th>
				<td><input type="text" name="subject" id="subjectInput" style="width: 380px; height: 30px;" value = "${dto.subject}"></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="text" name="userId" value = "${dto.userId}" style="border:none" readonly/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" id="contentInput" style="width: 800px; height: 400px; resize: none;">${dto.content}</textarea></td>
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
					<input type = "button" onclick="location.href='./freeboardList.do'" value="리스트"/>
					<button>저장</button>
				</th>
			</tr>	
		</table>
	</form>

</body>
<script>
function validateForm() {
	var subject = document.getElementById('subjectInput').value;
	var content = document.getElementById('contentInput').value;
	
	if (subject.trim() == '') {
		alert('제목을 입력해주세요.');
		return false;
	}
	
	if (content.trim() == '') {
		alert('내용을 입력해주세요.');
		return false;
	}
	
	return true;
}
</script>
</html>
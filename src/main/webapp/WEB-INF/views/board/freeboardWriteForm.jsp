<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
table{
	width : 100%;
}

table, th, td{
	border : 1px solid black;
	border-collapse : collapse;
	padding : 5px 10px;
}

button{
	margin : 5px;
}

input[type="text"]{
	width : 100%;
}

textarea{
	width : 100%;
	height : 150px;
	resize : none;	
}
</style>
</head>
<body>
	<form action="freeboardWrite.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
	<input type="hidden" name="categoryId" value="b001"/>
		<table>
			<tr>
				<th>제목</th>
				<td><input type="text" name="subject" id="subjectInput"/></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="text" name="userId" value="${userId}" style="border:none;"readonly/> </td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" id="contentInput"/></textarea></td>
			</tr>
			<tr>
				<th>사진</th>
				<td>
					<input type="file" name="photo"/>
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
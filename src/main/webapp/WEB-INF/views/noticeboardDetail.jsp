<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
@charset "UTF-8";

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
}</style>
</head>
<body>
		<table>
			<tr>
				<th>제목</th>
				<td>${dto.subject}</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${loginId}</td>
			</tr>
			<tr>
				<th>작성일</th>
				<td>${dto.writeTime}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${dto.content}</td>
			</tr>
			<c:if test= "${dto.photoName ne null}">
			<tr>
				<th>사진</th>
				<td><img width = "333" src="/photo/${dto.photoName}"/></td>
			</tr>
			</c:if>
			<tr>
				<th colspan="2">
					<input type = "button" onclick="location.href='./noticeboardList.do'" value="리스트"/>
					<input type = "button" id="registerBtn1" onclick="location.href='./noticeboardUpdate.go?bidx=${dto.boardIdx}'" value="수정"/>	
					<input type = "button" id="registerBtn2" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./noticeboardDelete.do?bidx=${dto.boardIdx}';}">			
				</th>
			</tr>
		</table>
</body>
<script>
$.ajax({
	type:'post',
	url:'userRight.ajax',
	data:{},
	dataType:'json',
	success:function(data){
		console.log(data);
		if (data != "1") {
			document.getElementById("registerBtn1").style.display = "none";
			document.getElementById("registerBtn2").style.display = "none";
		}
	},
	error:function(e){
		console.log(e);
	}
});
</script>
</html>
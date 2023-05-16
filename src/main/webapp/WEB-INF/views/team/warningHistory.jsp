<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="../resources/js/twbsPagination.js" type="text/javascript"></script>

	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>	
	table, th, td{
		padding : 5px 10px;	
	}
	th,td{
		text-align: center;
		height: 20;
	}
	table{
		width: 800;
		height: 100;
	}
	h1{
		margin:10;
		display: inline;
	}
	button{
		float: right;
	}
</style>
</head>
<body>

	<h1>${userId}</h1>
	<button onclick="window.open('removeNow.go?userId=${userId}&teamIdx=${teamIdx}','즉시강퇴','width=800px,height=550px')">즉시강퇴</button>
	<hr/>
	<table>
		<colgroup>
			<col width="20%"/>
			<col width="20%"/>
			<col width="60%"/>
		</colgroup>
		<thead>
			<tr>
				<th>부여일</th>
				<th>경고 내용</th>
				<th>경고 사유</th>
			</tr>
		</thead>
			<tr>
				<th colspan="3"><hr/></th>
			</tr>
		<tbody>
			<c:forEach items="${list}" var="warning">
				<tr>
					<td>${warning.warningDate}</td>
					<td>${warning.warningResult}</td>
					<td>${warning.warningReason}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script>

	var msg = "${msg}";
	console.log(msg);
	if(msg != ''){
		alert(msg);
	}

</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style></style>
</head>
<body>
	<form action="courtTipOff.do">
		<input type="hidden" name="userId" value="test1"/>
		<table>
			<tr>
				<th>경기장 이름</th>
				<th><input type="text" name="courtName"/></th>
			</tr>
			<tr>
				<th>경기장 주소</th>
				<th><input type="text" name="courtAddress"/></th>
			</tr>
		</table>
		<button>저장</button>
	</form>
</body>
<script>

</script>
</html>
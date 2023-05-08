<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	#div1{
		margin: auto;
		width: 200px;
        height: 50px;
		position: absolute;
        top: 22%;
        left: 27%;
	}
	#div2{
		margin: auto;
		background-color: #f8f9fa;
		position: absolute;
        width: 800px;
        height: 400px;
        top: 30%;
        left: 25%;
	}
	#div2 p,br,h4{
		margin: 60 10 10 80;
	}
	#div2 h5{
		margin: 10 10 10 80;
		color: red;
	}
	button{
		margin: 20 10 10 350;
	}
	hr{
		margin: 20;
	}
</style>
</head>
<body>
	<form action="teamDisbanding.do">
	<input type="hidden" name="teamIdx" value="${teamIdx}"/>
		<div id="div1"><h1>팀 해체</h1></div>
		<div id="div2">
			<hr>
			<p>팀 해체는 팀에 관련된 모든 정보와 기록들이 삭제되는 것을 말합니다.</p>
			<h5>해체된 팀의 모든 데이터는 복구가 불가능하오니, 신중하게 결정하시기 바랍니다.</h5>
			<h4>팀 해체 예정일시는 신청일로부터 7일 후 입니다.</h4>
			<h5>팀 해체 보류기간 동안 팀 해체를 취소할 수 있습니다.</h5>
			<br/>
			<br/>
			<br/>
			<button>팀 해체 신청</button>
			<hr>
		</div>
	</form>
</body>
<script>

</script>
</html>
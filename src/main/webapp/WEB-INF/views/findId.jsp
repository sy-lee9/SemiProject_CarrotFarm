<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style>

</style>
</head>
<body>
	<div class="card o-hidden border-0 shadow-lg my-5">

<div class="jumbotron">
  <h3> 아이디는 : </h3><br/>
  		<ul>
  			<c:forEach items="${user}" var="user">
  		  		<li>${user.userId} </li><br/>
  			</c:forEach>
  		</ul>
  	<h2>입니다</h2>
  <button type="button" class="btn btn-primary" onclick="location.href='/cf/login'">로그인페이지</button>
  <button type="button" class="btn btn-primary" onclick="location.href='/cf/'">메인페이지</button>
  
  
</div>
</body>
<script></script>
</html>
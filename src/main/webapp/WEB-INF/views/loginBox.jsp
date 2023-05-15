<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style>

</style>
</head>
<body>
<div id="login"></div>
</body>
<script>
   var loginId = "${sessionScope.loginId}";
   if(loginId == ""){
      var content= '<a href="/cf/login">[로그인]</a>';
      $("#login").html(content);
   }else{
      var content='🏀 안녕하세요 ${sessionScope.loginId} 님! <a href="/cf/logout">[로그아웃]</a>';
      $("#login").html(content);
   }
</script>
</html>
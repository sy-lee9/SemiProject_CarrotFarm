<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<script src = "https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style></style>
</head>
<body>
<h3>회원 탈퇴 하시겠습니까?</h3>
<div>- 회원 탈퇴 후 3일 동안은 재가입이 불가능 합니다.</div>
<div>- 탈퇴 시 계정의 모든 정보는 삭제되며, 재가입 시에는 복귀되지 않습니다.</div>
<button onclick="location.href='userdelete.do'">예</button>
<button onclick="location.href='/cf/'">아니요</button>


</body>
<script></script>
</html>
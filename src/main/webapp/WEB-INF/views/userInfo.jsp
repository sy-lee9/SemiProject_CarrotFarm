<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<script src = "https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
      
</style>
</head>
<body>
   <jsp:include page="login.jsp"></jsp:include>
   <h3>회원 정보</h3>
      <table>
         <tr>
            <th>아이디</th>
            <td>
               <input type="text" id="userId" value="${user.userId}" readonly/>                           
            </td>
         </tr>
         <tr>
            <th>닉네임</th>
            <td>
               <input type="text" id="nickName" value="${user.nickName}" readonly/>                              
            </td>
         </tr>
         <tr>
            <th>비밀번호</th>
            <td><input type="text" id="userPw" value="${user.userPw}" readonly/></td>
         </tr>
         <tr>
            <th>키</th>
            <td><input type="text" id="height" value="${user.height}" readonly/></td>
         </tr>
         <tr>
            <th>이름</th>
            <td>
               <input type="text" id="userName" value="${user.userName}" readonly/>               
            </td>            
         </tr>
         <tr>
            <th>포지션</th>
            <td>
               <input type="text" id="position" value="${user.position}" readonly/>               
            </td>            
         </tr>
         <tr>
            <th>생년월일</th>               
            <td><input type="text" id ="birthday" value="${user.birthday}" readonly/></td>
         <tr> 
         <tr>
            <th>선호 경기 지역</th>
            <td><input type="text" id="locationIdx" value="${user.si} ${user.gu}" readonly/></td>
         </tr>
         <tr>
            <th>E-MAIL</th>
            <td><input type="email" id="email" value="${user.email}" readonly/></td>
         </tr>
         <tr>
            <th>선호 경기 시간</th>
            <td><input type="text" id="favTime" value="${user.favTime}" readonly/></td>
         </tr>
         <tr>      
            <th colspan="2">
               <button onclick="location.href='userinfoupdate.go'">회원정보 수정</button>
               <button onclick="location.href='./'">돌아가기</button>
            </th>
            </tr>
      </table>
</body>
<script>

</script>
</html>
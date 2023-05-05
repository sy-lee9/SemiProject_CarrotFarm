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
	<h3>로그인</h3>
	<table>
		<tr>
			<th>아이디</th>
			<td><input type="text" id="userId"/></td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td><input type="password" id="userPw"/></td>
		</tr>
		<tr>
			<th colspan="2">
				<button onclick="login()">로그인</button>
				<button onclick="location.href='join'">회원 가입</button>
				<button onclick="location.href='findIdView'">ID 찾기</button>
				<button onclick="location.href='findpw.go'">PW 찾기</button>
			</th>
		</tr>
	</table>
</body>
<script>
function login(){
	
	console.log('id','pw');
	$.ajax({
		type:'post',
		url:'login.ajax',
		data:{
			id:$('#userId').val(),
			pw:$('#userPw').val()
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			if(data.user != null){
				alert('로그인에 성공 했습니다.');
				location.href='/cf/';
			}else{
				alert('아이디 또는 비밀번호를 확인해 주세요!');
			}			
		},
		error:function(e){
			consol.log(e);
			alert('아이디 또는 비밀번호를 확인해 주세요!');
		}		
	});

}

</script>
</html>
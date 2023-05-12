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
<jsp:include page="../loginBox.jsp"></jsp:include>
	<select name="category" id="categoryType">
         <option value="사용중">사용중</option>
         <option value="탈퇴">탈퇴</option>
         <option value="이용제한1">이용제한(1일)</option>
         <option value="이용제한3">이용제한(3일)</option>
         <option value="이용제한5">이용제한(7일)</option>
         <option value="이용제한30">이용제한(30일)</option>
         <option value="영구제한">영구제한</option>
      </select>
    <input type="text" id="searchInput" placeholder="아이디 입력">
   	<button id="searchButton">검색</button>
	<table>
		<thead>
			<tr>
				<th><input type="checkbox" id="all"/></th>
				<th>NO</th>
				<th>회원분류</th>
				<th>아이디</th>
				<th>이름</th>
				<th>프로필</th>
				<th>닉네임</th>
				<th>닉네임 변경</th>
				<th>사진 변경</th>
				<th>가입팀</th>
				<th>가입일</th>				
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list}" var="member">
				
				<tr>
					<td><input type="checkbox"/></td>
					<td>${member.userIdx}</td>
					<td>사용중</td>
					<td><a href="userprofile.go?userId=${member.userId}">${member.userId}</a></td>
					<td>${member.userName}</td>
					<td><img width="50" src="/photo/${member.photoName}"/></td>
					<td>${member.nickname}</td>
					<td><button onclick="nicknameChange('${member.userId}')">닉네임 변경</button></td>
					<td><button>사진 변경</button></td>
					<td>가입팀</td>
					<td>${member.userJoinDate}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<button>초기화</button>
	<button onclick="location.href='logout'">로그아웃</button>
	<button onclick="location.href='userdelete.go'">회원탈퇴</button>
	<button onclick="location.href='userinfo.go'">회원정보</button>
	<button onclick="location.href='mygames'">참여경기 리스트</button>
	<button onclick="location.href='userprofile.go?userId=${sessionScope.loginId}'">회원 프로필</button>
</body>
<script>
function nicknameChange(userId){
	$.ajax({
		type:'get',
		url:'adminUserNicknameChange.ajax',
		data:{"userId":userId},
		dataType:'json',
		success:function(data){
			//console.log(data);
			if(!data.login){
			
				location.href='./';
			}else{
				listDraw(data.list);
			}
		},
		error:function(e){
			console.log(e);
		}
	});	
}

var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>

	body{
      position:relative;
      font-size:15px;
      padding : 10px;
	  }
	   
	   #content {
	      width:78%;
	      background-color: #f8f9fa;
	      padding: 10 30 10;
	      margin : 5px;
	      float:right;	      
	   }
	   
	   #LNB {
	      width:20%;
	      height : 80%;
	      background-color: #f8f9fa;
	      float:left;
	      margin : 5px;
	   }

    .right-div {
        float: right;
        margin-right: 400px; /* 좌측과의 간격을 조정할 수 있습니다 */
        
    }

</style>
</head>
<body>

<div style="float: right;">
	<jsp:include page="loginBox.jsp"></jsp:include>
</div>
<jsp:include page="GNB.jsp"></jsp:include>
	
	<div id="LNB">
       <ul>
         <li>
           <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
         </li>
         <li>
           <a href="/cf/userinfo.go">회원 정보</a>
         </li>
         <li>
           <a href="/cf/userprofile.go">회원 프로필</a>
         </li>
         <li>
           <a href="/cf/mygames">참여 경기</a>
         </li>
       </ul>
   </div>

	<h3>회원 프로필</h3>
	
	<div id="inline">
		<img width="200" src="/photo/${profileInfo.photoName}"/>
	</div>
	</br>
	<div id="inline">
		<table>
			<tr>
				<th>닉네임</th>
				<td>${profileInfo.nickName}</td>
			</tr>
			<tr>
				<th>키</th>
				<td>${profileInfo.height}</td>
			</tr>
			<tr>
				<th>포지션</th>
				<td>${profileInfo.position}</td>
			</tr>
			<tr>
				<th>선호 지역</th>
				<td>${profileInfo.gu}</td>
			</tr>
			<tr>
				<th>선호 시간</th>
				<td>${profileInfo.favTime}</td>
			</tr>
			<tr>
				<th>매너 점수</th>
				<td>${mannerPoint}</td>
			</tr>
		</table>
	</div>
	
	
	<div class="right-div">
		<table>
			<tr>
				<th>참여 경기 목록</th>
			</tr>
			<c:if test="${profileGames eq '[]'}">
				<tr>
					<th colspan="4">등록된 글이 없습니다.</th>
				</tr>
			</c:if>
			<c:forEach items="${profileGames}" var="bbs" end="4">
				<tr>
					<td>${bbs.gu}</td>
					<td>${bbs.subject}</td>
					<td>${bbs.gameDate}</td>
					<td>${bbs.gamePlay}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	
	</br>
	<c:set var="loginId" value="${sessionScope.loginId}" />
	<c:if test="${loginId != null}">
		<button onclick="window.open('userReport.go?userId=${profileInfo.userId}&userIdx=${profileInfo.userIdx}','회원 신고','width=600px,height=400px')">신고</button>
	</c:if>
</body>
<script>
var profileGames ="${profileGames}";
console.log(profileGames);
</script>
</html>
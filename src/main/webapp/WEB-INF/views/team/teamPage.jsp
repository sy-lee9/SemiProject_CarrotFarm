<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	
	table{
		width: 300px;
		height: 500px;
	}
	
	button{
		margin: 5px;
	}
	

	#inline,#teamMatchState{
		float: left;
	}
	
	div{
      position: relative;
      top: 100px; /*static을 기준으로 top100px / static이 없으면 가장 가까운 relative 기준*/
      left: 100px;
      right: 100px;
      bottom: 100px;
        }
	div{
		padding: 50px;
	}
</style>
</head>
<body>
	<div id="inline"><p id="teamMatchState">${team.teamMatchState}</p></div> 
	<div id="inline"><button onclick="location.href='team/teamJoin.do'">가입신청</button></div>
	<div><button onclick="location.href='teamPageUpdate.go?teamIdx=${team.teamIdx}'">팀정보 수정</button></div>
	<div id="inline"><button onclick="location.href='teamDisbanding.go?teamIdx=${team.teamIdx}'">팀 해체</button></div>
	<div id="inline"><button onclick="location.href='teamGame.go?teamIdx=${team.teamIdx}'">경기기록 보기</button></div>
	<div id="inline"><button onclick="location.href='gameMatchingRequest.go?teamIdx=${team.teamIdx}'">참가신청한 경기</button></div>
	
	
	
	<div id="inline">
		<c:if test="${team.photoName eq null}">
			<img width="400" src="/photo/팀이미지.png"/>
		</c:if>
		<c:if test="${team.photoName ne null}">
			<img width="400" src="/photo/${team.photoName}"/>
		</c:if>
	</div>
	
	<div id="inline">
		<table>
			<tr>
				<th colspan="2">${team.teamName}</th>
			</tr>
			<tr>
				<th>매너점수</th>
				<td>${team.teamManner}</td>
			</tr>
			<tr>
				<th>팀원 수</th>
				<td>${team.teamUser}</td>
			</tr>
			<tr>
				<th>활동 지역</th>
				<td>${team.gu}</td>
			</tr>
			<tr>
				<th>주 활동 시간</th>
				<td>${team.teamFavTime}</td>
			</tr>
			<tr>
				<th>선호 경기종목</th>
				<td>${team.teamFavNum}</td>
			</tr>
		</table>
	</div>
	
	<div>		
		<table>
			<tr>
				<th height="15%">팀 소개글</th>				
			</tr>
			<tr>
				<td height="70%" valign="top">${team.teamIntroduce}</td>
			</tr>
		</table>
	</div>

	<div>
		<table>
			<tr>
				<th>리뷰</th>
			</tr>
				<c:forEach items="${list}" var="team">
				<tr>
					<td>${team.tagContent}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
			
			

</body>
<script>
var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
</html>
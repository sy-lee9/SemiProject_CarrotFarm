<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="../resources/js/twbsPagination.js" type="text/javascript"></script>
	
	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>
	body{
		position:relative;
		font-size:15px;
		padding : 10px;
		min-width: 1200px;
	}
	
	#content {
		width:78%;
		height : 83%;
		background-color: #f8f9fa;
		padding: 10 30 10;
		margin : 5px;
		float:right;
		
	}
	
	#LNB {
		width:20%;
		height : 83%;
		background-color: #f8f9fa;
		float:left;
		margin : 5px;
		font-weight: bold;
        font-size: 18px;
		text-align:center;
		
	}
	
	table, th, td{
		margin : 5px;
	}
	
	table{
		width:100%;
		height:40%;
		text-align:center;
	}
	
	a {
	  color : black;
	}
	
	a:link {
	  color : black;
	}
	a:visited {
	  color : black;
	}
	a:hover {
	 text-decoration-line: none;
	  color : #FFA500 ;
	}
	
	.pagination .page-link {
  		color: gray; /* 기본 글자색을 검정색으로 지정 */
	}

	.pagination .page-item.active .page-link {
 		background-color: #FFA500;
 		border:none;
	}
</style>
</head>
<body>
	<div style="float: right;">
		<%@ include file="../loginBox.jsp" %>
	</div> 
	
	<%@ include file="../GNB.jsp" %>

	<div id="LNB">
		<br/><br/>
        <br/><br/>
		<c:if test="${loginId eq null}">
			<img width="200" height="200" src="/photo/기본프로필.png">
		</c:if>
		<c:if test="${loginId ne null}">
			<img width="200" height="200" src="/photo/${loginPhotoName}"> 
			<br/> <h3 style="display:inline-block; margin-top:10px;">${loginId} </h3>님 <a href="/cf/userNoticeAlarm">🔔</a>
		</c:if>
      <br/><br/>
        <a href="/cf/team/teamJoinAppAlarm.go?teamIdx=${teamIdx}">알림</a>
      <br/><br/>
        <a href="/cf/team/teamPageUpdate.go?teamIdx=${teamIdx}">팀정보 수정</a>
      <br/><br/>
        <a href="/cf/team/teamUserListLeader.go?teamIdx=${teamIdx}">팀원</a>
      <br/><br/>
        <a href="/cf/team/writeMatchingList.go?teamIdx=${teamIdx}">모집중인 경기</a>
      <br/><br/>
        <a href="/cf/team/gameMatchingRequest.go?teamIdx=${teamIdx}" >참가신청한 경기</a>
        <br/><br/>
        <a href="/cf/team/warningTeamUser.go?teamIdx=${teamIdx}">경고/강퇴</a>
      <br/><br/>
        <a href="/cf/team/teamDisbanding.go?teamIdx=${teamIdx}" >팀 해체</a>
	</div>
	
	
	<div id="content">
		<input type="hidden" name="teamIdx" value="${teamIdx}"/>
		<br/>
		<ul class="nav nav-tabs">
		  <li class="nav-item">
		    <a class="nav-link" href="teamJoinAppAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link"  href="gameMatchingAppAlarm.go?teamIdx=${teamIdx}">경기 참가신청 알림</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link active"  href="appGameUpdateAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link"  href="matchingInviteAlarm.go?teamIdx=${teamIdx}">경기 초대 알림</a>
		  </li>
		</ul>
		<br/><br/>
		<table>
			<colgroup>
				<col width="40%"/>
				<col width="60%"/>
			</colgroup>
			<thead>
				<tr>
					<th>제목</th>
					<th>변경내용</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list.size() == 0}">
					<tr>
						<th colspan="2">신청한 경기가 없습니다.</th>
					</tr>
				</c:if>
				<c:forEach items="${list}" var="matching">
					<tr>
						<td><a href="../matching/detail.go?matchingIdx=${matching.matchingIdx}">${matching.subject}</a></td>
						<td>모집글이 ${matching.alarmContent}되었습니다.</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
<script>

</script>
</html>
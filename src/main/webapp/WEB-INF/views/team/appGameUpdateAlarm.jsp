<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="resources/js/twbsPagination.js" type="text/javascript"></script>

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

	table{
		width: 500;
		height: 500;
	}
	th,td{
		text-align: center;
	}
	a{
		margin: 20;
	}
</style>
</head>
<body>

	<%@ include file="../GNB.jsp" %>
	
	<div id="LNB">
       <ul>
         <li>
           <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
         </li>
         <li >
           <a href="/cf/matching/list.do">개인 모집글</a>
         </li>
         <li>
           <a href="/cf/matching/teamList.do">팀 모집글</a>
         </li>
       </ul>
   </div>
	
	<div id="content">
		<input type="hidden" name="teamIdx" value="${teamIdx}"/>
		<a href="teamJoinAppAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
		<a href="gameMatchingAppAlarm.go?teamIdx=${teamIdx}">경기 참가신청 알림</a>
		<a href="appGameUpdateAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
		<a href="matchingInviteAlarm.go?teamIdx=${teamIdx}">경기 초대 알림</a>
		<br/>
		<hr/>
		<br/>
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
				<c:if test="${list eq null}">
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
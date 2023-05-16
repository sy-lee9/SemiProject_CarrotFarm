<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>  

<style>

	table, th, td{
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	
	th,td{
		text-align: center;
	}
	
	table{
		width: 100%;
		margin : 5px;
	}
	
	button{
		margin: 5px;
	}
	

	#inline{
		float: left;
		margin:0 20 5 0;
	}

</style>
</head>
<body>

	<div><h3 style=margin:10;>${team.teamMatchState}</h3></div> 
	<hr/>
	<table>
		<colgroup>
	         <col width="50%"/>
	         <col width="25%"/>
	         <col width="25%"/>
	     </colgroup>
		<tr>
			<th rowspan="6">
				<c:if test="${team.photoName eq null}">
					<img width="600" height="300" src="/photo/팀이미지.png"/>
				</c:if>
				<c:if test="${team.photoName ne null}">
					<img width="600" height="300" src="/photo/${team.photoName}"/>
				</c:if>
			</th>
			<th colspan="2" style="border-bottom: 1px solid black">${team.teamName}</th>			
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
			<td id="teamFavNum"></td>
		</tr>		
	</table>
	<br/>
	<br/>
	<div style="width: 400; height: 100px; margin: 10px; float: left; text-align: center;">
		<h4>팀 소개글</h4>	
		<p>${team.teamIntroduce}</p>		
	</div>
	<div style="height: 100px; margin: 10px; text-align: center;">
		<h4>경기리뷰</h4>
		<c:forEach items="${list}" var="team">
			<p style="display: inline;">${team.tagContent} ${team.tagCount}</p>&nbsp;
		</c:forEach>
	</div>
</body>
<script>
	if("${team.teamFavNum}" == '0'){
		$('#teamFavNum').text("상관없음");
	}else if("${team.teamFavNum}" == '3'){
		$('#teamFavNum').text("3:3");
	}else if("${team.teamFavNum}" == '5'){
		$('#teamFavNum').text("5:5");
	}
</script>
</html>
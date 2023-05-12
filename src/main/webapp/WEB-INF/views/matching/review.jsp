<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style>
	body {
		text-align:center;
	}
	div {
		display:inline-block;
	}
</style>
</head>
<body>
	<h2>당근농장 리뷰</h2>
	
	</br>
		<form action="review.do?matchingIdx=${matchingIdx}" method="post" id="form">
			<input type="text" name="writerId" id="${loginId}" value="${loginId}" hidden> 
			<h3>MVP를 선택해주세요</h3>
			<select name="receiveId" id="receiveId">
				<option value="none">MVP</option>
				<c:forEach items="${playerList}" var="playerList">
					<option value="${playerList.userId}">${playerList.userId}</option>
				</c:forEach>
			</select>
			
			<h3>경기 매너를 평가해주세요</h3>
			<div>
				<c:forEach items="${playerList}" var="playerList" varStatus="status">
				<c:if test="${playerList.userId ne loginId}">
					<c:if test="${status.index % 2 == 1}"> 
							${playerList.userId} 
							<input type="radio" name="${playerList.userId}" id="${playerList.userId}" value="0.1"> 👍
							<input type="radio" name="${playerList.userId}" id="${playerList.userId}" value="-0.1"> 👎
							</br>
					</c:if>
				</c:if>
				</c:forEach>
			</div>
			<div>
				<c:forEach items="${playerList}" var="playerList" varStatus="status">
				<c:if test="${playerList.userId ne loginId}">
					<c:if test="${status.index % 2 == 0}"> 
							| ${playerList.userId} 
							<input type="radio" name="${playerList.userId}" id="${playerList.userId}" value="0.1"> 👍
							<input type="radio" name="${playerList.userId}" id="${playerList.userId}" value="-0.1"> 👎
							</br>
					</c:if>
				</c:if>
				</c:forEach>
			</div>	
		</form>
		</br>
		<button onclick="subChk()">제출</button>
	
</body>
<script>
function subChk(){
	
	if($('#receiveId').val() == 'none'){
		alert('MVP를 선택해주세요.');
		return false;
	}else if($('#receiveId').val() == ''){
		alert('MVP를 선택해주세요.');
		return false;
	}
	
	if(!confirm('리뷰는 수정이 불가능합니다. \n리뷰를 제출하시겠습니까?')){
        return false;
    }

	$('#form').submit();
	
}
</script>
</html>
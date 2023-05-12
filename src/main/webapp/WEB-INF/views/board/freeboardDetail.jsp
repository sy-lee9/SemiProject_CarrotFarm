<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
@charset "UTF-8";

<table frame=void>


table{
	width : 100%;
}

table, th, td{
	border : 1px solid black;
	border-collapse : collapse;
	padding : 5px 10px;
}

button{
	margin : 5px;
}

input[type="text"]{
	width : 100%;
}

input[name="commentContent"]{
	width : 80%;
}

textarea{
	width : 50%;
	height : 50%;
	resize : none;
}

items

</style>
</head>
<body>
		<table>
			<tr>
				<th>제목</th>
				<td>${dto.subject}</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${dto.userId}</td>
			</tr>
			<tr>
				<th>작성일</th>
				<td>${dto.writeTime}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${dto.content}</td>
			</tr>
			<c:if test= "${dto.photoName ne null}">
			<tr>
				<th>사진</th>
				<td><img width = "333" src="/photo/${dto.photoName}"/></td>
			</tr>
			</c:if>
			<tr>
				<th colspan="4">
					<input type = "button" onclick="location.href='./freeboardList.do'" value="리스트"/>
					&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<c:if test="${dto.userId eq loginId }">
						<input type = "button" onclick="location.href='./freeboardUpdate.go?bidx=${dto.boardIdx}'" value="수정"/>
						&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
						<input type = "button" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./freeboardDelete.do?bidx=${dto.boardIdx}';}">
					</c:if>
					
					<c:if test="${dto.userId ne loginId }">
						<button onclick="window.open('freeboardReport.go?bidx=${dto.boardIdx}','_blank','모집글 신고하기',)">신고</button>
					</c:if>
				</th>
			</tr>
			<tr>
	     		<th colspan="7">
		     		<table style="width: 100%;">
			     		<c:forEach items="${fcommentList}" var="fcommentList">
			     			<tr>
			     				<th style="width: 26.5%;">${fcommentList.userId} </th>
			     				<td style="width: 38.5%;">${fcommentList.commentContent}</td>
			     				<td style="width: 18%;">${fcommentList.commentWriteTime}</td>
			     				<td style="width: 17%;">
			     					<c:if test="${fcommentList.userId eq loginId}">
			     						<a  href="freeboardcommentUpdate.go?commentIdx=${fcommentList.commentIdx}&bidx=${dto.boardIdx}">수정</a> 
			     						/ 
			     						<a href="freeboardcommentDelete.do?commentIdx=${fcommentList.commentIdx}&bidx=${dto.boardIdx}">삭제</a>
			     					</c:if>
			     					<c:if test="${fcommentList.userId ne loginId}">
			     						<button onclick="window.open('freeboardCReport.go?commentIdx=${fcommentList.commentIdx}', '_blank', '댓글 신고하기')">신고</button>			     			
			     					</c:if>     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     	</th>	     	
		     </tr>
		     <tr>
		     	<c:if test="${loginId != null }">
			     	<form method="post" action="freeboardcommentWrite.do?categoryId=b001&comentId=${dto.boardIdx}">
			     		<td>
			     			<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
			     		</td>
			     		<td colspan="5">
			     			<input type="text" name="commentContent">
			     			&nbsp; &nbsp; 
			     			<button>작성</button>
			     		</td>
			     	</form> 
			     </c:if>
		     </tr>
		</table>
</body>
<script>
</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
@charset "UTF-8";

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

textarea{
	width : 100%;
	height : 150px;
	resize : none;	
}</style>
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
					<input type = "button" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./freeboardDelete.do?bidx=${dto.boardIdx}';}">
					<input type = "button" onclick="location.href='./freeboardUpdate.go?bidx=${dto.boardIdx}'" value="수정"/>				
					<input type = "button" value="신고"/>
				</th>
			</tr>
			<tr>
	     		<th colspan="7">
		     		<table>
			     		<c:forEach items="${fcommentList}" var="fcommentList">
			     			<tr>
			     				<th>${fcommentList.userId} </th>
			     				<td >${fcommentList.commentContent}</td>
			     				<td>${fcommentList.commentWriteTime}</td>
			     				<td>
			     					<c:if test="${fcommentList.userId eq loginId}">
			     						<a  href="freeboardcommentUpdate.go?commentIdx=${fcommentList.commentIdx}&bidx=${dto.boardIdx}" >수정</a> 
			     						/ 
			     						<a href="freeboardcommentDelete.do?commentIdx=${fcommentList.commentIdx}&bidx=${dto.boardIdx}">삭제</a>
			     					</c:if>
			     					<c:if test="${fcommentList.userId ne loginId}">
			     						<a href="#">신고</a>
			     					</c:if>     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     	</th>	     	
		     </tr>
		     <tr>
			     <form method="post" action="freeboardcommentWrite.do?categoryId=b001&comentId=${dto.boardIdx}">
			     		<th>
			     			<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
			     		</th>
			     		<th colspan="5">
			     			<input type="text" name="commentContent">
			     		</th>
			     		<th>
			     			<button>작성</button>
			     		</th>
			     </form> 
		     </tr>
		     
		     <c:forEach items="${fcommentList}" var="fcommentList">
				<tr>
			    	<th>${fcommentList.userId} </th>
			     	<td colspan="3">${fcommentList.commentContent}</td>
			     	<td>${fcommentList.commentWriteTime}</td>
			     	<td colspan="2">
			     		<c:if test="${fcommentList.userId eq loginId}">
			     			<a  href="fcommentUpdate.go?commentIdx=${fcommentList.commentIdx}&bidx=${dto.bidx}" >수정</a> 
			     			/ 
			     			<a href="fcommentDelete.do?commentIdx=${fcommentList.commentIdx}&bidx=${dto.bidx}">삭제</a>
			     		</c:if>
			     		<c:if test="${fcommentList.userId ne loginId}">
				     		<c:if test="${loginId != 'guest' }"><button id="playerList"></button>
				     			<a href="#">신고</a>
				     		</c:if>	 
			     		</c:if>	     					
			     	</td>
			     </tr>
			</c:forEach>
		     
		     <tr>

			     <form method="post" action="freeboardcommentUpdate.do?">
					<th>
						<input type="hidden" name="commentIdx" value="${fcommentDto.commentIdx}">
						<input type="hidden" name="bidx" value="${dto.boardIdx}" style= "border:none;">
						<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
					</th>
					<c:if test="${loginId != 'guest' }">
						<th colspan="5">
							<input type="text" name="commentContent" value="${fcommentDto.commentContent}">
						</th>
						<th>
							<button>작성</button>
						</th>
					</c:if>
					<c:if test="${loginId == 'guest' }">
						<th colspan="6">
							<input type="text" name="commentContent" style= "border:none; width:400px;" placeholder="댓글 작성은 로그인 후 가능합니다. ">
						</th>     		
					</c:if>
				</form>  
		     </tr>
		</table>
</body>
<script>

</script>
</html>
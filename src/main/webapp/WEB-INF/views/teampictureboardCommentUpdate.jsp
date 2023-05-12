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
				<td>${dto.get(0).subject}</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${dto.get(0).userId}</td>
			</tr>
			<tr>
				<th>작성일</th>
				<td>${dto.get(0).writeTime}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${dto.get(0).content}</td>
			</tr>
			<c:if test= "${dto.get(0).photoName ne null}">
			<tr>
				<th>사진</th>
				<td><img width = "333" src="/photo/${dto.get(0).photoName}"/></td>
			</tr>
			</c:if>
			<tr>
				<th colspan="4">
					<input type = "button" onclick="location.href='./teampictureboardList.do'" value="리스트"/>
					<input type = "button" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./teampictureboardDelete.do?bidx=${dto.get(0).boardIdx}';}">
					<input type = "button" onclick="location.href='./teampictureboardUpdate.go?bidx=${dto.get(0).boardIdx}'" value="수정"/>				
					<input type = "button" value="신고"/>
				</th>
			</tr>
			<tr>
	     		<th colspan="7">
		     		<table>
			     		<c:forEach items="${tpcommentList}" var="tpcommentList">
			     			<tr>
			     				<th>${tpcommentList.userId} </th>
			     				<td >${tpcommentList.commentContent}</td>
			     				<td>${tpcommentList.commentWriteTime}</td>
			     				<td>
			     					<c:if test="${tpcommentList.userId eq loginId}">
			     						<a  href="teampictureboardcommentUpdate.go?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).boardIdx}" >수정</a> 
			     						/ 
			     						<a href="teampictureboardcommentDelete.do?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).boardIdx}">삭제</a>
			     					</c:if>
			     					<c:if test="${tpcommentList.userId ne loginId}">
			     						<a href="#">신고</a>
			     					</c:if>     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     	</th>	     	
		     </tr>
		     <tr>
			     <form method="post" action="teampictureboardcommentWrite.do?categoryId=b001&comentId=${dto.get(0).boardIdx}">
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
		     
		     <c:forEach items="${tpcommentList}" var="tpcommentList">
				<tr>
			    	<th>${tpcommentList.userId} </th>
			     	<td colspan="3">${tpcommentList.commentContent}</td>
			     	<td>${tpcommentList.commentWriteTime}</td>
			     	<td colspan="2">
			     		<c:if test="${tpcommentList.userId eq loginId}">
			     			<a  href="tpcommentUpdate.go?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).bidx}" >수정</a> 
			     			/ 
			     			<a href="tpcommentDelete.do?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).bidx}">삭제</a>
			     		</c:if>
			     		<c:if test="${tpcommentList.userId ne loginId}">
				     		<c:if test="${loginId != 'guest' }"><button id="playerList"></button>
				     			<a href="#">신고</a>
				     		</c:if>	 
			     		</c:if>	     					
			     	</td>
			     </tr>
			</c:forEach>
		     
		     <tr>

			     <form method="post" action="teampictureboardcommentUpdate.do?">
					<th>
						<input type="hidden" name="commentIdx" value="${tpcommentDto.commentIdx}">
						<input type="hidden" name="bidx" value="${dto.get(0).boardIdx}" style= "border:none;">
						<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
					</th>
					<c:if test="${loginId != 'guest' }">
						<th colspan="5">
							<input type="text" name="commentContent" value="${tpcommentDto.commentContent}">
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
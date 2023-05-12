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
         			<td>
            		<c:if test="${dto.size() == 0 }">
               			<div class="default">
                  			<span class="wrap">
                    			<img src="/photo/default.png">
                    		</span>
               			</div>
            		</c:if>
            <c:if test="${dto.size() > 0 }">
               <c:forEach items="${dto}" var="i">
                     <div class="container text-center d-flex flex-wrap">
                         <span class="wrap">
                             <img src="/photo/${i.photoName}" alt="test">
                         </span>
                     </div>
               </c:forEach>
            </c:if>
         </td>

			</tr>
			</c:if>
			<tr>
				<th colspan="4">
					<input type = "button" onclick="location.href='./teampictureboardList.do'" value="리스트"/>
					
					<c:if test="${dto.get(0).userId eq loginId }">
						<input type = "button" onclick="location.href='./teampictureboardUpdate.go?bidx=${dto.get(0).boardIdx}'" value="수정"/>				
						<input type = "button" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./teampictureboardDelete.do?bidx=${dto.get(0).boardIdx}';}">
					</c:if>
					
					<c:if test="${dto.get(1).userId ne loginId }">
						<button onclick="window.open('teampictureboardReport.go?bidx=${dto.get(1).boardIdx}','모집글 신고하기',)">신고</button>
					</c:if>
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
			     						<button onclick="window.open('teampictureboardCReport.go?commentIdx=${tpcommentList.commentIdx}','댓글 신고하기')">신고</button>			     			
			     					</c:if>     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     	</th>	     	
		     </tr>
		     <tr>
			     <form method="post" action="teampictureboardcommentWrite.do?categoryId=b011&comentId=${dto.get(0).boardIdx}">
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
		</table>
</body>
<script>

</script>
</html>
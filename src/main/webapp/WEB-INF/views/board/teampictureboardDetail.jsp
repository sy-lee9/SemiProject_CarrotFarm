<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
<script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

<style>

	.photo-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
	}

  .photo-item {
    width: 300px;
    height: 300px;
    margin: 10px;

	}

  .photo-item img {
    max-width: 100%;
    max-height: 100%;
	}
	
	
	
	body{
		position:relative;
		font-size:15px;
		padding : 10px;
	}	
	
	#content {
		width:82%;
		height : 85%;
		background-color: #f8f9fa;
		padding: 15 30 10;
		float:right;
	}
	
	#LNB {
		width:16%;
		height : 85%;
		background-color: #f8f9fa;
		float:left;
		margin : 0px 0px 5px 5px;
	}
	
	#LNB ul li {
	margin-top : 30px;
    margin-bottom: 40px; /* 원하는 줄간격 크기 */
	}

	
	th, td {
		margin : 10px;
		border : 1px solid black;	
		padding : 10px 10px;
		border-collapse : collapse;
		border-left: none;
    	border-right: none;
	}
	
	table{
		width:98%;
		height:60%;
		text-align:center;
		border : 3px solid black;	
		border-collapse : collapse;
		padding : 15px 10px;
	}
	
	#freeboardSearchInput{
		width: 200px;
    	height: 30px;
	}
	
	#freeboardSearchButton {
		height: 30px;
	}
</style>
</head>
<body>

	<%@ include file="../GNB.jsp" %>
	

	<div id="LNB">
		 <ul style="list-style-type: none;">
	      <li>
	        <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
	      </li>
	      
	      <li >
	        <a href="/cf/" style="font-weight: bold; font-size: 20px ; color: black;">팀소개</a>
	      </li>
	      
	      <li>
	        <a href="/cf/" style="font-weight: bold; font-size: 20px; color: black;">팀원</a>
	      </li>
	      
	      <li>
	        <a href="/cf/" style="font-weight: bold; font-size: 20px; color: black;">참여 경기</a>
	      </li>
	      
	      <li >
	        <a href="/cf/teamnoticeboardList.do?teamIdx=${teamIdx}" style="font-weight: bold; font-size: 20px ; color: black;">팀 공지 사항</a>
	      </li>
	      
	      <li>
	        <a href="/cf/teampictureboardList.do?teamIdx=${teamIdx}" style="font-weight: bold; font-size: 20px; color: orange;">팀 사진첩</a>
	      </li>
	      

	    </ul>
	</div>
	
	<div id="content">
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
            <c:if test="${dto.size() > 0}">
<div class="container text-center d-flex flex-wrap photo-container">
    <c:forEach items="${dto}" var="i">
      <div class="photo-item">
        <img src="/photo/${i.photoName}" alt="test">
      </div>
    </c:forEach>
  </div>
</c:if>
         </td>

			</tr>
			</c:if>
			<tr>
				<th colspan="111">
					<input type = "button" onclick="location.href='./teampictureboardList.do?teamIdx=${teamIdx}'" value="리스트"/>
					&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<c:if test="${dto.get(0).userId eq loginId }">
						<input type = "button" onclick="location.href='./teampictureboardUpdate.go?bidx=${dto.get(0).boardIdx}'" value="수정"/>				
						&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
						<input type = "button" value="삭제" onclick="if(confirm('정말로 삭제하시겠습니까?')){location.href='./teampictureboardDelete.do?bidx=${dto.get(0).boardIdx}';}">
					</c:if>
					
					<c:if test="${dto.get(0).userId ne loginId }">
						<button onclick="window.open('teampictureboardReport.go?bidx=${dto.get(0).boardIdx}','_blank','모집글 신고하기',)">신고</button>
					</c:if>
				</th>
			</tr>
			<tr>
	     		<th colspan="111">
		     		<table style="width: 100%;">
			     		<c:forEach items="${tpcommentList}" var="tpcommentList">
			     			<tr>
			     				<th style="width: 18%;">${tpcommentList.userId} </th>
			     				<td style="width: 47%;" >${tpcommentList.commentContent}</td>
			     				<td style="width: 18%;">${tpcommentList.commentWriteTime}</td>
			     				<td style="width: 17%;">
			     					<c:if test="${tpcommentList.userId eq loginId}">
			     						<a  href="teampictureboardcommentUpdate.go?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).boardIdx}" >수정</a> 
			     						/ 
			     						<a href="teampictureboardcommentDelete.do?commentIdx=${tpcommentList.commentIdx}&bidx=${dto.get(0).boardIdx}">삭제</a>
			     					</c:if>
			     					<c:if test="${tpcommentList.userId ne loginId}">
			     						<button onclick="window.open('teampictureboardCReport.go?commentIdx=${tpcommentList.commentIdx}','_blank','댓글 신고하기')">신고</button>			     			
			     					</c:if>     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     	</th>	     	
		     </tr>
		     <tr>
		     	<c:if test="${loginId != null }">
			     <form method="post" action="teampictureboardcommentWrite.do?categoryId=b011&comentId=${dto.get(0).boardIdx}">
			     		<td>
			     			<input type="text" name="userId" value="${loginId}" style= "border:none; background-color: #f8f9fa ; text-align:center;" readonly;>
			     		</td>
			     
			     		<td colspan="111">
			     			<input type="text" name="commentContent" onclick="hideMessage()" onblur="showMessage()" oninput="limitText(this, 255)" placeholder="댓글을 입력하세요 (최대 255자)" style="width : 650px">
			     			&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
			     			<button>작성</button>
			     		</td>
			     </form> 
			     </c:if>
		     </tr>
		</table>
		</div>
</body>
<script>
function hideMessage() {
    var message = document.getElementById("message");
    if (message) {
        message.style.display = "none";
    }
}

function showMessage() {
    var commentContent = document.getElementsByName("commentContent")[0];
    var message = document.getElementById("message");
    if (commentContent.value.length == 0 && message) {
        message.style.display = "block";
    }
}

function limitText(element, maxLength) {
    if (element.value.length > maxLength) {
        element.value = element.value.slice(0, maxLength);
    }
}

</script>
</html>
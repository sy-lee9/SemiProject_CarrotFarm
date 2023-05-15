<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>

	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="./resources/js/twbsPagination.js" type="text/javascript"></script>
	
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
        font-size: 15px;
		text-align:center;
		
	}
	
	
	table, th, td{
		margin : 5px;
	}
	
	table{
		width:90%;
		height:70%;
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
		 <div style="width: 200px; height: 200px; border : 1px solid black; border-collapse: collapse;  margin: auto;">프로필</div>
	      <br/><br/>
	    <a href="/cf/matching/list.do">개인 모집글</a> 
	      <br/><br/>
	    <a href="/cf/matching/teamList.do" >팀 모집글</a>
	    
	</div>
	
	
	<div id="content">
	<br/>
		<ul class="nav nav-tabs">
		  <li class="nav-item">
		    <a class="nav-link active" href="/cf/userNoticeAlarm">공지사항</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link " href="/cf/userGameAlarm">경기알림</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" href="/cf/userWarningAlarm">경고알림</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" href="/cf/userTeamAlarm">팀 알림</a>
		  </li>
		</ul>
		<!-- </br>
		<h2 style="margin:10px;">경기 알림</h2>
		<hr/> -->
		<table>
			<thead>
					<tr>
						<th style="width:20%;">No</th>
						<th style="width:80%;">공지사항</th>
					</tr>
				</thead>
				<tr>
					<th colspan="3"> <hr/> </th>
				</tr>
				<tbody>
				
				
				<tbody id="list">			
				
				<!-- list 출력 위치 -->
				
				</tbody>
				
				
				
				
				<tr>
				  <th colspan="3" id="paging" style="text-align:center;">  
				    <div class="container" >    
				    <hr/>              
				      <nav aria-label="Page navigation">
				        <ul class="pagination justify-content-center" id="pagination"></ul>
				      </nav>
				    </div>
				  </th>
				</tr>
	
	
	
				
			</tbody>		
			
			
		</table>
	
	</div>
</body>
<script>
	
	
var showPage = 1;
var userId = '${loginId}';
console.log(userId);
listCall(showPage);

function listCall(page){
   $.ajax({
      type:'post',
      url:'userNoticeAlarm.ajax',
      data:{
    	  'page':page,
    	  'userId':userId
      },
      dataType:'json',           
      success:function(data){
         console.log(data);
         listPrint(data.list);
         
         $('#pagination').twbsPagination({
			startPage:1, // 시작 페이지
			totalPages:data.pages,// 총 페이지 수 
			visiblePages:5,// 보여줄 페이지
			onPageClick:function(event,page){ // 페이지 클릭시 동작되는 (콜백)함수
				console.log(page,showPage);
				if(page != showPage){
					showPage=page;
					listCall(page);
					
				}
			}
         });
      }
   });
}

function listPrint(list){
	var content ='';
	
	if(list.length==0){
		content +='<tr>';
		content +='<th colspan="3"> 확인할 알림이 없습니다. </th>';
		content +='</tr>';
	}else{
		list.forEach(function(item,idx){
		
		
		content +='<tr>';
		content +='<td>'+item.alarmIdx+'</td>';
		content +='<td> 공지 <a href="//noticeboardDetail.do?bidx='+item.alarmkind+'"> ['+item.subject+']</a></td>';
		content +='<td> 확인해주세요</td>';
		content +='</tr>';
		
	});
}
	
	
	$('#list').empty();
	$('#list').append(content);
} 
	

</script>
</html>
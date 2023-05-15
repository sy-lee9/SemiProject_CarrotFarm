<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
<script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script>
<style>
	b{
		color:red;
	}

	table{
		width:100%;
	}

	table, td, th{
		border : 3px solid orange;
		border-collapse : collapse;
		padding: 5px;
	}
	#paging{
		text-align: center;
	}
	
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
</style>
</head>
<body>

	<br><br/>
	<input type ="text" id="noticeboardSearchInput" placeholder="제목 또는 닉네임을 입력">
	<button id ="noticeboardSearchButton">검색</button>
	
	<br><br/>
	<button id="registerBtn" onclick="location.href='noticeboardWrite.go'">등록</button>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody id="list">
			
		</tbody>
		<tr>
			<td colspan="5" id="paging">	
				<div class="container">									
					<nav aria-label="Page navigation" style="text-align:center">
						<ul class="pagination" id="pagination"></ul>
					</nav>
				</div>
			</td>
		</tr>
	</table>
</body>
<script>

var searchText = 'default';
var showPage = 1;
listCall(showPage);

$('#noticeboardSearchButton').click(function(){
	searchText = $('#noticeboardSearchInput').val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});


$.ajax({
	type:'post',
	url:'nuserRight.ajax',
	data:{},
	dataType:'json',
	success:function(data){
		console.log(data);
		if (data != "1") {
			document.getElementById("registerBtn").style.display = "none";
		}
	},
	error:function(e){
		console.log(e);
	}
});

function listCall(page){
	$.ajax({
		type:'post',
		url:'nlist.ajax',
		data:{
			'page':page,
			'search':searchText
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			console.log(data.noticeboardList);
			listPrint(data.noticeboardList);
			
			$('#pagination').twbsPagination({
				startPage:data.currPage, 
				totalPages:data.pages, 
				visiblePages:5,
				onPageClick:function(event,page){
					console.log(page,showPage);
					if (page != showPage) {
						showPage = page;
						listCall(page);
					}
				}
			});		
		},
		error:function(e){
			console.log(e);
		}
	});
}

function listPrint(nalist){
	var content = '';

	nalist.forEach(function(item,idx){
		content +='<tr>';
		content +='<td>'+item.boardIdx+'</td>';
		content +='<td><a href="noticeboardDetail.do?bidx='+item.boardIdx+'">'+item.subject+'</a></td>';
		content +='<td>'+item.userId+'</td>';
		

		var date = new Date(item.writeTime);
		content +='<td>'+date.toLocaleDateString('ko-KR')+'</td>';
		content +='<td>'+item.bHit+'</td>';
		content +='<tr>';
	});
	$('#list').empty();
	$('#list').append(content);
}
</script>
</html>
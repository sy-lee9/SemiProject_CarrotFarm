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
</style>
</head>
<body>
	게시물 갯수 : 
	<select id="pagePerNum">
		<option value="10">10</option>
	</select>
	<button id="registerBtn" onclick="location.href='inquiryboardWrite.go'">등록</button>
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
$.ajax({
	type:'post',
	url:'iuserRight.ajax',
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



var showPage = 1;
listCall(showPage);

$('#pagePerNum').change(function(){
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

function listCall(page){
	$.ajax({
		type:'post',
		url:'ilist.ajax',
		data:{
			'page':page,
			'cnt':$('#pagePerNum').val()	
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			console.log(data.inquiryboardList);
			listPrint(data.inquiryboardList);
			
			$('#pagination').twbsPagination({
				startPage:data.currPage, 
				totalPages:data.pages, 
				visiblePages:10,
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

function listPrint(ialist){
	var content = '';

	ialist.forEach(function(item,idx){
		content +='<tr>';
		content +='<td>'+item.boardIdx+'</td>';
		content +='<td><a href="inquiryboardDetail.do?bidx='+item.boardIdx+'">'+item.subject+'</a></td>';
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>  
<script src="resources/js/twbsPagination.js" type="text/javascript"></script>
<style>
	table, th, td{
      border : 1px solid black;
      border-collapse: collapse;
      padding : 5px 10px;
   }
</style>
</head>
<body>
	<table>
		<tr>
			<th>
				<a href="adminCourt">
					<h3>경기장 리스트</h3>
				</a>
			</th>
			<th>
				<a href="adminCourtTipOff">
					<h3>경기장 제보</h3>
				</a>
			</th>
		</tr>
	</table>
	<button onclick="location.href='adminCourtRegist.go'">경기장 등록</button>
	<input id="searchCourt" type="text" name="searchCourt" placeholder="경기장 검색">
	<button id="searchButton">검색</button>
	<table>
		<tr>
			<th>경기장 이름</th>
			<th>경기장 위치</th>
			<th>사용 여부</th>
			<th>실/내외</th>
			<th>등록/삭제</th>
			<th>수정</th>
			<th>삭제</th>			
		</tr>
	<tbody id="courtList">
		
	</tbody>
	</table>
	<table>
		<tr>
				<td colspan="6" id="paging">	
					<!-- 	플러그인 사용	(twbsPagination)	-->
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
var adminRight="${sessionScope.adminRight}";
console.log("왜 안될까요?? "+adminRight);
if(adminRight==''){
	location.href="/cf/";
}
var showPage = 1;
var courtSearch = 'default';
listCall(showPage);

//검색어에 따른 출력 
$('#searchButton').click(function(){
	//검색어 확인 
	courtSearch = $('#searchCourt').val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

function listCall(page){
	$.ajax({
		type:'post',
		url:'adminCourtPage.ajax',
		data:{
			'page':page,
			'courtSearch':courtSearch
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			console.log(data.courtListCnt);
			courtListDraw(data.courtList);
			//paging plugin
			$('#pagination').twbsPagination({
				startPage:1,	//시작페이지
				totalPages:Math.ceil(data.courtListCnt/10),//총 페이지 수
				visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
				onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
					console.log(page, showPage);
					if(page != showPage){
						showPage = page;
						listCall(showPage);
						
					}				
				}
			});	
			
		},
		error:function(e){
			console.log(e);
		}
	});
}
function courtListDraw(list){
	var content = '';
	$('#courtList').empty();
	list.forEach(function(item,index){
		console.log(item.courtDelete);
		content += '<tr>';
		content += '<th>'+item.courtName+'</th>';
		content+='<th>'+item.courtAddress+'</th>';
		content+='<th>'+item.courtState+'</th>';
		if(item.courtInOut=='out'){
			content +='<th>실외</th>';
		}else{
			content +='<th>실내</th>';
		}
		if(item.courtDelete=='1'){
			content +='<th>등록</th>';
			content +='<th><button onclick=location.href="adminCourtUpdate.go?courtIdx='+item.courtIdx+'">수정</button></th>';
			content +='<th><button onclick=location.href="adminCourtDelete.do?courtIdx='+item.courtIdx+'">삭제</button></th>';
		}else{
			content +='<th>삭제</th>';
			content +='<th><button onclick=location.href="adminCourtReRegist.do?courtIdx='+item.courtIdx+'">재등록</button></th>';
			content +='<th>삭제불가</th>';
		}
	});
	
	$('#courtList').append(content);
}



</script>
</html>
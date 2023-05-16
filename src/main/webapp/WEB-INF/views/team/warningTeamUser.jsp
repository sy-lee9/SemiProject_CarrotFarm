<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="../resources/js/twbsPagination.js" type="text/javascript"></script>

	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>	
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	th,td{
		text-align: center;
	}
	table{
		width: 800;
		height: 500;
	}
</style>
</head>
<body>

	<input type="text" id="searchInput" placeholder="아이디 검색">
	<button id="searchButton">검색</button>
	&nbsp;&nbsp;
	<hr>
	<table>
		<colgroup>
			<col width="20%"/>
			<col width="20%"/>
			<col width="10%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th>직급</th>
				<th>아이디</th>
				<th>경고</th>
				<th>경고취소</th>
				<th>경고횟수</th>
				<th>강퇴</th>
			</tr>
		</thead>
		<tbody id="list">
			<!-- list 출력 영역 -->
		</tbody>
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
	var showPage = 1;
	var searchText = 'default';
	var teamIdx = "${teamIdx}";
	listCall(showPage);

	// 검색어에 따른 출력 
	$('#searchButton').click(function(){
		//검색어 확인 
		searchText = $('#searchInput').val();
		console.log(searchText);
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});
		
	function listCall(page){
		$.ajax({
			type:'post',
			url:'warningList.ajax',
			data:{
				'page':page,
				'teamIdx':teamIdx,
				'searchText':searchText
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				listPrint(data.list);			
				
				//paging plugin
				$('#pagination').twbsPagination({
					startPage:1,	//시작페이지
					totalPages:data.pages,//총 페이지 수
					visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
					onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
						console.log(page, showPage);
						if(page != showPage){
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
	
	var loginId = $('#loginId').val();
	var teamGrade;
	console.log(loginId);
	
	function listPrint(list){
		var content = '';
		
		list.forEach(function(list){
			content +='<tr>';
			
			if(list.teamGrade == 'leader'){
				teamGrade = '팀장';
			}else if(list.teamGrade == 'deputyLeader'){
				teamGrade = '부팀장';
			}else if(list.teamGrade == 'temporaryLeader'){
				teamGrade = '임시팀장';
			}else{
				teamGrade = '팀원';
			}
			
			content +='<td>'+teamGrade+'</td>';
			content +='<td><a href="../userprofile.go?userId='+list.userId+'">'+list.userId+'</a></td>';
			content += '<td><button onclick="window.open(\'warning.go?userId='+list.userId+'&teamIdx='+teamIdx+'\',\'경고\',\'width=550px,height=530px\')">경고</button></td>';
			content += '<td><button onclick="window.open(\'warningCancel.go?userId='+list.userId+'&teamIdx='+teamIdx+'\',\'경고 취소\',\'width=550px,height=280px\')">취소</button></td>';
			content +='<td><a href="./warningDetail.go?userId='+list.userId+'&teamIdx='+teamIdx+'">'+list.warningCount+'</a></td>';
			
			if(list.warningCount >= 5){
				content += '<td><button onclick="window.open(\'remove.go?userId='+list.userId+'&teamIdx='+teamIdx+'\',\'강퇴\',\'width=550px,height=280px\')">강퇴</button></td>';
			}
			if(list.warningCount < 5){
				content += '<td><button disabled="true" onclick="window.open(\'remove.go?userId='+list.userId+'&teamIdx='+teamIdx+'\',\'강퇴\',\'width=550px,height=280px\')">강퇴</button></td>';
			}
			
			content +='</tr>';
		}); 
		$('#list').empty();
		$('#list').append(content);

	}
	

		

	
	var msg = "${msg}";
	console.log(msg);
	if(msg != ''){
		alert(msg);
	}

</script>
</html>
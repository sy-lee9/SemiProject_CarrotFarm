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
	신고 목록
	</hr>
	<select name="reportState" id="reportState">
		 <option value="default">신고상태</option>
         <option value="미처리">미처리</option>
         <option value="처리중">처리중</option>
         <option value="처리완료">처리완료</option>
      </select>
      
      <select name="category" id="category">
		 <option value="default">카테고리 종류</option>
         <option value="rm">모집글</option>
         <option value="rb">게시판</option>
         <option value="rc">댓글</option>
         <option value="ru">유저</option>
         <option value="rr">경기장 리뷰</option>
      </select>
      
      <select name="searchCategory" id="searchCategory">
		 <option value="default">검색조건</option>
         <option value="userId">신고자 아이디</option>
         <option value="reportUserId">대상자 아이디</option>
      </select>
      
    <input type="text" id="searchInput">
   	<button id="searchButton">검색</button>
	<table>
		<tr>
			<th>no</th>
			<th>신고자 ID</th>
			<th>신고 내용</th>
			<th>신고 대상자ID</th>
			<th>카테고리</th>
			<th>신고 상태</th>
		</tr>
		
		<tbody>
			
			
			<tbody id="list">			
			
			<!-- list 출력 위치 -->
			
			</tbody>
			
			<tr>
			  <th colspan="6" id="paging" style="text-align:center">  
			    <div class="container">                  
			      <nav aria-label="Page navigation">
			        <ul class="pagination justify-content-center" id="pagination"></ul>
			      </nav>
			    </div>
			  </th>
			</tr>
		</tbody>	
	
		</tbody>
	</table>
</body>
<script>
	var showPage = 1;
	var reportState = 'default';
	var category = 'default';
	var searchCategory = 'default';
	var searchText = 'default';
	
	//검색어에 따른 출력 
	$('#searchButton').click(function(){
		//검색어 확인 
		searchText = $('#searchInput').val();
		searchCategory= $('#searchCategory').val();
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});

	// 신고 상태
	$('#reportState').change(function(){
		reportState = $(this).val();
		searchText = 'default';
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});
	
	// 카테고리
	$('#category').change(function(){
		category = $(this).val();
		searchText = 'default';
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});

	listCall(showPage);
	function listCall(page){
		   $.ajax({
		      type:'post',
		      url:'adminReportList.ajax',
		      data:{
		    	  'page':page,
		    	  'category':category,
		    	  'searchText':searchText,
		    	  'searchCategory':searchCategory,
		    	  'reportState':reportState
		      },
		      dataType:'json',           
		      success:function(data){
		         console.log(data);
		         listPrint(data.list);
		         $('#pagination').twbsPagination({
					startPage:1, // 시작 페이지
					totalPages:Math.ceil(data.totalList/10),// 총 페이지 수 
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
		
		list.forEach(function(item,idx){
			
			
			content +='<tr>';
			content +='<td>'+item.reportIdx+'</td>';
			content +='<td>'+item.userId+'</td>';
			content +='<td><a href="adminReportDetail.go?reportIdx='+item.reportIdx+'&reportId='+item.reportId+'&categoryId='+item.categoryId+'&reportUserId='+item.reportUserId+'">'+item.reportContent+'</td>';                                           
			content +='<td>'+item.reportUserId+'</td>';
			if(item.categoryId=='rm'){
				content+='<td>모집글</td>';
			}else if(item.categoryId=='rb'){
				content+='<td>게시판</td>';
			}else if(item.categoryId=='rc'){
				content+='<td>댓글</td>';
			}else if(item.categoryId=='ru'){
				content+='<td>유저</td>';
			}else if(item.categoryId=='rr'){
				content+='<td>경기장 리뷰</td>';
			}
			content +='<td>'+item.reportState+'</td>';
			content +='</tr>';
				
			
		});
		$('#list').empty();
		$('#list').append(content);
	}
</script>
</html>
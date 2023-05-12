<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>  
<script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script>
<style>
	table, th, td{
      border : 1px solid black;
      border-collapse: collapse;
      padding : 5px 10px;
   }
</style>
</head>
<body>

<jsp:include page="../loginBox.jsp"></jsp:include>
	<select name="stateCategory" id="stateCategory">
		 <option value="default">회원상태</option>
         <option value="사용중">사용중</option>
         <option value="탈퇴">탈퇴</option>
         <option value="이용제한1일">이용제한(1일)</option>
         <option value="이용제한3일">이용제한(3일)</option>
         <option value="이용제한5일">이용제한(7일)</option>
         <option value="이용제한30일">이용제한(30일)</option>
         <option value="영구제한">영구제한</option>
      </select>
      
      <select name="searchCategory" id="searchCategory">
		 <option value="default">검색조건</option>
         <option value="userId">아이디</option>
         <option value="nickname">닉네임</option>
         <option value="email">이메일</option>
      </select>
      
    <input type="text" id="searchInput">
   	<button id="searchButton">검색</button>
	<table>
		<thead>
			<tr>
				<th><input type="checkbox" id="all"/></th>
				<th>NO</th>
				<th>회원분류</th>
				<th>아이디</th>
				<th>이름</th>
				<th>프로필</th>
				<th>닉네임</th>
				<th>이메일</th>
				<th>닉네임 변경</th>
				<th>사진 변경</th>
				<th>가입일</th>				
			</tr>
		</thead>
		<tbody>
			
			
			<tbody id="list">			
			
			<!-- list 출력 위치 -->
			
			</tbody>
			
			<tr>
			  <th colspan="11" id="paging" style="text-align:center">  
			    <div class="container">                  
			      <nav aria-label="Page navigation">
			        <ul class="pagination justify-content-center" id="pagination"></ul>
			      </nav>
			    </div>
			  </th>
			</tr>	
		</tbody>
	</table>
			
			
			



			
	<button onclick="nicknameChange()">닉네임 변경</button>
	<button onclick="profileChange()">프로필 변경</button>
	<button onclick="location.href='logout'">로그아웃</button>
	<button onclick="location.href='userdelete.go'">회원탈퇴</button>
	<button onclick="location.href='userinfo.go'">회원정보</button>
	<button onclick="location.href='mygames'">참여경기 리스트</button>
	<button onclick="location.href='userprofile.go?userId=${sessionScope.loginId}'">회원 프로필</button>
</body>
<script>

var showPage = 1;
var stateCategory = 'default';
var searchCategory = 'default';
var searchText = 'default';

listCall(showPage);

//검색어에 따른 출력 
$('#searchButton').click(function(){
	//검색어 확인 
	searchText = $('#searchInput').val();
	searchCategory = $('#searchCategory').val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

// 유저 상태 선택에 따른 출력
$('#stateCategory').change(function(){
	stateCategory = $(this).val();
	searchText="default";
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

function listCall(page){
   $.ajax({
      type:'post',
      url:'adminUserList.ajax',
      data:{
    	  'page':page,
    	  'stateCategory':stateCategory,
    	  'searchCategory':searchCategory,
    	  'searchText':searchText,
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
		content +='<td><input type="checkbox" value="'+item.userId+'"</td>';
		content +='<td>'+item.userIdx+'</td>';
		content +='<td>'+item.userState+'</td>';
		content +='<td><a href="userprofile.go?userId="'+item.userId+'"/>'+item.userId+'</td>';
		content +='<td>'+item.userName+'</td>';
		console.log(item.photoName);
		if(item.photoName==null){
			content+='<td>사진없음</td>';
		}else{
			content +='<td><img src="/photo/'+item.photoName+'" width="50px" alt="사진" /></td>';
			
		}
		content +='<td>'+item.nickname+'</td>';
		content +='<td>'+item.email+'</td>';
		content +='<td><button onclick=location.href="adminNicknameChange.do?userIdx='+item.userIdx+'&userId='+item.userId+'">닉네임 변경</button></td>';
		content +='<td><button onclick=location.href="adminprofileChange.do?userIdx='+item.userIdx+'&userId='+item.userId+'">프로필 변경</button></td>';
		content +='<td>'+item.userJoinDate+'</td>';
		content +='</tr>';
		
	});
	$('#list').empty();
	$('#list').append(content);
}

$('#all').click(function(e){
	var $chk = $('input[type="checkbox"]');
	if($(this).is(':checked')){
		$chk.prop('checked',true);
	}else{
		$chk.prop('checked',false);
	}
});

function nicknameChange(){
	var checkArr=[];
	$('input[type="checkbox"]:checked').each(function(idx,item){
		if($(this).val()!='on'){
			checkArr.push($(this).val());
		}
	});
	console.log(checkArr);
	$.ajax({
		type : 'get',
		url:'adminNicknamesChange.ajax',
		data:{
			'nickChangeList':checkArr
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			location.reload();
		},
		error:function(e){
			console.log(e);
		}
	});
}

function profileChange(){
	var checkArr=[];
	$('input[type="checkbox"]:checked').each(function(idx,item){
		if($(this).val()!='on'){
			checkArr.push($(this).val());
		}
	});
	console.log(checkArr);
	$.ajax({
		type : 'get',
		url:'adminProfilesChange.ajax',
		data:{
			'profileChangeList':checkArr
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			location.reload();
		},
		error:function(e){
			console.log(e);
		}
	});
}

var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
</html>
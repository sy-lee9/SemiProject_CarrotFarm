<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	
	table{
		width: 600px;
		height: 700px;
	}
	
	button{
		margin: 5px;
	}
	
	input[type="text"]{
		width: 100%;
	}
	
	textarea{
		width: 100%;
		height: 100%;
		resize: none;
	}
</style>
</head>
<body>
	<form action="teamRegist.do" method="post" enctype="multipart/form-data">
	<table>
		<thead>
			<colgroup>
				 <col width="30%"/>
				 <col width="70%"/>
			</colgroup>
		</thead>
		<tbody>
			<tr>
				<th>팀이름</th>
				<td>
					<input type="text" id="teamName" name="teamName"/>
					<span id="msg"></span>
				</td>
			</tr>
			<tr>
				<th>팀 프로필 사진</th>
				<td>
					<input type="file" name="teamProfilePhoto"/>
				</td>
			</tr>
			<tr>
				<th>주 활동지역</th>
				<td>
					<input type="text" id="location" readonly /> &nbsp;&nbsp;
					<input type="button" id="address_kakao" value="검색"/>
				</td>
			</tr>
			<tr>
				<th>주 활동시간</th>
				<td>
					<select name="teamFavTime">
				        <option value="평일/오전">평일/오전</option>
				        <option value="평일/오후">평일/오후</option>
				        <option value="평일/저녁">평일/저녁</option>
				        <option value="주말/오전">주말/오전</option>
				        <option value="주말/오후">주말/오후</option>
				        <option value="주말/저녁">주말/저녁</option>
				        <option value="상관없음">상관없음</option>
				    </select>
    			</td>
			</tr>
			<tr>
				<th>선호하는 경기종목</th>
				<td>
					<select name="teamFavNum">
				        <option value="3:3">3:3</option>
				        <option value="5:5">5:5</option>
				        <option value="상관없음">상관없음</option>
				    </select>
				</td>
			</tr>
			<tr>
				<th>소개글</th>
				<td>
					<textarea id="teamIntroduce" name="teamIntroduce"></textarea>
				</td>
			<tr>
				<th colspan="2">
					<button type="button" onclick="teamRegist()">팀 생성하기</button>
				</th>
			</tr>
		</tbody>
	</table>
	</form>
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

    document.getElementById("address_kakao").addEventListener("click", function(){ 
    	//주소검색 버튼을 클릭하면 카카오 지도 발생
        new daum.Postcode({
            oncomplete: function(data) { //선택시 입력값 세팅
                var sigungu = data.sigungu; // '구' 주소 넣기
                document.getElementById("location").value = sigungu;                
            }
        }).open();
    });
	
	var overlayChk = false;	
	
	function teamRegist(){
		if(overlayChk == true){
			if($('#teamName').val()==''){
				alert('팀이름을 입력해주세요!');
				$('#teamName').focus();
			}else if($('#teamIntroduce').val()==''){
				alert('팀 소개글을 입력해주세요!');
				$('#teamIntroduce').focus();
			}else if($('#location').val()==''){
				alert('주 활동지역을 입력해주세요!');
				$('#teamIntroduce').focus();
			}else{				
					$('button').attr('type','submit');				
			}
		}else{
			alert('이미 사용 중인 팀이름 입니다.');				
		}
	}

	
	$('#teamName').keyup(function(e){
		
		var teamName = $('#teamName').val();
		
		$.ajax({
			type:'post',
			url:'overlay.ajax',
			data:{
				teamName:teamName
			},
			dataType:'json',
			success:function(data){
				if(data.overlay == 0){
					console.log('사용 가능한 이름');
					$('#msg').css({'font-size':'8px', 'color':'darkgreen'});
					$('#msg').html('사용 가능한 팀이름 입니다.');
					overlayChk = true;
				}else{
					console.log('이미 사용 중인 이름');
					$('#msg').css({'font-size':'8px', 'color':'red'});
					$('#msg').html('이미 사용 중인 팀이름 입니다.');
				}						
			},
			error:function(e){
				console.log(e);
			}
		});
	});
	
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
	
	
	
	



</script>
</html>











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
	
	#location{
		width: 80%;
	}
	
	textarea{
		width: 100%;
		height: 100%;
		resize: none;
	}
</style>
</head>
<body>
	<form action="team/teamPageUpdate.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="teamIdx" value="${team.teamIdx}"/>
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
						<input type="text" id="teamName" name="teamName" value="${team.teamName}"/>
						<span id="msg"></span>
						<div hidden="true"><span id="count">0</span>/<span id="max-count">0</span></div>
					</td>
				</tr>
				<tr>
					<th>팀 프로필 사진</th>
					<td>
						<c:if test="${team.photoName eq null}">
							<input type="file" name="photo"/>
						</c:if>
						<c:if test="${team.photoName ne null}">
							<img src="/photo/${photoName}"/>
						</c:if>		
					</td>
				</tr>
				<tr>
					<th>주 활동지역</th>
					<td>
						<input type="text" id="location" name="location" value="${team.locationIdx}" readonly/> &nbsp;&nbsp;
						<input type="button" id="address_kakao" value="검색"/>
					</td>
				</tr>
				<tr>
					<th>주 활동시간</th>
					<td>
						<select id="teamFavTime" name="teamFavTime" value="${team.teamFavTime}">
					        <option id="평일/오전" value="평일/오전">평일/오전</option>
					        <option id="평일/오후" value="평일/오후">평일/오후</option>
					        <option id="평일/저녁" value="평일/저녁">평일/저녁</option>
					        <option id="주말/오전" value="주말/오전">주말/오전</option>
					        <option id="주말/오후" value="주말/오후">주말/오후</option>
					        <option id="주말/저녁" value="주말/저녁">주말/저녁</option>
					        <option id="상관없음" value="상관없음">상관없음</option>
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
						<textarea id="teamIntroduce" name="teamIntroduce" value="{team.teamIntroduce}" placeholder="팀소개글 및 구하는 포지션 등을 자유롭게 작성해주세요."></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	
	$('#teamFavTime').change(function(){
		var selectedTeamFavTime = '${team.teamFavTime}';
		// 선택한 요소 확인 okay
		console.log(selectedTeamFavTime);
		
		var teamFavTime = ['평일/오전','평일/오후','평일/저녁','주말/오전','주말/오후','주말/저녁','상관없음'];
		
		if (teamFavTime.indexOf(selectedTeamFavTime) !== -1){
			if (selectedTeamFavTime == teamFavTime) {
			    $('#teamFavTime').val('selectedTeamFavTime').prop('selected',true);
			  }
		}
	});




	document.getElementById('teamName').addEventListener('keyup',checkByte);
	var countSpan = document.getElementById('count');
	var message = '';
	var MAX_MESSAGE_BYTE = 20;
	document.getElementById('max-count').innerHTML = MAX_MESSAGE_BYTE.toString();
	
	function checkByte(event){
		const totalByte = count(event.target.value);
		
		if(totalByte <= MAX_MESSAGE_BYTE){
			countSpan.innerText = totalByte.toString();
			message = event.target.value;
		}else{
			alert("한글 10자, 영문 20자까지만 입력가능 합니다.")
			countSpan.innerText=count(message).toString();
			event.target.value = message;
		}
	}
	
	function count(message){
		var totalByte = 0;
		
		for(var i=0; i<message.length; i++){
			var currentByte = message.charCodeAt(i);
			(currentByte>128) ? totalByte += 2 : totalByte++;
		}
		return totalByte;
	}

    document.getElementById("address_kakao").addEventListener("click", function(){ 
    	//주소검색 버튼을 클릭하면 카카오 지도 발생
        new daum.Postcode({
            oncomplete: function(data) { //선택시 입력값 세팅
                var sigungu = data.sigungu; // '구' 주소 넣기
                document.getElementById("location").value = sigungu;
                console.log($('#location').val());
                console.log(sigungu);
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
			url:'overlayTeamName.ajax',
			data:{'teamName':teamName},
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











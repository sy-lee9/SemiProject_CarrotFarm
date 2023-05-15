<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
  <script>
    $(function() {
      $("#datepicker").datepicker();
    });
  </script>
<style>

</style>
</head>
<body>
	<h3>회원가입</h3>
	<form action="join.do" method="post" enctype="multipart/form-data">
	<table>
        <tr>
            <th>아이디</th>
            <td>
	            <input type="text" name="userId" id="userId"/>
	            <button id="idChk" type="button">중복 확인</button>
	        </td>
            <th>사진</th>
            <td>
            	<input type="file" name="userProfile"/>
            </td>
        </tr>
        <tr>
        	<td></td>
        	<td id="msg"></td>
            <td colspan="2">파일 용량 제한: 100MB / 가로,세로 제한 길이: 150px</td>
            <td></td>
        </tr>
        <tr>
            <th>닉네임</th>
            <td>
            	<input type="text" name="nickName" id="nickName"/>
            	<button id="nickChk" type="button">중복 확인</button><br>
            </td>
            <td id="nickMsg"></td>
            <td></td>
        </tr>
        <tr>
            <th>비밀번호</th>
            <td>
            	<input type="password" name="userPw" id="userPw"/>
            </td>
            <th>비밀번호 확인</th>
			<td>
				<input type="password" id="userPwChk"/>
				<span id="pwMsg"></span>
			</td>
        </tr>
        <tr>
        	<td></td>
        	<td>비밀번호는 8자리 이상, 영문과 숫자를 반드시 포함해야 합니다.(보류)</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
        	<th>키</th>
            <td><input type="text" name="height" id="height"/>cm</td>
            <th>이름</th>
            <td><input type="text" name="userName" id="userName"/></td>
        </tr>
        <tr>
        	<th>포지션</th>
            <td>
            	<select name="position" id="position">
            	 <option value="센터">센터</option>
		         <option value="포워드">포워드</option>
		         <option value="가드">가드</option>
		         <option value="무관">무관</option>
      			</select>
            </td>
            <th>생년월일</th>
            <td><input type="text" id="birthday" name="birthday" readonly="readonly" /></td>
        </tr>
        <tr>
        	<th>선호 경기 지역</th>
            <td>
            	<input type="text" id="location" name="location" readonly/>
            	<button type="button" id="address_kakao">검색</button>
            </td>
            <th>이메일</th>
            <td>
            	<input type="text" name="email" id="email"/>
            </td>
        </tr>
        <tr>
        	<th>선호 경기 시간</th>
            <td>
            	<select name="favTime" id="favTime">
            	 <option value="평일 오전">평일 오전</option>
		         <option value="평일 오후">평일 오후</option>
		         <option value="주말 오전">주말 오전</option>
		         <option value="주말 오후">주말 오후</option>
      			</select>
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
        	<td>
        		<button type="button" onclick="join()">회원가입</button>
        	<td>
        </tr>
        </table>
        </form>
        <button type="button" onclick="location.href='./'">돌아가기</button>
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

$(function() {
	  $("#birthday").datepicker({
	    dateFormat: "yy-mm-dd",
	    changeMonth: true,
	    changeYear: true,
	    yearRange: "-100:+0",
	    maxDate: new Date()
	  });
	});

var overlayChk = false;
var nickNameChk = false;



function join(){
   if(overlayChk && nickNameChk == true){
      if($('#userId').val()=='' || $('#userId').val().includes("admin")){
         alert('아이디을 입력해주세요!');
         $('#userId').focus();
      }else if($('#nickName').val()==''){
         alert('닉네임을 입력해주세요!');
         $('#nickName').focus();
      }else if($('#userPw').val()==''){
          alert('비밀번호을 입력해주세요!');
          $('#userPw').focus();
       }else if($('#userName').val()==''){
           alert('이름을 입력해주세요!');
           $('#userName').focus();
        }else if($('#email').val()==''){
            alert('이메일을 입력해주세요!');
            $('#email').focus();
         }else{
            $('button').attr('type','submit');
      }
   }else{
	   if(overlayChk == false){
		   alert('아이디 중복 확인 해주세요!');
	   }else if(nickNameChk == false){
		   alert('닉네임 중복 확인 해주세요!');
	   }
      
   }
}

$('#idChk').on('click',function(e){
	   
	   var userId = $('#userId').val();
	   
	   $.ajax({
	      type:'post',
	      url:'idChk.ajax',
	      data:{userId:userId},
	      dataType:'json',
	      success:function(data){
	         if(data.idChk == 0){
	            console.log('사용 가능한 아이디');
	            $('#msg').css({'font-size':'8px', 'color':'darkgreen'});
	            $('#msg').html('사용 가능한 아이디 입니다.');
	            overlayChk = true;
	         }else{
	            console.log('이미 사용 중인 아이디');
	            $('#msg').css({'font-size':'8px', 'color':'red'});
	            $('#msg').html('이미 사용 중인 아이디 입니다.');
	         }
	      },
	      error:function(e){
	         console.log(e);
	      }
	   });
	});




$('#nickChk').on('click',function(e){
	   
	   var nickName = $('#nickName').val();
	   
	   $.ajax({
	      type:'post',
	      url:'nickChk.ajax',
	      data:{nickName:nickName},
	      dataType:'json',
	      success:function(data){
	         if(data.nickChk == 0){
	            console.log('사용 가능한 닉네임');
	            $('#nickMsg').css({'font-size':'8px', 'color':'darkgreen'});
	            $('#nickMsg').html('사용 가능한 닉네임 입니다.');
	            nickNameChk = true;
	         }else{
	            console.log('이미 사용 중인 닉네임');
	            $('#nickMsg').css({'font-size':'8px', 'color':'red'});
	            $('#nickMsg').html('이미 사용 중인 닉네임 입니다.');
	         }
	      },
	      error:function(e){
	         console.log(e);
	      }
	   });
	});
	
$('#userPwChk').on('keyup',function(e){
	if($('#userPw').val() == $(this).val()){
		$('#pwMsg').css({'font-size': '8px', 'color': 'darkgreen'});
		$('#pwMsg').html('비밀번호가 일치 합니다.');
		pweq = true;
	}else{
		$('#pwMsg').css({'font-size': '8px', 'color': 'red'});
		$('#pwMsg').html('비밀번호가 일치 하지 않습니다.');
	}	
});

var msg = "${msg}";

if(msg != ""){
   alert(msg);
}

</script>
</html>
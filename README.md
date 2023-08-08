# 🏀당근농장(당신 근처의 농구장)
  
<br>

## 💬 프로젝트 설명

🏀 **당근농장**은 농구와 관련된 서비스를 한 곳에서 모두 가능하게 하여 농구에 대한 접근성을 높여주는 서비스입니다.

🗺️ **카카오 api**를 통해 사용자 주변의 농구장 정보를 불러오고 농구장에 대한 **리뷰**를 남길 수 있어 원하는 농구장을 편리하게 찾을 수 있도록 도와줍니다.

⛹️‍♂️ **농구팀**을 만들어 팀별활동을 할 수 있도록 지원하고 **개인 및 팀별 농구경기**를 개최하거나 참가할 수 있습니다.
  
<br>

<h3 style="border-bottom: 1px solid #d8dee4; color: #282d33;"> 💪 프로젝트 개발 기간 </h3> 
2023년 4월 10일 → 2023년 5월 18일
  
<br><br>

<h3 style="border-bottom: 1px solid #d8dee4; color: #282d33;"> 
🛠️ 개발 환경
</h3> 

|Web Back-End    |WEB Front-End                      |Others                |
|----------------|-------------------------------|-----------------------------|
|  <img src="https://img.shields.io/badge/Java(1.8)-3766AB?style=for-the-badge&logo=Java&logoColor=white"> <img src="https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=Spring&logoColor=white"> <img src="https://img.shields.io/badge/Mybatis-181717?style=for-the-badge&logo=Mybatis&logoColor=white">  |  <img src="https://img.shields.io/badge/Javascript-F7DF1E?style=for-the-badge&logo=Javascript&logoColor=white"> <img src="https://img.shields.io/badge/jsp-0769AD?style=for-the-badge&logo=jQuery&logoColor=white"><br> <img src="https://img.shields.io/badge/HTML-E34F26?style=for-the-badge&logo=HTML5&logoColor=white"> <img src="https://img.shields.io/badge/CSS-1572B6?style=for-the-badge&logo=CSS3&logoColor=white">  |  <img src="https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=MariaDB&logoColor=white"> <img src="https://img.shields.io/badge/Tomcat9.0-F8DC75?style=for-the-badge&logo=Apache Tomcat&logoColor=white"><br> <img src="https://img.shields.io/badge/Github-181717?style=for-the-badge&logo=Github&logoColor=white"> <img src="https://img.shields.io/badge/Sourcetree-0052CC?style=for-the-badge&logo=Sourcetree&logoColor=white"> |

<br>
  
### **🗿담당 기능**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
**[팀 페이지](https://github.com/sy-lee9/SemiProject_CarrotFarm/blob/master/src/main/java/kr/co/cf/team/controller/TeamController.java)**

- **팀 생성 및 해체 기능**
    - **File I/O**를 사용하여 팀 프로필 사진 게시 및 수정 가능
    - **Kakao 주소 API**를 활용하여 활동지역 저장
    - **AJAX**를 활용한 비동기식 팀이름 중복확인
- **팀 상세페이지**
- **팀원 리스트**
    - AJAX, \<select\>를 사용하여 비동기식 팀원 권한 변경
    - 가입일 순 리스트 출력 및 아이디로 검색 가능
    - 페이징 처리
- **팀 가입/취소 및 탈퇴 기능**
    - 가입신청은 중복으로 가능하나 하나의 팀에 가입될 경우 다른 팀 가입신청 자동 취소
- **팀 가입신청 응답 기능**
    - AJAX를 활용하여 신청내역 리스트에서 바로 수락/거절 가능
- **팀원 경고/강퇴 기능 및 경고 기록 리스트**
    - 경고/경고취소 기록 누적하여 경고 5회 시 강퇴 가능
    - 팀원 아이디로 검색 가능
    - 페이징 처리      
-  **참여 경기 리스트**
-  **참가 신청한 경기 정보 및 변경사항 리스트**
-  **모집 중인 경기 리스트**

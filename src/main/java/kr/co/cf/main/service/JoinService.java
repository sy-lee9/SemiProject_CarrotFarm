package kr.co.cf.main.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.mail.HtmlEmail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.co.cf.main.dao.JoinDAO;
import kr.co.cf.main.dto.JoinDTO;

@Service
public class JoinService {
	
	@Autowired JoinDAO dao;
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	public HashMap<String, Object> idChk(String userId) {
	      
	      HashMap<String, Object> map = new HashMap<String, Object>();
	      logger.info("service userId");
	      int idChk = dao.idChk(userId);
	      map.put("idChk", idChk);
	      return map;
	   }
	
	public HashMap<String, Object> nickChk(String nickName) {
	      
	      HashMap<String, Object> map = new HashMap<String, Object>();
	      logger.info("service nickName");
	      map.put("nickChk", dao.nickChk(nickName));

	      return map;
	   }
	
	
public String write(MultipartFile userProfile, HashMap<String, String> params) {
		logger.info("join service");
	    String msg = "회원가입에 실패하였습니다.";
	    int locationIdx = locationconf(params);
	    
	    int photoSave = 0;

		JoinDTO dto = new JoinDTO();
		dto.setUserId(params.get("userId"));
		dto.setNickName(params.get("nickName"));
		dto.setUserPw(params.get("userPw"));
		dto.setHeight((params.get("height")));
		dto.setUserName(params.get("userName"));
		dto.setPosition(params.get("position"));
		dto.setLocationIdx(locationIdx);
		Date birthday = Date.valueOf(params.get("birthday"));
		dto.setBirthday(birthday);
		dto.setEmail(params.get("email"));
		dto.setFavTime(params.get("favTime"));
		
		if(!userProfile.getOriginalFilename().equals("")) {
	         logger.info("파일 업로드 작업");
	         if(photoSave(userProfile,params) == 1) {
	            photoSave = 1;
	         }
	      }
		
		if(dao.join(dto) == 1) {
			dao.joinData(dto);
	         msg = "회원가입에 성공하였습니다.";
	      }
	      
	      return msg;
	   }

//사용자가 입력한 location의 idx를 받아오는 메서드
private int locationconf(HashMap<String, String> params) {
   String location = params.get("location");
   logger.info(location);
   
   int locationIdx = dao.locationFind(location);
   logger.info("locationIdx : "+locationIdx);
   return locationIdx;
}

private int photoSave(MultipartFile userProfile,HashMap<String, String> params) {
    int photoWrite = 0;
    
    // 1. 파일을 C:/img/upload/ 에 저장
          //1-1. 원본 이름 추출
          String oriFileName = userProfile.getOriginalFilename();
          //1-2. 새이름 생성
          String photoName = params.get("userId")+oriFileName;
          logger.info(photoName);
          try {
             byte[] bytes = userProfile.getBytes();//1-3. 바이트 추출
             //1-5. 추출한 바이트 저장
             Path path = Paths.get("C:/img/upload/"+photoName);
             Files.write(path, bytes);
             logger.info(photoName+" save OK");
             // 2. 저장 정보를 DB 에 저장
             //2-1. userProfile, photoName insert
             photoWrite = dao.photoWrite(photoName);
             logger.info("프로필 사진 업로드 여부: "+photoWrite);
                      
          } catch (IOException e) {
             e.printStackTrace();
          }
    return photoWrite;
 }

	public JoinDTO login(String id, String pw) {
		
		return dao.login(id,pw);
	}

	public ArrayList<JoinDTO> findId(String email)throws Exception{
		return dao.findId(email);
	}
	
	public int findIdCheck(String email)throws Exception{
		return dao.findIdCheck(email);
	}
	
	// 비밀번호 찾기
	public void sendEmail(@RequestParam HashMap<String, String> params, String div) throws Exception {
		// Mail Server 설정
		String charSet = "utf-8";
		String hostSMTP = "smtp.naver.com"; //네이버 이용시 smtp.naver.com / 구글 사용시 smtp.gmail.com
		String hostSMTPid = "jumpxhtna@naver.com";
		String hostSMTPpwd = "ehdgus~9256";

		// 보내는 사람 EMail, 제목, 내용
		String fromEmail = "jumpxhtna@naver.com";
		String fromName = "당근농장";
		String subject = "";
		String msg = "";

		if(div.equals("findpw")) {
			subject = "당근농장 임시 비밀번호 입니다.";
			msg += "<div align='center' style='border:1px solid black; font-family:verdana'>";
			msg += "<h3 style='color: orange;'>";
			msg += params.get("email") + "님의 임시 비밀번호 입니다. 비밀번호를 변경하여 사용하세요.</h3>";
			msg += "<p>임시 비밀번호 : ";
			msg += params.get("pw") + "</p></div>";
		}

		// 받는 사람 E-Mail 주소
		String mail = params.get("email");
		try {
			HtmlEmail email = new HtmlEmail();
			email.setDebug(true);
			email.setCharset(charSet);
			email.setSSL(true);
			email.setHostName(hostSMTP);
			email.setSmtpPort(587); //네이버 이용시 587 / 구글 이용시 465

			email.setAuthentication(hostSMTPid, hostSMTPpwd);
			email.setTLS(true);
			email.addTo(mail, charSet);
			email.setFrom(fromEmail, fromName, charSet);
			email.setSubject(subject);
			email.setHtmlMsg(msg);
			email.send();
		} catch (Exception e) {
			System.out.println("메일발송 실패 : " + e);
		}
	}
	
	// 임시 비밀번호
	public void findPw(@RequestParam HashMap<String, String> params) throws Exception {
		// 임시 비밀번호 생성
		
		String pw = "";
		for (int i = 0; i < 12; i++) {
			pw += (char) ((Math.random() * 26) + 97);
		}
		params.put("pw",pw);
		// 비밀번호 변경
		dao.updatePw(params);
		// 비밀번호 변경 메일 발송
		sendEmail(params, "findpw");
		
		
	}
	
	public int deleteuser(Object removeAttribute) {

	      return dao.userdelete(removeAttribute);
	   }

	   public int userdeletetrue(Object attribute) {

	      return dao.userdelete(attribute);
	   }
}

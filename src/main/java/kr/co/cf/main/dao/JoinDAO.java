package kr.co.cf.main.dao;

import org.springframework.beans.factory.annotation.Autowired;

import kr.co.cf.main.dto.JoinDTO;

public interface JoinDAO {

	int join(JoinDTO dto);
	
	int idChk(String userId);
	
	int nickChk(String nickName);

	int photoWrite(String photoName);

	int joinData(JoinDTO dto);

	int locationFind(String location);

	int login(String id, String pw);





}

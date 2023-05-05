package kr.co.cf.main.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import kr.co.cf.main.dto.JoinDTO;

public interface JoinDAO {

	int join(JoinDTO dto);
	
	int idChk(String userId);
	
	int nickChk(String nickName);

	int photoWrite(String photoName);

	int joinData(JoinDTO dto);

	int locationFind(String location);

	JoinDTO login(String id, String pw);

	ArrayList<JoinDTO> findId(String email);

	int findIdCheck(String eamil);

	int updatePw(HashMap<String, String> params);
	
	int userdelete(Object attribute);


}

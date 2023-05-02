package kr.co.cf.team.service;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.cf.team.dao.TeamDAO;
import kr.co.cf.team.dto.TeamDTO;

@Service
public class TeamService {
	
	@Autowired TeamDAO TeamDAO;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	public HashMap<String, Object> overlay(String teamName) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		logger.info("service teamName");
		map.put("overlay", TeamDAO.overlay(teamName));
		
		return map;
	}

	public String teamRegist(MultipartFile teamProfilePhoto, HashMap<String, String> params) {
		logger.info("teamRegist service");
		
		String msg = "팀생성에 실패하였습니다.";

		String location = params.get("location");
		logger.info(location);
/*		String[] address;
		address = location.split(" ");
		String si = address[1];
		String gu = address[2];
		String dong = address[3];
		logger.info(si+gu+dong);
*/	
		int teamFavNum;
		if(params.get("teamFavNum").equals("3:3")) {
			teamFavNum = 6;
		}else if(params.get("teamFavNum").equals("5:5")){
			teamFavNum = 10;
		}else {
			teamFavNum = 0;
		}
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamName(params.get("teamName"));
		TeamDTO.setTeamFavTime(params.get("teamFavTime"));
		TeamDTO.setTeamIntroduce(params.get("teamIntroduce"));
		TeamDTO.setTeamFavNum(teamFavNum);	
		TeamDTO.setTeamMatchState("모집중");
		TeamDTO.setTeamDisband(false);
		TeamDTO.setLocationIdx(1);
		
		if(TeamDAO.teamRegist(TeamDTO) == 1) {
			msg = "팀생성에 성공하였습니다.";
		}
		
		return msg;
	}
	
	
	
	
	
	
	
	
	
	
	
	

}

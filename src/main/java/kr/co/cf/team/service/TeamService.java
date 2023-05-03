package kr.co.cf.team.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
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
		//logger.info("service teamName");
		map.put("overlay", TeamDAO.overlay(teamName));
		
		return map;
	}

	public String teamRegist(MultipartFile teamProfilePhoto, HashMap<String, String> params) {
		logger.info("teamRegist service");
		
		String msg = "팀생성에 실패하였습니다.";

		int locationIdx = locationconf(params);
		int teamFavNum = teamFavNum(params); 
		int photoSave = 0;
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamName(params.get("teamName"));
		TeamDTO.setTeamFavTime(params.get("teamFavTime"));
		TeamDTO.setTeamIntroduce(params.get("teamIntroduce"));
		TeamDTO.setTeamFavNum(teamFavNum);	
		TeamDTO.setTeamManner(50);
		TeamDTO.setTeamMatchState("모집중");
		TeamDTO.setTeamDisband(false);
		TeamDTO.setLocationIdx(locationIdx);
		
		int teamIdx = 0;
		if(TeamDAO.teamRegist(TeamDTO) == 1) {
			teamIdx = TeamDTO.getTeamIdx();
			logger.info("teamIdx :"+teamIdx);
		}

		String page = "redirect:/team/detail.do?teamIdx="+teamIdx;
		
		if(!teamProfilePhoto.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			if(photoSave(teamProfilePhoto,teamIdx) == 1) {
				photoSave = 1;
			}
		}
		return page;
	}

	private int photoSave(MultipartFile teamProfilePhoto,int teamIdx) {
		int photoWrite = 0;
		
		// 1. 파일을 C:/carrot_farm/t01/ 에 저장
				//1-1. 원본 이름 추출
				String oriFileName = teamProfilePhoto.getOriginalFilename();
				//1-2. 새이름 생성
				String photoName = teamIdx+oriFileName;
				logger.info(photoName);
				try {
					byte[] bytes = teamProfilePhoto.getBytes();//1-3. 바이트 추출
					//1-5. 추출한 바이트 저장
					Path path = Paths.get("C:/carrot_farm/t01/"+photoName);
					Files.write(path, bytes);
					logger.info(photoName+" save OK");
					// 2. 저장 정보를 DB 에 저장
					//2-1. teamProfilePhoto, photoName insert
					photoWrite = TeamDAO.photoWrite(photoName,teamIdx);
					logger.info("프로필 사진 업로드 여부: "+photoWrite);
								
				} catch (IOException e) {
					e.printStackTrace();
				}
		return photoWrite;
	}

	//경기방식 데이터를 int로 바꾸는 메서드
	private int teamFavNum(HashMap<String, String> params) {
		int teamFavNum;
		if(params.get("teamFavNum").equals("3:3")) {
			teamFavNum = 6;
		}else if(params.get("teamFavNum").equals("5:5")){
			teamFavNum = 10;
		}else {
			teamFavNum = 0;
		}
		return teamFavNum;
	}

	//사용자가 입력한 location의 idx를 받아오는 메서드
	private int locationconf(HashMap<String, String> params) {
		String location = params.get("location");
		logger.info(location);
		
		int locationIdx = TeamDAO.locationFind(location);
		logger.info("locationIdx : "+locationIdx);
		return locationIdx;
	}

	public ArrayList<TeamDTO> list() {
		
		ArrayList<TeamDTO> list = TeamDAO.list();
		logger.info("service list size "+list.size());
		
		list.iterator();
		
/*		list.addAll(TeamDAO.teamProfilePhotoFind());
		logger.info("proPhoto add list size "+list.size());
*/		
		int teamUser = TeamDAO.userCount();
		logger.info("userCount : "+teamUser);
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamUser(teamUser);
		
		list.add(TeamDTO);
		logger.info("teamUser add list size :"+list.size());
		
		return list;
	}
	
	
	
	
	
	
	
	
	
	
	
	

}

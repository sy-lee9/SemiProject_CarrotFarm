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
		
		if(!teamProfilePhoto.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			photoSave(teamProfilePhoto,teamIdx);
			logger.info("파일 업로드 성공");
		}
		return "redirect:/team/teamPage.go?teamIdx="+teamIdx;
	}

	private void photoSave(MultipartFile teamProfilePhoto,int teamIdx) {
		
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
					TeamDAO.photoWrite(photoName,teamIdx);
					logger.info("photoName 저장완료");
								
				} catch (IOException e) {
					e.printStackTrace();
				}
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

	public HashMap<String, Object> list(int page, int cnt) {
		logger.info(page+" 페이지 보여줘");
		logger.info("한 페이지에 "+cnt+" 개씩 보여줄거야");
		HashMap<String, Object> map = new HashMap<String, Object>();		

		//총 페이지 수 
		int offset = (page-1)*cnt;
		
		// 만들 수 있는 총 페이지 수 
		// 전체 게시물 / 페이지당 보여줄 수
		int total = TeamDAO.totalCount();
		int range = total%cnt == 0 ? total/cnt : (total/cnt)+1;
		logger.info("전체 게시물 수 : "+total);
		logger.info("총 페이지 수 : "+range);
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
				
		ArrayList<TeamDTO> list = TeamDAO.list(cnt, offset);
		map.put("list", list);
		return map;
	}
/*
	public ArrayList<TeamDTO> checkMatchState(String checkMatchState) {
		HashMap<String, Object> map = new HashMap<String, Object>();		
		return TeamDAO.checkMatchState(checkMatchState);
	}
*/

	public TeamDTO teamInfo(int teamIdx) {
		return TeamDAO.teamInfo(teamIdx);
	}

	public ArrayList<TeamDTO> tagReview(int teamIdx) {
		return TeamDAO.tagReview(teamIdx);
	}

	public TeamDTO teamPageUpdate(String teamIdx) {		
		return TeamDAO.teamPageUpdate(teamIdx);
	}


	
	
	
	
	
	
	
	
	
	

}

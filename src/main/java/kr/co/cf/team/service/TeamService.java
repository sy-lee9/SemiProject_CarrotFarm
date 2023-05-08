package kr.co.cf.team.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
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
		int photoSave = 0;
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamName(params.get("teamName"));
		TeamDTO.setTeamFavTime(params.get("teamFavTime"));
		TeamDTO.setTeamIntroduce(params.get("teamIntroduce"));
		TeamDTO.setTeamFavNum(Integer.parseInt(params.get("teamFavNum")));	
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

	//사용자가 입력한 location의 idx를 받아오는 메서드
	private int locationconf(HashMap<String, String> params) {
		String location = params.get("location");
		logger.info(location);
		
		int locationIdx = TeamDAO.locationFind(location);
		logger.info("locationIdx : "+locationIdx);
		return locationIdx;
	}
	
	public HashMap<String, Object> gameList(HashMap<String, Object> params) { 
		
		int page = Integer.parseInt((String) params.get("page"));
		String selectedGameDate = String.valueOf(params.get("selectedGameDate"));
		String searchText = String.valueOf(params.get("searchText"));
		logger.info(page+" 페이지 보여줘");
		logger.info("한 페이지에 "+10+" 개씩 보여줄거야");
		
		HashMap<String, Object> map = new HashMap<String, Object>();		

		//총 페이지 수 
		int offset = (page-1)*10;
		
		// 만들 수 있는 총 페이지 수 
		// 전체 게시물 / 페이지당 보여줄 수
		int total = 0;
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(selectedGameDate.equals("default")) {
				// 전체 보여주기
				total = TeamDAO.totalCountGameList();
				logger.info("totalCountGameList :"+total);
			}else {				
				// 경기순을 선택한 경우
				if(selectedGameDate.equals("DESC")) {
					total = TeamDAO.totalCountGameDate("DESC");
				}else {
					total = TeamDAO.totalCountGameDate("ASC");
				}
				logger.info("totalCountGameDate :"+total);
			}		
		}else {
			// 검색어 입력한 경우
			total = TeamDAO.totalCountGameListSearch(params);		
			logger.info("totalCountGameListSearch :"+total);		
		}
		
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		logger.info("전체 게시물 수 : "+total);
		logger.info("총 페이지 수 : "+range);
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
				
		ArrayList<TeamDTO> list = null;		
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(selectedGameDate.equals("default")) {
				// 전체 보여주기
				list = TeamDAO.gameList(params);
				logger.info("gameList size : "+list.size());
			}else{
				// 경기순을 선택한 경우
				if(selectedGameDate.equals("DESC")) {
					list = TeamDAO.GameDateList("DESC");
				}else {
					list = TeamDAO.GameDateList("ASC");
				}
				logger.info("GameDateList size : "+list.size());
			}		
		}else {
			// 검색어 입력한 경우
			list = TeamDAO.SearchGameList(params);		
			logger.info("SearchGameList size : "+list.size());
		}
		
		map.put("list", list);
		return map;
	}

	public HashMap<String, Object> list(HashMap<String, Object> params) {
		
		int page = Integer.parseInt((String) params.get("page"));
		String matchState = String.valueOf(params.get("matchState"));
		String searchText = String.valueOf(params.get("searchText"));
		logger.info(page+" 페이지 보여줘");
		logger.info("한 페이지에 "+10+" 개씩 보여줄거야");
		
		HashMap<String, Object> map = new HashMap<String, Object>();		

		//총 페이지 수 
		int offset = (page-1)*10;
		
		// 만들 수 있는 총 페이지 수 
		// 전체 게시물 / 페이지당 보여줄 수
		int total = 0;
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(matchState.equals("default")) {
				// 전체 보여주기
				total = TeamDAO.totalCount();
				logger.info("totalCount :"+total);
			}else{
				// 모집상태를 선택한 경우
				total = TeamDAO.totalCountMatchState(params);
				logger.info("totalCountMatchState :"+total);
			}		
		}else {
			// 검색어 입력한 경우
			total = TeamDAO.totalCountSearch(params);		
			logger.info("totalCountSearch :"+total);		
		}
		
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		logger.info("전체 게시물 수 : "+total);
		logger.info("총 페이지 수 : "+range);
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
				
		ArrayList<TeamDTO> list = null;		
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(matchState.equals("default")) {
				// 전체 보여주기
				list = TeamDAO.list(params);
				logger.info("list size : "+list.size());
			}else{
				// 모집상태를 선택한 경우
				list = TeamDAO.MatchStateList(params);
				logger.info("MatchStateList size : "+list.size());
			}		
		}else {
			// 검색어 입력한 경우
			list = TeamDAO.SearchList(params);		
			logger.info("SearchList size : "+list.size());
		}
		
		map.put("list", list);
		return map;
	}

	public TeamDTO teamInfo(int teamIdx) {
		return TeamDAO.teamInfo(teamIdx);
	}

	public ArrayList<TeamDTO> tagReview(int teamIdx) {
		return TeamDAO.tagReview(teamIdx);
	}

	public TeamDTO updateForm(String teamIdx) {		
		return TeamDAO.updateForm(teamIdx);
	}

	public String teamPageUpdate(MultipartFile teamProfilePhoto, HashMap<String, String> params) {
		logger.info("service params : "+params);
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamIdx(Integer.parseInt(params.get("teamIdx")));
		TeamDTO.setTeamName(params.get("teamName"));
		TeamDTO.setTeamFavTime(params.get("teamFavTime"));
		TeamDTO.setTeamIntroduce(params.get("teamIntroduce"));
		TeamDTO.setTeamFavNum(Integer.parseInt(params.get("teamFavNum")));	
		TeamDTO.setLocationIdx(locationconf(params));		
		TeamDTO.setPhotoName(params.get("photoName")); 
		
		//팀 정보 수정
		int row = TeamDAO.teamPageUpdate(TeamDTO);
		logger.info("update row : "+row);
		
		int photoUpRow = 0;
		
		String photoName = params.get("teamName");
		int teamIdx = Integer.parseInt(params.get("teamIdx"));
		
		//팀 프로필 사진 업로드 및 변경
		if(photoName.equals("")) {
			logger.info("파일 업로드 작업");
			photoSave(teamProfilePhoto,teamIdx);
			logger.info("파일 업로드 성공");
		}else if(!photoName.equals("")){
			photoUpRow = photoUpdateSave(teamProfilePhoto,photoName,teamIdx);
			logger.info("photoUpRow row : "+photoUpRow);
			
			File file = new File("C:/carrot_farm/t01/"+photoName);
			if(file.exists()) {// 2. 해당 파일이 존재 하는지?
				file.delete();// 3. 삭제
			}	
		}
		String page = row>0 ? "redirect:/team/teamPage.go?teamIdx="+teamIdx : "redirect:/team";
		logger.info("update => "+page);
		
		return page;
	}

	private int photoUpdateSave(MultipartFile teamProfilePhoto,String photoName,int teamIdx) {
		int photoUpRow = 0;	
		
		
		// 1. 파일을 C:/carrot_farm/t01/ 에 저장
			//1-1. 원본 이름 추출
			String oriFileName = teamProfilePhoto.getOriginalFilename();
			//1-2. 새이름 생성
			String newPhotoName = teamIdx+oriFileName;
			logger.info(photoName);
			try {
				byte[] bytes = teamProfilePhoto.getBytes();//1-3. 바이트 추출
				//1-5. 추출한 바이트 저장
				Path path = Paths.get("C:/carrot_farm/t01/"+newPhotoName);
				Files.write(path, bytes);
				logger.info(newPhotoName+" save OK");
				// 2. 저장 정보를 DB 에 저장
				//2-1. teamProfilePhoto, newPhotoName insert
				
				
				photoUpRow = TeamDAO.teamProfilePhotoUpdate(newPhotoName,teamIdx);
				logger.info("photoName 저장완료");
							
			} catch (IOException e) {
				e.printStackTrace();
			}					
		return photoUpRow;
		}

	public int disband(int teamIdx) {		
		logger.info("disband teamIdx : "+teamIdx);
		return TeamDAO.disband(teamIdx);
	}

	public int disbandCancle(int teamIdx) {
		logger.info("disbandCancle teamIdx : "+teamIdx);
		return TeamDAO.disbandCancle(teamIdx);
	}

	public void disbandAlarm(String teamIdx) {
		
		ArrayList<TeamDTO> teamUserList = TeamDAO.getTeamUser(teamIdx);
		logger.info("teamUserList : "+teamUserList);
		
		int row = 0;
		
		for (int i = 0; i < teamUserList.size(); i++) {
			
			String userId = (teamUserList.get(i).getUserId());			
			logger.info("userID : "+userId);
			
			TeamDAO.disbandAlarm(userId);
			logger.info("알람전송 성공");
			row += 1;			
		}
		logger.info("sendAlarmCount : "+row);		
	}

	
	
	
	
	
	
	
	
	
	
	

}

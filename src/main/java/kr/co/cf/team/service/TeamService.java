package kr.co.cf.team.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

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
	
	// 팀 idx 가져오기
	public String getTeamIdx(String loginId) {
		return TeamDAO.getTeamIdx(loginId);
	}

	// 팀장, 부팀장 id 가져오기
	public ArrayList<TeamDTO> getTeamLeaders(int teamIdx) {
		return TeamDAO.getTeamLeaders(teamIdx);
	}

	// 팀장, 부팀장 권한 확인
	public int teamLeadersChk(int teamIdx, String loginId) {
		return TeamDAO.teamLeadersChk(teamIdx,loginId);
	}
	
	// 팀 가입여부 확인
	public int teamUserChk(String loginId) {
		return TeamDAO.teamUserCount(loginId);
	}
	
	// 팀장 id 가져오기
	public String getTeamLeader(int teamIdx) {
		return TeamDAO.getTeamLeader(teamIdx);
	}

	// 팀 가입여부 확인
	public int teamJoinChk(String loginId) {
		return TeamDAO.teamJoinChk(loginId);
	}

	// 강퇴회원 확인
	public int removeChk(int teamIdx, String loginId) {
		return TeamDAO.removeChk(teamIdx,loginId);
	}

	// 팀 이름 중복확인
	public HashMap<String, Object> overlay(String teamName) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("overlay", TeamDAO.overlay(teamName));
		
		return map;
	}

	//팀 생성
	public String teamRegist(MultipartFile teamProfilePhoto, HashMap<String, String> params, String loginId) {
		
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
		//팀 개설 
		if(TeamDAO.teamRegist(TeamDTO) == 1) {
			//방금 개설한 teamIdx 가져오기 
			teamIdx = TeamDTO.getTeamIdx();
			
			//팀 개설한 회원을 팀장으로 저장
			TeamDAO.addTeamLeader(teamIdx,loginId);

			//프로필 사진 저장
			if(!(teamProfilePhoto == null)) {
				photoSave(teamProfilePhoto,teamIdx);
			}
		}

		return "redirect:/team/teamPage.go?teamIdx="+teamIdx;
	}

	// 프로필 사진 등록
	private void photoSave(MultipartFile teamProfilePhoto,int teamIdx) {
		
		// 1. 파일을 C:/carrot_farm/t01/ 에 저장
				//1-1. 원본 이름 추출
				String oriFileName = teamProfilePhoto.getOriginalFilename();
				
				//1-2. 새이름 생성
				String photoName = teamIdx+oriFileName;
		
				try {
				//1-3. 바이트 추출
				byte[] bytes = teamProfilePhoto.getBytes(); 
					
				//1-4. 추출한 바이트 저장
				Path path = Paths.get("C:/img/upload/"+photoName);
				Files.write(path, bytes);
					
				} catch (IOException e) {
					e.printStackTrace();
				}
				//2. teamProfilePhoto, photoName insert DB에 저장
				TeamDAO.photoWrite(photoName,teamIdx);					
	}

	//사용자가 입력한 location의 idx를 받아오는 메서드
	private int locationconf(HashMap<String, String> params) {
		String location = params.get("location");		
		int locationIdx = TeamDAO.locationFind(location);
		return locationIdx;
	}

	//위치 리스트
	public ArrayList<TeamDTO> locationList() {
		return TeamDAO.locationList();
	}

	//팀 리스트
	public HashMap<String, Object> list(HashMap<String, Object> params) {

		//페이징 처리
		int page = Integer.parseInt((String) params.get("page"));
		String matchState = String.valueOf(params.get("matchState"));
		String searchText = String.valueOf(params.get("searchText"));
		
		HashMap<String, Object> map = new HashMap<String, Object>();	

		//한페이지에서 보여줄 게시물 수
		int offset = (page-1)*10;
		// 만들 수 있는 총 페이지 수 
		int total = 0;
		
		ArrayList<TeamDTO> list = null;		
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(matchState.equals("default")) {
				// 전체 보여주기
				list = TeamDAO.teamList(params);
			}else{
				// 모집상태를 선택한 경우
				list = TeamDAO.MatchStateList(params);
			}		
		}else {
			// 검색어 입력한 경우
			list = TeamDAO.SearchList(params);		
		}
		
		total = list.size();
		
		// 전체 게시물 / 페이지당 보여줄 수
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);

		map.put("list", list);
		return map;
	}

	// 팀 정보
	public TeamDTO teamInfo(int teamIdx) {
		TeamDTO TeamDTO = TeamDAO.teamInfo(teamIdx);
		
		int totalTeamManner = TeamDTO.getTeamManner();
		int teamUser = TeamDTO.getTeamUser();
		int teamManner = totalTeamManner/teamUser;
		
		TeamDTO.setTeamManner(teamManner);
		
		return TeamDTO;
	}

	// 팀 리뷰
	public ArrayList<TeamDTO> tagReview(int teamIdx) {
		return TeamDAO.tagReview(teamIdx);
	}

	// 팀 기존 정보 불러오기 
	public TeamDTO updateForm(String teamIdx) {		
		return TeamDAO.updateForm(teamIdx);
	}

	// 팀 정보 수정
	public String teamPageUpdate(MultipartFile teamProfilePhoto, HashMap<String, String> params) {
		
		TeamDTO TeamDTO = new TeamDTO();
		TeamDTO.setTeamIdx(Integer.parseInt(params.get("teamIdx")));
		TeamDTO.setTeamName(params.get("teamName"));
		TeamDTO.setTeamMatchState(params.get("teamMatchState"));
		TeamDTO.setTeamFavTime(params.get("teamFavTime"));
		TeamDTO.setTeamIntroduce(params.get("teamIntroduce"));
		TeamDTO.setTeamFavNum(Integer.parseInt(params.get("teamFavNum")));	
		TeamDTO.setLocationIdx(locationconf(params));		
		TeamDTO.setPhotoName(params.get("photoName")); 
		
		//팀 정보 수정
		int row = TeamDAO.teamPageUpdate(TeamDTO);
		
		int photoUpRow = 0;
		
		String photoName = params.get("teamName");
		int teamIdx = Integer.parseInt(params.get("teamIdx"));
		
		//팀 프로필 사진 업로드 및 변경
		if(photoName.equals("")) {
			photoSave(teamProfilePhoto,teamIdx);
		}else if(!photoName.equals("")){
			photoUpRow = photoUpdateSave(teamProfilePhoto,photoName,teamIdx);
			
			File file = new File("C:/carrot_farm/t01/"+photoName);
			if(file.exists()) {// 2. 해당 파일이 존재 하는지?
				file.delete();// 3. 삭제
			}	
		}
		String page = row>0 ? "redirect:/team/teamPage.go?teamIdx="+teamIdx : "redirect:/team";
		
		return page;
	}

	// 팀 프로필 사진 변경
	private int photoUpdateSave(MultipartFile teamProfilePhoto,String photoName,int teamIdx) {
		int photoUpRow = 0;	
		
		
		// 1. 파일을 C:/carrot_farm/t01/ 에 저장
			//1-1. 원본 이름 추출
			String oriFileName = teamProfilePhoto.getOriginalFilename();
		
			//1-2. 새이름 생성
			String newPhotoName = teamIdx+oriFileName;
			
			try {
				//1-3. 바이트 추출
				byte[] bytes = teamProfilePhoto.getBytes();
				
				//1-4. 추출한 바이트 저장
				Path path = Paths.get("C:/carrot_farm/t01/"+newPhotoName);
				Files.write(path, bytes);
				
				// 2. teamProfilePhoto, newPhotoName DB에 저장				
				photoUpRow = TeamDAO.teamProfilePhotoUpdate(newPhotoName,teamIdx);
							
			} catch (IOException e) {
				e.printStackTrace();
			}					
		return photoUpRow;
		}

	// 팀 해체
	public int disband(int teamIdx) {		
		return TeamDAO.disband(teamIdx);
	}
	
	// 팀 해체 취소
	public int disbandCancle(int teamIdx) {
		return TeamDAO.disbandCancle(teamIdx);
	}

	// 팀해체 알림 전송
	public void disbandAlarm(int teamIdx) {
		
		ArrayList<String> teamUserList = TeamDAO.getTeamUser(teamIdx);
		
		int row = 0;
		
		for (int i = 0; i < teamUserList.size(); i++) {
			
			String userId = (teamUserList.get(i));	
			
			TeamDAO.disbandAlarm(teamIdx,userId);
			row += 1;			
		}
		logger.info("sendAlarmCount : "+row);		
	}
	
	// 팀해체 취소 알림 전송
	public void disbandCancleAlarm(int teamIdx) {
		ArrayList<String> teamUserList = TeamDAO.getTeamUser(teamIdx);
		
		int row = 0;
		
		for (int i = 0; i < teamUserList.size(); i++) {
			
			String userId = (teamUserList.get(i));		
			
			TeamDAO.disbandCancleAlarm(teamIdx,userId);
			row += 1;			
		}
		logger.info("sendAlarmCount : "+row);			
	}

	// 참가한 경기 리스트
	public HashMap<String, Object> gameList(HashMap<String, Object> params) { 
		
		int page = Integer.parseInt((String) params.get("page"));
		String selectedGameDate = String.valueOf(params.get("selectedGameDate"));
		String searchText = String.valueOf(params.get("searchText"));
		
		int teamIdx = Integer.parseInt((String) params.get("teamIdx"));
		ArrayList<String> teamUserList = TeamDAO.getTeamUser(teamIdx);
		
		ArrayList<TeamDTO> list = new ArrayList<TeamDTO>();
		HashMap<String, Object> map = new HashMap<String, Object>();	

		//총 페이지 수 
		int offset = (page-1)*10;
		params.put("offset", offset);		
		
		if(teamUserList != null) {
				
				String userId = TeamDAO.getTeamLeader(teamIdx);	
				params.put("userId", userId);
				
				if(searchText.equals("default") || searchText.equals("")) {
					if(selectedGameDate.equals("default")) {
						// 전체 보여주기
							list = TeamDAO.gameList(params);											 
					}else{
						// 경기순을 선택한 경우
						if(selectedGameDate.equals("DESC")) {
								list = TeamDAO.GameDateListDesc(params);	
						}else {
							params.put("range", "ASC");
							list = TeamDAO.GameDateListAsc(params);	
						}
					}
				}else {
					// 검색어 입력한 경우
						list = TeamDAO.SearchGameList(params);		
				}
				
		}
		logger.info("list size : "+list.size());
		
		// 만들 수 있는 총 페이지 수 
		// 전체 게시물 / 페이지당 보여줄 수
		int total = list.size();
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		map.put("list", list);
		return map;
	}
	
	
	// 참가 신청한 경기 리스트
	public HashMap<String, Object> gameMatchingRequest(HashMap<String, Object> params) {
		String selectedGameDate = String.valueOf(params.get("selectedGameDate"));		

		int teamIdx = Integer.parseInt((String) params.get("teamIdx"));
		String leaderId = TeamDAO.getTeamLeader(teamIdx);
		params.put("userId", leaderId);
		
		ArrayList<TeamDTO> list = new ArrayList<TeamDTO>();
		HashMap<String, Object> map = new HashMap<String, Object>();		
		
		if(selectedGameDate.equals("default")) {
			// 전체 보여주기
			list = TeamDAO.matchingRequestList(leaderId);				
		}else{
			// 경기순을 선택한 경우
			if(selectedGameDate.equals("DESC")) {
					list = TeamDAO.matchingRequestListDesc(leaderId);	
			}else {
				params.put("range", "ASC");
				list = TeamDAO.matchingRequestListAsc(leaderId);				
			}
		}	
		map.put("list", list);
		return map;
	}

	
	//신청한 경기 변경사항 알림
	public ArrayList<TeamDTO> appGameUpdateAlarm(String teamIdx) {		
		String userId = TeamDAO.getTeamLeader(Integer.parseInt(teamIdx));		
		return TeamDAO.appGameUpdateAlarm(userId);
	}

	
	// 경기 초대 알림
	public ArrayList<TeamDTO> matchingInviteAlarm(String teamIdx) {
		String userId = TeamDAO.getTeamLeader(Integer.parseInt(teamIdx));		
		return TeamDAO.matchingInviteAlarm(userId);
	}

	
	// 경기참가 신청 알림
	public ArrayList<TeamDTO> gameMatchingAppAlarm(String teamIdx) {

		String userId = TeamDAO.getTeamLeader(Integer.parseInt(teamIdx));
		
		ArrayList<TeamDTO> list = TeamDAO.gameMatchingAppAlarm(userId);
		
		for (int i = 0; i < list.size(); i++) {
			int totalManner = list.get(i).getTeamManner();
			int teamUserNum = list.get(i).getTeamUser();
			int teamManner = totalManner/teamUserNum;
			
			list.get(i).setTeamManner(teamManner);
		}
		
		return list;
	}

	
	// 작성한 경기 모집글 리스트
	public ArrayList<TeamDTO> writeMatchingList(int teamIdx) {		
		String userId = TeamDAO.getTeamLeader(teamIdx);		
		ArrayList<TeamDTO> list = TeamDAO.writeMatchingList(userId);
		return list;
	}

	// 팀 가입 신청
	public int teamJoinApp(int teamIdx, String loginId) {
		return TeamDAO.teamJoinApp(teamIdx,loginId);
	}

	// 팀 가입신청 여부 확인
	public int joinAppChk(int teamIdx, String loginId) {
		return TeamDAO.joinAppChk(teamIdx,loginId);
	}

	// 가입 취소
	public void joinCancel(int teamIdx, String loginId) {
		TeamDAO.joinAppCancel(teamIdx,loginId);
	}

	// 팀 가입 신청자 리스트
	public HashMap<String, Object> teamJoinAppList(int teamIdx) {		
		HashMap<String, Object> map = new HashMap<String, Object>();	
		
		ArrayList<TeamDTO> list = TeamDAO.teamJoinAppList(teamIdx);		
		map.put("list", list);
		
		return map;
	}

	// 팀 가입 수락
	public HashMap<String, Object> teamJoinAccept(int teamIdx, String userId) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();  
		
		if(TeamDAO.teamJoinAccept(teamIdx,userId) == 1) {			
			if(TeamDAO.teamAppDel(userId) == 1) {
				map.put("data","수락완료");
			}
		}
		return map;
	}

	// 팀 가입 거절
	public HashMap<String, Object> teamJoinReject(int teamIdx, String userId) {
		HashMap<String, Object> map = new HashMap<String, Object>();  
		
		if(TeamDAO.teamJoinReject(teamIdx,userId) == 1) {
			map.put("data","거절완료");
		}
		return map;
	}

	public int teamUserChk(int teamIdx, String userId) {
		return TeamDAO.teamUserChk(teamIdx, userId);
	}
	
	//팀 탈퇴(팀장권한 양도)
	public void teamGradeUpdate(int teamIdx, String userId) {
		TeamDAO.teamGradeUpdate(teamIdx, userId);
	}

	//팀 탈퇴
	public HashMap<String, Object> leaveTeam(int teamIdx, String userId) {		
		HashMap<String, Object> map = new HashMap<String, Object>();  
		
		int row = TeamDAO.leaveTeam(teamIdx, userId);
		if(row == 1) {
			map.put("liveTeam", row);
		}
		
		return map;
	}

	
	// 팀원 리스트
	public HashMap<String, Object> teamUserList(HashMap<String, Object> params) {
		
		int page = Integer.parseInt((String) params.get("page"));
		String teamJoinDate = String.valueOf(params.get("teamJoinDate"));
		String searchText = String.valueOf(params.get("searchText"));
		HashMap<String, Object> map = new HashMap<String, Object>();		

		int offset = (page-1)*10;
		
		// 만들 수 있는 총 페이지 수 
		int total = 0;
		
		ArrayList<TeamDTO> list = new ArrayList<TeamDTO>();
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(teamJoinDate.equals("default")) {
				// 전체 보여주기
				list.addAll(TeamDAO.teamUserListMy(params));
				list.addAll(TeamDAO.teamLeaderList(params));
				list.addAll(TeamDAO.teamUserList(params));
			}else{
				// 경기순을 선택한 경우
				if(teamJoinDate.equals("DESC")) { //최신순
						list = TeamDAO.teamUserListDesc(params);
				}else { //오래된 순
					list = TeamDAO.teamUserListAsc(params);
				}
			}
		}else {
			// 검색어 입력한 경우
				list = TeamDAO.teamUserListSearch(params);		
		}
		
		total = list.size();
		
		// 전체 게시물 / 페이지당 보여줄 수
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		map.put("list", list);
		
		return map;
	}

	
	// 팀원 리스트(팀장용)
	public HashMap<String, Object> teamUserListLeader(HashMap<String, Object> params) {
		
		int page = Integer.parseInt((String) params.get("page"));
		String teamJoinDate = String.valueOf(params.get("teamJoinDate"));
		String searchText = String.valueOf(params.get("searchText"));
		
		HashMap<String, Object> map = new HashMap<String, Object>();		

		int offset = (page-1)*10;
		
		//총 페이지 수 
		int total = 0;
		
		ArrayList<TeamDTO> list = new ArrayList<TeamDTO>();
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			if(teamJoinDate.equals("default")) {
				// 전체 보여주기
				list.addAll(TeamDAO.teamLeaderList(params));
				list.addAll(TeamDAO.teamUserList(params));
				logger.info("teamUserList size : "+list);	
			}else{
				// 경기순을 선택한 경우
				if(teamJoinDate.equals("DESC")) {//최신순
						list = TeamDAO.teamUserListDesc(params);
						logger.info("최신순 size : "+list.size());	
				}else {//오래된 순
					list = TeamDAO.teamUserListAsc(params);
						logger.info("오래된순 size : "+list.size());	
				}
			}
		}else {
			// 검색어 입력한 경우
				list = TeamDAO.teamUserListSearch(params);		
				logger.info("teamUserListSearch size : "+list.size());
		}
		
		total = list.size();
		
		// 전체 게시물 / 페이지당 보여줄 수
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		map.put("list", list);
		
		return map;
	}

	
	// 팀장 권한 양도
	public HashMap<String, Object> changeTeamGrade(HashMap<String, Object> params) {
		HashMap<String, Object> map = new HashMap<String, Object>();	
		
		if(TeamDAO.changeTeamGrade(params) == 1) {
			map.put("data", 1);
		}
		
		return map;
	}

	
	// 팀원 경고 리스트
	public HashMap<String, Object> warningList(HashMap<String, Object> params) {
		
		int page = Integer.parseInt((String) params.get("page"));
		String searchText = String.valueOf(params.get("searchText"));
		
		HashMap<String, Object> map = new HashMap<String, Object>();		

		int offset = (page-1)*10;
		
		//총 페이지 수 
		int total = 0;
		
		ArrayList<TeamDTO> list = new ArrayList<TeamDTO>();
		params.put("offset", offset);
		
		if(searchText.equals("default") || searchText.equals("")) {
			list = TeamDAO.warningList(params);
		}else {
			// 검색어 입력한 경우
				list = TeamDAO.warningListSearch(params);		
		}
		
		total = list.size();
		
		// 전체 게시물 / 페이지당 보여줄 수
		int range = total%10 == 0 ? total/10 : (total/10)+1;
		
		page = page > range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		map.put("list", list);
		
		return map;
	}

	
	// 경고 부여
	public void warning(HashMap<String, Object> params) {
		int row = TeamDAO.warning(params);	
	}

	
	// 경고 취소
	public void warningCancel(HashMap<String, Object> params) {
		int row = TeamDAO.warningCancel(params);	
	}

	
	// 강퇴
	public int remove(HashMap<String, Object> params) {
		return TeamDAO.remove(params);
	}

	// 강퇴 알림 전송
	public void removeAlarm(HashMap<String, Object> params) {
		TeamDAO.removeAlarm(params);
	}

	// 경고 히스토리 
	public ArrayList<TeamDTO> warningHistory(int teamIdx, String userId) {
		return TeamDAO.warningHistory(teamIdx,userId);
	}

	// 즉시 강퇴 알림 전송
	public void removeNowAlarm(HashMap<String, Object> params) {
		TeamDAO.removeNowAlarm(params);
	}


}

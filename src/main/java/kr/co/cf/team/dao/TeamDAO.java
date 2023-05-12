package kr.co.cf.team.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.team.dto.TeamDTO;


public interface TeamDAO {

	int teamUserCount(String loginId);
	
	int overlay(String teamName);

	int teamRegist(TeamDTO teamDTO);

	int locationFind(String location);

	void addTeamLeader(int teamIdx, String loginId);
	
	void photoWrite(String photoName, int teamIdx);
	
	
	TeamDTO teamInfo(int teamIdx);

	ArrayList<TeamDTO> tagReview(int parseInt);
	
	ArrayList<TeamDTO> teamList(HashMap<String, Object> params);
	
	ArrayList<TeamDTO> MatchStateList(HashMap<String, Object> params);

	ArrayList<TeamDTO> SearchList(HashMap<String, Object> params);

	int totalCount();

	int totalCountMatchState(HashMap<String, Object> params);

	int totalCountSearch(HashMap<String, Object> params);
	
	//팀정보 수정
	TeamDTO updateForm(String teamIdx);
	
	int teamPageUpdate(TeamDTO teamDTO);

	int teamProfilePhotoUpdate(String newPhotoName, int teamIdx);
	
	//팀 해체
	int disband(int teamIdx);

	int disbandCancle(int teamIdx);

	ArrayList<TeamDTO> getTeamUser(String teamIdx);

	void disbandAlarm(String userId);
	
	//참가한 경기기록 보기
	ArrayList<TeamDTO> gameList(HashMap<String, Object> params);

	ArrayList<TeamDTO> GameDateList(HashMap<String, Object> params);

	ArrayList<TeamDTO> SearchGameList(HashMap<String, Object> params);

	ArrayList<TeamDTO> GameDateListDesc(HashMap<String, Object> params);

	ArrayList<TeamDTO> GameDateListAsc(HashMap<String, Object> params);
	
	//신청한 경기 모집글 확인
	ArrayList<TeamDTO> getTeamLeaders(String teamIdx);

	ArrayList<TeamDTO> matchingRequestList(String userId);

	ArrayList<TeamDTO> matchingRequestListDesc(String userId);

	ArrayList<TeamDTO> matchingRequestListAsc(String userId);
	
	//신청한 경기 모집글 변경사항 알림
	ArrayList<TeamDTO> gameAppAlarm(String teamIdx);

	int teamLeadersConf(String teamIdx, String loginId);
	
	//모집중인 경기 리스트 보기
	String getTeamLeader(String teamIdx);

	ArrayList<TeamDTO> writeMatchingList(String userId);
	
	//팀 가입 신청 및 취소
	int teamJoinChk(String loginId);

	int teamJoinApp(int teamIdx, String loginId);

	int joinAppChk(int teamIdx, String loginId);

	void joinAppCancel(int teamIdx, String loginId);
	
	//팀 가입 수락 및 거절
	ArrayList<TeamDTO> teamJoinAppList(int teamIdx);

	int teamJoinAccept(int teamIdx, String userId);

	int teamAppDel(String userId);

	int teamJoinReject(int teamIdx, String userId);
	
	//팀 탈퇴
	int teamUserChk(int teamIdx, String userId);

	int leaveTeam(int teamIdx, String userId);






	


	


}

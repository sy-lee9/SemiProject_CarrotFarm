package kr.co.cf.team.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.team.dto.TeamDTO;


public interface TeamDAO {

	int overlay(String teamName);

	int teamRegist(TeamDTO teamDTO);

	int locationFind(String location);

	void photoWrite(String photoName, int teamIdx);
	
	TeamDTO teamInfo(int parseInt);

	ArrayList<TeamDTO> tagReview(int parseInt);
	
	ArrayList<TeamDTO> list(HashMap<String, Object> params);
	
	ArrayList<TeamDTO> MatchStateList(HashMap<String, Object> params);

	ArrayList<TeamDTO> SearchList(HashMap<String, Object> params);

	int totalCount();

	int totalCountMatchState(HashMap<String, Object> params);

	int totalCountSearch(HashMap<String, Object> params);
	
	TeamDTO updateForm(String teamIdx);
	

	int teamPageUpdate(TeamDTO teamDTO);

	int teamProfilePhotoUpdate(String newPhotoName, int teamIdx);

	int disband(int teamIdx);

	int disbandCancle(int teamIdx);

	ArrayList<TeamDTO> getTeamUser(String teamIdx);

	void disbandAlarm(String userId);
	

	int totalCountGameList();

	int totalCountGameDate(String range);

	int totalCountGameListSearch(HashMap<String, Object> params);

	ArrayList<TeamDTO> gameList(HashMap<String, Object> params);

	ArrayList<TeamDTO> GameDateList(String string);

	ArrayList<TeamDTO> SearchGameList(HashMap<String, Object> params);


	


}

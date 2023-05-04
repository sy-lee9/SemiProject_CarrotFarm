package kr.co.cf.team.dao;

import java.util.ArrayList;

import kr.co.cf.team.dto.TeamDTO;


public interface TeamDAO {

	int overlay(String teamName);

	int teamRegist(TeamDTO teamDTO);

	int locationFind(String location);

	void photoWrite(String photoName, int teamIdx);

	ArrayList<TeamDTO> list(int cnt, int offset);

	int totalCount();
	
	TeamDTO teamInfo(int parseInt);

	ArrayList<TeamDTO> tagReview(int parseInt);

	TeamDTO teamPageUpdate(String teamIdx);


}

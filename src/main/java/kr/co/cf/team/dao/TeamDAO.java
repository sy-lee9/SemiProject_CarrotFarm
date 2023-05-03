package kr.co.cf.team.dao;

import java.util.ArrayList;

import kr.co.cf.team.dto.TeamDTO;

public interface TeamDAO {

	int overlay(String teamName);

	int teamRegist(TeamDTO teamDTO);

	int locationFind(String location);

	int photoWrite(String photoName, int teamIdx);

	ArrayList<TeamDTO> list();

	//ArrayList<TeamDTO> teamProfilePhotoFind();
	
	int userCount();

}

package kr.co.cf.team.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.team.dto.TeamBoardDTO;

public interface TeamBoardDAO {
	
	ArrayList<TeamBoardDTO> tplist();

	ArrayList<TeamBoardDTO> tpalist(int cnt, int offset);
	
	ArrayList<TeamBoardDTO> tpalistSearch(String search);
	
	int tpatotalCount();
	
	int tpatotalCountSearch(String search);
	
	int tpwrite(TeamBoardDTO dto);

	void tpfileWrite(int photoIdx, String photoId);

	void tpupHit(String boardIdx);

	ArrayList<TeamBoardDTO> tpdetail(String boardIdx);

	String tpfindFile(String bidx);

	int tpdelete(String bidx);

	int tpupdate(HashMap<String, String> params);
	

	ArrayList<TeamBoardDTO> tpcommentList(String bidx);

	void tpcommentWrite(HashMap<String, String> params);

	void tpcommentDelete(String commentIdx);

	TeamBoardDTO tpcommentGet(String commentIdx);

	void tpcommentUpdate(HashMap<String, String> params);
	
	void tpboardReport(HashMap<String, String> params);

	void tpboardCommentReport(HashMap<String, String> params);


}

package kr.co.cf.matching.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.matching.dto.MatchingDTO;

public interface MatchingDAO {

	

	MatchingDTO matchingDetail(String matchingIdx);

	void matchingWrite(MatchingDTO matchingDto);

	void game(MatchingDTO matchingDto);

	void upHit(String matchingIdx);

	void deleteGame(String matchingIdx);

	void deleteMatching(String matchingIdx);

	ArrayList<MatchingDTO> locationList();

	MatchingDTO matchingWriterData(String writerId);

	ArrayList<MatchingDTO> courtList();

	void matchingUpdate(HashMap<String, String> params);

	ArrayList<MatchingDTO> commentList(String matchingIdx);

	void commentWrite(HashMap<String, String> params);

	void commentDelete(String commentIdx);

	MatchingDTO commentGet(String commentIdx);

	void commentUpdate(HashMap<String, String> params);

	MatchingDTO userData(String loginId);
	
	// =========================================================
	// 모집글 페이징 관련 처리
	// =========================================================
	
	// 기본 
	int totalCount(String categoryId);
	
	// 게임 방식만 선택 된 경우 
	int totalCountGamePlay(HashMap<String, Object> params);
	
	// 선호 지역만 선택 된 경우
	int totalCountLocationIdx(HashMap<String, Object> params);
	
	// 게임 방식, 선호지역 모두 선택된 경우
	int totalCountAll(HashMap<String, Object> params);
	
	// 검색 기능
	int totalCountSearch(String categoryId, String search);
	
	// =========================================================
	
	// 기본
	ArrayList<MatchingDTO> list(int offset,String categoryId);

	// 게임 방식만 선택 된 경우 
	ArrayList<MatchingDTO> listGamePlay(HashMap<String, Object> params);

	// 선호 지역만 선택 된 경우
	ArrayList<MatchingDTO> listLocationIdx(HashMap<String, Object> params);

	// 게임 방식, 선호지역 모두 선택된 경구
	ArrayList<MatchingDTO> listAll(HashMap<String, Object> params);

	ArrayList<MatchingDTO> listSearch(HashMap<String, Object> params);

		

	


}

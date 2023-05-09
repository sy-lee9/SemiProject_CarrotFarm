package kr.co.cf.matching.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.matching.dto.MatchingDTO;

public interface MatchingDAO {

	

	MatchingDTO matchingDetail(String matchingIdx);

	void matchingWrite(MatchingDTO matchingDto);

	void game(MatchingDTO matchingDto);

	void upHit(String matchingIdx);
	
	//매칭글 삭제 전 알림
	void matchingDeleteAlarm(String userId, String matchingIdx);
	void deleteGame(String matchingIdx);
	void deleteMatching(String matchingIdx);
	

	ArrayList<MatchingDTO> locationList();

	MatchingDTO matchingWriterData(String writerId);

	ArrayList<MatchingDTO> courtList();

	// 매칭글 수정 이후 수정 관련 알림
	void matchingUpdate(HashMap<String, String> params);
	void matchingUpdateAlarm(HashMap<String, String> params);	

	
	
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
	
	
	
		

	// 게임신청
	int applyGameChk(String matchingIdx, String userId);
	void applyGame(String matchingIdx, String userId);
			
	// 모집 중 -> 모집 완료 상태 변경 
	void matchigStateToFinish(String matchingIdx, String matchigState);
	void matchigStateToFinishDelete(String matchingIdx);
	void matchigStateToFinishDeleteAlarm(String matchingIdx);
	
	void matchigStateToReview(String matchingIdx, String matchigState);
	
	ArrayList<MatchingDTO> playerList(String matchingIdx);

	void playerDelete(String matchingIdx, String userId);

	ArrayList<MatchingDTO> gameApplyList(String matchingIdx);

	void gameApplyAccept(String matchingIdx, String userId);
			
	void gameApplyReject(String matchingIdx, String userId);

	ArrayList<MatchingDTO> userList(String matchingIdx);

	void gameInvite(HashMap<String, Object> params);

	void cancelGameInvite(HashMap<String, Object> params);

	ArrayList<MatchingDTO> gameInviteList(String matchingIdx);

	void mvp(HashMap<String, Object> params);

	void mannerUp(HashMap<String, Object> params);

	void mannerDown(HashMap<String, Object> params);

	int review(String matchingIdx, String writerId);

	float mannerPoint(String loginId);

	int cntReview(String userId, String matchingIdx);

	void deleteAlarm(String matchingIdx);

	void gameInviteAlarm(HashMap<String, Object> params);

	void gameInviteCancelAlarm(HashMap<String, Object> params);

	void playerDeleteAlarm(String matchingIdx, String userId);

	void gameApplyAcceptAlarm(String matchingIdx, String userId);

	void gameApplyRejectAlarm(String matchingIdx, String userId);

	void matchingReport(HashMap<String, String> params);

	void commentReport(HashMap<String, String> params);

	void downHit(String matchingIdx);

	

	

	


	

	


}

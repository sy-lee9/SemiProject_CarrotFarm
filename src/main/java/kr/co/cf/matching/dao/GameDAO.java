package kr.co.cf.matching.dao;

import java.util.ArrayList;

import kr.co.cf.matching.dto.MatchingDTO;

public interface GameDAO {

	// 게임신청
		void applyGame(String matchingIdx, String userId);
			
		// 모집 중 -> 모집 완료 상태 변경
		void matchigStateUpdate(String matchingIdx, String matchigState);

		ArrayList<MatchingDTO> playerList(String matchingIdx);

		void playerDelete(String matchingIdx, String userId);

		ArrayList<MatchingDTO> gameApplyList(String matchingIdx);

		void gameApplyAccept(String matchingIdx, String userId);
			
		void gameApplyReject(String matchingIdx, String userId);
}

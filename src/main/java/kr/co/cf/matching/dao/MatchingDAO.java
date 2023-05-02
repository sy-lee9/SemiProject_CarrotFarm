package kr.co.cf.matching.dao;

import java.util.ArrayList;

import kr.co.cf.matching.dto.MatchingDTO;

public interface MatchingDAO {

	ArrayList<MatchingDTO> basicList();

	MatchingDTO matchingDetail(String matchingIdx);

	void matchingWrite(MatchingDTO matchingDto);

	void game(MatchingDTO matchingDto);

	void upHit(String matchingIdx);

	void deleteGame(String matchingIdx);

	void deleteMatching(String matchingIdx);


}

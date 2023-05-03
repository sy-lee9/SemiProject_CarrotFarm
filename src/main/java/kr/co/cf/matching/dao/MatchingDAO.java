package kr.co.cf.matching.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.matching.dto.MatchingDTO;

public interface MatchingDAO {

	ArrayList<MatchingDTO> basicList();

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


}

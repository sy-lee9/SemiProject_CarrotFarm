package kr.co.cf.matching.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.cf.matching.dao.MatchingDAO;
import kr.co.cf.matching.dto.MatchingDTO;

@Service
public class MatchingService {
	
	@Autowired MatchingDAO matchingDAO;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	public ArrayList<MatchingDTO> basicList() {
		
		return matchingDAO.basicList();
		
	}

	public MatchingDTO matchingDetail(String matchingIdx) {
		
		matchingDAO.upHit(matchingIdx);
		return matchingDAO.matchingDetail(matchingIdx);
	}

	public void matchingWrite(MatchingDTO matchingDto) {
		matchingDAO.matchingWrite(matchingDto);
		
	}

	public void game(MatchingDTO matchingDto) {
		matchingDAO.game(matchingDto);
		
	}

	public void delete(String matchingIdx) {
		// game 테이블의 matchingIdx가 일치하는 것을 먼저 삭제 후 matching 테이블에서도 삭제해야됨
		matchingDAO.deleteGame(matchingIdx);
		matchingDAO.deleteMatching(matchingIdx);
		
	}

	
}

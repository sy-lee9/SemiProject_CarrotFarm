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

	public ArrayList<MatchingDTO> locationList() {
		return matchingDAO.locationList();
	}

	public MatchingDTO matchingWriterData(String writerId) {
		
		return matchingDAO.matchingWriterData(writerId);
	}

	public ArrayList<MatchingDTO> courtList() {
		ArrayList<MatchingDTO> list = matchingDAO.courtList();
		logger.info("locationIdx : " + list.get(0).getLocationIdx());
		return matchingDAO.courtList();
	}

	public void matchingUpdate(HashMap<String, String> params) {
		
		matchingDAO.matchingUpdate(params);
	
	}

	public ArrayList<MatchingDTO> commentList(String matchingIdx) {
		return matchingDAO.commentList(matchingIdx);
	}

	public void commentWrite(HashMap<String, String> params) {
		matchingDAO.commentWrite(params);
	}

	public void commentDelete(String commentIdx) {
		matchingDAO.commentDelete(commentIdx);
	}

	public MatchingDTO commentGet(String commentIdx) {
		return matchingDAO.commentGet(commentIdx);
	}

	public void commentUpdate(HashMap<String, String> params) {
		matchingDAO.commentUpdate(params);
	}

	public HashMap<String, Object> list(HashMap<String, Object> params) {
		
		
		int page = Integer.parseInt(String.valueOf(params.get("page")));
		String gamePlay = String.valueOf(params.get("gamePlay"));
		String categoryId = String.valueOf(params.get("categoryId"));
		String locationIdx = String.valueOf(params.get("locationIdx"));
		String search = String.valueOf(params.get("search"));
		logger.info(page + "를 선택된 경기방식이" +gamePlay+"때만 보여줘");
		logger.info("한페이지에 " + 10 +"개씩 보여줄 것 ");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		// 1페이지  offset 0
		// 2페이지 offset 5
		// 3 페이지 offset 10
		int offset = 10*(page-1);
		
		logger.info("offset : " + offset);
		
		// 만들 수 있는 총 페이지 수 : 전체 게시글의 수 / 페이지당 보여줄 수 있는 수
		int total = 0;
		
		if(search.equals("default") ||search.equals("")) {
			if(gamePlay.equals("default") && locationIdx.equals("default")) {
			// 전체 보여주기
			total = matchingDAO.totalCount(categoryId);
			}else if(!(gamePlay.equals("default")) && locationIdx.equals("default")){
				
				// 게임 방식만 선택 된 경우 
				total = matchingDAO.totalCountGamePlay(params);
				
			}else if(gamePlay.equals("default") && !(locationIdx.equals("default"))){
				
				// 선호 지역만 선택 된 경우
				total = matchingDAO.totalCountLocationIdx(params);
				
			}else {
				// 게임 방식, 선호 지역 둘다 선택 된 경우 
				total = matchingDAO.totalCountAll(params);
			}
		}else {
			// 검색기능 작동
			total = matchingDAO.totalCountSearch(categoryId,search);
		}
		
		
		
		int range = total%10  == 0 ? total/10 : total/10+1;
		
		logger.info("총게시글 수 : "+ total);
		logger.info("총 페이지 수 : "+ range);
		
		page = page>range ? range:page;
		
		ArrayList<MatchingDTO> list = null;
		
		
		params.put("offset", offset);
		
		
		logger.info("params : " + params);
		if(search.equals("default") ||search.equals("")) {
			if(gamePlay.equals("default") && locationIdx.equals("default")) {
				// 전체 보여주기
				list = matchingDAO.list(offset,categoryId);
			}else if(!(gamePlay.equals("default")) && locationIdx.equals("default")) {
				// 게임 방식만 선택 된 경우 
				list = matchingDAO.listGamePlay(params);
			}
			
			else if(gamePlay.equals("default") && !(locationIdx.equals("default"))){
				// 선호 지역만 선택 된 경우
				list = matchingDAO.listLocationIdx(params);
			}else {
				// 경기 방식, 선호 지역 모두 선택
				list = matchingDAO.listAll(params);
			}
		}else {
			// 검색 기능
			list = matchingDAO.listSearch(params);
		}
		

		
		
		//logger.info("list size : "+ list.size());
		map.put("list", list);
		map.put("currPage", page);
		map.put("pages", range);
		
		return map;
	
	}

	public MatchingDTO userData(String loginId) {
		return matchingDAO.userData(loginId);
	}
	
	
	
	

	
}

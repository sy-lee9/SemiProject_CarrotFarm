package kr.co.cf.matching.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.cf.matching.dao.MatchingDAO;
import kr.co.cf.matching.dto.MatchingDTO;
import kr.co.cf.matching.service.MatchingService;

@Controller
public class MatchingController {

	@Autowired
	MatchingService matchingService;

	Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/matching/list.do")
	public String matchingList(Model model, HttpSession session) {

		logger.info("session" + session.getAttribute("loginId"));
		logger.info("모집글 리스트 불러오기");
		
		// 지역 리스트 가져오기
		ArrayList<MatchingDTO> locationList = new ArrayList<MatchingDTO>();
		locationList = matchingService.locationList();
		model.addAttribute("locationList", locationList);
		
		MatchingDTO userDto = new MatchingDTO();
		userDto = matchingService.userData((String)session.getAttribute("loginId"));
		return "/matching/matchingList";
	}
	
	@RequestMapping(value ="/matching/list.ajax")
	@ResponseBody
	public HashMap<String, Object> list(@RequestParam HashMap<String, Object> params) {
		logger.info("params : " + params);
		return matchingService.list(params);
	}
	

	@RequestMapping(value = "/matching/detail.go")
	public String matchingDetail(Model model, HttpSession session, @RequestParam String matchingIdx) {

		logger.info("모집글 matchingIdx : " + matchingIdx + "번 상세보기");

		// 모집글 내용
		MatchingDTO matchingDto = new MatchingDTO();
		matchingDto = matchingService.matchingDetail(matchingIdx);
		model.addAttribute("dto", matchingDto);

		// 해당 모집글의 댓글 불러 오기
		ArrayList<MatchingDTO> commentList = new ArrayList<MatchingDTO>();
		commentList = matchingService.commentList(matchingIdx);
		model.addAttribute("commentList", commentList);
		logger.info("모집글 commentList : " + commentList);
		return "/matching/matchingDetail";
	}

	@RequestMapping(value = "/matching/write.go")
	public String matchingWriteGo(@RequestParam String categoryId, Model model, HttpSession session) {

		logger.info("모집글 작성 categoryIdx : " + categoryId);

		// 로그인 정보 받아 와 작성자 저장
		logger.info("session" + session.getAttribute("loginId"));
		String writerId = (String) session.getAttribute("loginId");
		model.addAttribute("writerId", writerId);

		// 저장된 작성자아이디를 이용해 사용자의 등록된 선호 위치 저장
		MatchingDTO writerData = new MatchingDTO();
		writerData = matchingService.matchingWriterData(writerId);
		model.addAttribute("writerData", writerData);

		// 지역 리스트 가져오기
		ArrayList<MatchingDTO> locationList = new ArrayList<MatchingDTO>();
		locationList = matchingService.locationList();
		model.addAttribute("locationList", locationList);

		// 경기장 정보 가져오기
		ArrayList<MatchingDTO> courtList = new ArrayList<MatchingDTO>();
		courtList = matchingService.courtList();
		/*
		 * for (int i = 0; i < courtList.size(); i++) {
		 * logger.info("idx : "+courtList.get(i).getLocationIdx()); }
		 */
		logger.info("locationIdx : " + courtList);
		model.addAttribute("courtList", courtList);

		return "/matching/matchingWriteForm";
	}

	@RequestMapping(value = "/matching/write.do")
	public String matchingWrite(@RequestParam HashMap<String, String> params, HttpSession session) {

		logger.info("모집글 작성 정보 : " + params);

		MatchingDTO matchingDto = new MatchingDTO();
		matchingDto.setCategoryId(params.get("categoryId"));
		matchingDto.setContent(params.get("content"));
		matchingDto.setCourtIdx(Integer.parseInt(params.get("courtIdx")));
		matchingDto.setGameDate(params.get("gameDate"));

		matchingDto.setGamePlay(params.get("gamePlay"));
		matchingDto.setMatchingNum(Integer.parseInt(params.get("matchingNum")));
		matchingDto.setSubject(params.get("subject"));
		matchingDto.setWriterId(params.get("writerId"));

		matchingService.matchingWrite(matchingDto);

		matchingDto.setGameAppState("확정");

		matchingService.game(matchingDto);
		int matchingIdx = matchingDto.getMatchingIdx();

		return "redirect:/matching/detail.go?matchingIdx=" + matchingIdx;
	}

	@RequestMapping(value = "/matching/update.go")
	public String matchingUpdateGo(@RequestParam String matchingIdx, Model model) {

		logger.info(matchingIdx + "번 모집글 수정");

		MatchingDTO matchingDto = new MatchingDTO();

		matchingDto = matchingService.matchingDetail(matchingIdx);

		model.addAttribute("dto", matchingDto);

		return "/matching/matchingUpdateForm";
	}

	@RequestMapping(value = "/matching/update.do")
	public String matchingUpdate(@RequestParam HashMap<String, String> params) {

		logger.info("수정데이터" + params);

		matchingService.matchingUpdate(params);

		return "redirect:/matching/detail.go?matchingIdx=" + params.get("matchingIdx");
	}

	@RequestMapping(value = "/matching/delete.do")
	public String matchingDelete(@RequestParam String matchingIdx) {

		logger.info(matchingIdx + "번 모집글 삭제");

		// game 테이블의 matchingIdx가 일치하는 것을 먼저 삭제 후 matching 테이블에서도 삭제해야됨
		// 그러므로 추후 알람을 보내는 기능은 삭제 전에 해야함

		// game 테이블의 matchingIdx가 일치하는 user에게 알람 보내기

		// 삭제
		matchingService.delete(matchingIdx);

		return "redirect:/matching/list.do";
	}

	@RequestMapping(value = "/matching/commentWrite.do")
	public String commentWrite(@RequestParam HashMap<String, String> params) {

		logger.info("댓글 정보" + params);

		matchingService.commentWrite(params);
		return "redirect:/matching/detail.go?matchingIdx=" + params.get("comentId");
	}
	
	@RequestMapping(value = "/matching/commentDelete.do")
	public String commentDelete(@RequestParam String commentIdx,@RequestParam String matchingIdx) {

		logger.info("댓글 정보 commentIdx : " + commentIdx);
		matchingService.commentDelete(commentIdx);
		return "redirect:/matching/detail.go?matchingIdx=" + matchingIdx ;
	}
	
	@RequestMapping(value = "/matching/commentUpdate.go")
	public String commentUpdateGo(@RequestParam String commentIdx,@RequestParam String matchingIdx, Model model) {

		logger.info("댓글 정보 commentIdx : " + commentIdx);
		
		// 모집글 내용
		MatchingDTO matchingDto = new MatchingDTO();
		matchingDto = matchingService.matchingDetail(matchingIdx);
		model.addAttribute("dto", matchingDto);

		// 해당 모집글의 댓글 불러 오기
		ArrayList<MatchingDTO> commentList = new ArrayList<MatchingDTO>();
		commentList = matchingService.commentList(matchingIdx);
		model.addAttribute("commentList", commentList);
		logger.info("모집글 commentList : " + commentList);
		
		
		// 수정할 댓글 commentIdx
		MatchingDTO commentDto = new MatchingDTO();
		commentDto = matchingService.commentGet(commentIdx);
		logger.info("수정할 코멘트 내용"+commentDto.getCommentContent());
		model.addAttribute("commentDto", commentDto);
				
		return "/matching/matchingCommentUpdate" ;
	}
	
	@RequestMapping(value = "/matching/commentUpdate.do")
	public String commentUpdateGo(@RequestParam HashMap<String, String> params) {
		
		matchingService.commentUpdate(params);
		String matchingIdx = params.get("matchingIdx");
		logger.info("matchingIdx"+matchingIdx);		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx ;
	}
	
	@RequestMapping(value="/matching/applyGame")
	public String applyGame(@RequestParam String matchingIdx, HttpSession session) {
		
		String userId = (String)session.getAttribute("loginId");
		
		matchingService.applyGame(matchingIdx,userId);
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	
	//matchigStateUpdate?matchingIdx=${dto.matchingIdx}&matchigState=${dto.matchigState}
	
	@RequestMapping(value="/matching/matchigStateUpdate")
	public String matchigStateUpdate(@RequestParam String matchingIdx, @RequestParam String matchigState) {
		
		
		matchingService.matchigStateUpdate(matchingIdx,matchigState);
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	
}

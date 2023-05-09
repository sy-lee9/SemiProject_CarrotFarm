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
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		}
		
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
		
		if(session.getAttribute("loginId") == null) {logger.info("로그인된 아이디가 없습니다. ");}
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
		
		// 로그인 정보가 없을 시
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		}
		// 로그인 정보가 있을 시
		if(session.getAttribute("loginId") != null) {		
		// 해당 경기 참가자 정보
			ArrayList<MatchingDTO> playerList = new ArrayList<MatchingDTO>();
			playerList = matchingService.playerList(matchingIdx);
			model.addAttribute("playerList", playerList);
			
			
			// 해당 경기 신청자 목록
			ArrayList<MatchingDTO> gameApplyList = new ArrayList<MatchingDTO>();
			gameApplyList = matchingService.gameApplyList(matchingIdx);
			model.addAttribute("gameApplyList", gameApplyList);
			
			// 전체 회원 목록 (신청자 목록, 경기 참가자 목록에 있는 사람 제외)
			ArrayList<MatchingDTO> userList = new ArrayList<MatchingDTO>();
			userList = matchingService.userList(matchingIdx);
			model.addAttribute("userList", userList);
			
			// 해당 경기 초대 목록
			ArrayList<MatchingDTO> gameInviteList = new ArrayList<MatchingDTO>();
			gameInviteList = matchingService.gameInviteList(matchingIdx);
			model.addAttribute("gameInviteList", gameInviteList);
			
			// 리뷰 작성 여부 
			String review = "no";
			int num = matchingService.review(matchingIdx,(String)session.getAttribute("loginId"));
			if (num != 0) {
				review = "yes";
			}
			model.addAttribute("review", review);
			
			// 리뷰 작성 후 경기 mvp
			model.addAttribute("mvp", "mvp는 50% 이상의 투표를 받았을 때만 공개 됩니다.");
			int mvpChk = playerList.size()/2;
			logger.info("mvpChk : "+mvpChk);
			int cntReview = 0;
			
			//MVP 선정
			for (MatchingDTO dto : playerList) {
				logger.info("userId : "+dto.getUserId()+"matchingIdx : "+dto.getMatchingIdx());
				cntReview = matchingService.cntReview(dto.getUserId(),String.valueOf(dto.getMatchingIdx()));
				logger.info(dto.getUserId()+"의 투표수 : "+cntReview);
				if(cntReview>mvpChk) {
					model.addAttribute("mvp", dto.getUserId());
				}
			}
			
					
			// 리뷰 작성 후 개인 매너 점수
			float mannerPoint = matchingService.mannerPoint((String)session.getAttribute("loginId"));
			mannerPoint += 50;
			model.addAttribute("mannerPoint", mannerPoint);
		}
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
	public String matchingUpdateGo(@RequestParam String matchingIdx, Model model, HttpSession session) {

		logger.info(matchingIdx + "번 모집글 수정");


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
		
		// 수정할 글 정보
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
	public String matchingDelete(@RequestParam String matchingIdx, HttpSession session) {

		logger.info(matchingIdx + "번 모집글 삭제");
		String writerId = (String)session.getAttribute("loginId");
		logger.info("writerId" + writerId);
		matchingService.delete(matchingIdx,writerId);

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
	public String commentUpdateGo(@RequestParam String commentIdx,@RequestParam String matchingIdx, Model model, HttpSession session) {
		
		if(session.getAttribute("loginId") == null) {logger.info("로그인된 아이디가 없습니다. ");}
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
		
		
		// 로그인 정보가 없을 시
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		}
		// 로그인 정보가 있을 시
		if(session.getAttribute("loginId") != null) {		
		// 해당 경기 참가자 정보
			ArrayList<MatchingDTO> playerList = new ArrayList<MatchingDTO>();
			playerList = matchingService.playerList(matchingIdx);
			model.addAttribute("playerList", playerList);
			
			
			// 해당 경기 신청자 목록
			ArrayList<MatchingDTO> gameApplyList = new ArrayList<MatchingDTO>();
			gameApplyList = matchingService.gameApplyList(matchingIdx);
			model.addAttribute("gameApplyList", gameApplyList);
			
			// 전체 회원 목록 (신청자 목록, 경기 참가자 목록에 있는 사람 제외)
			ArrayList<MatchingDTO> userList = new ArrayList<MatchingDTO>();
			userList = matchingService.userList(matchingIdx);
			model.addAttribute("userList", userList);
			
			// 해당 경기 초대 목록
			ArrayList<MatchingDTO> gameInviteList = new ArrayList<MatchingDTO>();
			gameInviteList = matchingService.gameInviteList(matchingIdx);
			model.addAttribute("gameInviteList", gameInviteList);


			// 수정할 댓글 commentIdx
			MatchingDTO commentDto = new MatchingDTO();
			commentDto = matchingService.commentGet(commentIdx);
			logger.info("수정할 코멘트 내용"+commentDto.getCommentContent());
			model.addAttribute("commentDto", commentDto);

			
			// 리뷰 작성 여부 
			String review = "no";
			int num = matchingService.review(matchingIdx,(String)session.getAttribute("loginId"));
			if (num != 0) {
				review = "yes";
			}
			model.addAttribute("review", review);
			
			// 리뷰 작성 후 경기 mvp
			model.addAttribute("mvp", "mvp는 50% 이상의 투표를 받았을 때만 공개 됩니다.");
			int mvpChk = playerList.size()/2;
			logger.info("mvpChk : "+mvpChk);
			int cntReview = 0;
			
			//MVP 선정
			for (MatchingDTO dto : playerList) {
				logger.info("userId : "+dto.getUserId()+"matchingIdx : "+dto.getMatchingIdx());
				cntReview = matchingService.cntReview(dto.getUserId(),String.valueOf(dto.getMatchingIdx()));
				logger.info(dto.getUserId()+"의 투표수 : "+cntReview);
				if(cntReview>mvpChk) {
					model.addAttribute("mvp", dto.getUserId());
				}
			}
			
					
			// 리뷰 작성 후 개인 매너 점수 
			float mannerPoint = matchingService.mannerPoint((String)session.getAttribute("loginId"));
			mannerPoint += 50;
			model.addAttribute("mannerPoint", mannerPoint);


		}
					
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
	
	
	
	@RequestMapping(value="/matching/matchigStateUpdate")
	public String matchigStateUpdate(@RequestParam String matchingIdx, @RequestParam String matchigState) {
		
		if(matchigState.equals("matching")) {
			matchingService.matchigStateToFinish(matchingIdx,matchigState);
		}
		if(matchigState.equals("finish")) {
			matchingService.matchigStateToReview(matchingIdx,matchigState);
		}
		
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	@RequestMapping(value="/matching/playerDelete")
	public String playerDelete(@RequestParam String matchingIdx, @RequestParam String userId) {
		
		matchingService.playerDelete(matchingIdx,userId);
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	@RequestMapping(value="/matching/gameApplyAccept")
	public String gameApplyAccept(@RequestParam String matchingIdx, @RequestParam String userId) {
		
		matchingService.gameApplyAccept(matchingIdx,userId);
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	@RequestMapping(value="/matching/gameApplyReject")
	public String gameApplyReject(@RequestParam String matchingIdx, @RequestParam String userId) {
		
		matchingService.gameApplyReject(matchingIdx,userId);
		
		return "redirect:/matching/detail.go?matchingIdx="+matchingIdx;
	}
	
	
	@RequestMapping(value ="/matching/gameInvite.ajax")
	@ResponseBody
	public HashMap<String, Object> gameInvite(@RequestParam HashMap<String, Object> params) {
		logger.info("params : " + params);
		matchingService.gameInvite(params);
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("msg", "초대 성공");
		return data;
	}
	
	@RequestMapping(value ="/matching/cancelGameInvite.ajax")
	@ResponseBody
	public HashMap<String, Object> cancelGameInvite(@RequestParam HashMap<String, Object> params) {
		logger.info("params : " + params);
		matchingService.cancelGameInvite(params);
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("msg", "초대 취소 성공");
		return data;
	}
	
	@RequestMapping(value ="/matching/review")
	public String review(@RequestParam HashMap<String, Object> params, HttpSession session) {
		
		params.put("writerId", session.getAttribute("loginId"));
		logger.info("params : " + params);
		
		matchingService.mvp(params);
		
		for (String key : params.keySet()) {
		    if (key.startsWith("manner")) {
			if(params.get(key).toString().endsWith("_up")){
				String receiveId = params.get(key).toString().split("_")[0];
				params.put("receiveId", receiveId);
				logger.info("params : " + params);
				matchingService.mannerUp(params);
			}
		      if(params.get(key).toString().endsWith("_down")){
		    	  String receiveId = params.get(key).toString().split("_")[0];
		    	  params.put("receiveId", receiveId);
		    	  logger.info("params : " + params);
		    	  matchingService.mannerDown(params);
			}
		    }
		}
			
		return "redirect:/matching/detail.go?matchingIdx=" + params.get("matchingIdx");
	}
	
	
	@RequestMapping(value ="/matching/matchingReport.go")
	public String matchingReportGo(Model model,@RequestParam String matchingIdx, HttpSession session) {
		
		MatchingDTO dto = new MatchingDTO();
		dto.setMatchingIdx(Integer.parseInt(matchingIdx));
		
		model.addAttribute("dto", dto);
		
		return "/matching/matchingReport";
	}
	
	@RequestMapping(value ="/matching/matchingReport.do")
	public String matchingReport(@RequestParam HashMap<String, String> params) {
		logger.info("params"+params);
		
		params.put("reportContent", params.get("report")+params.get("content"));
		matchingService.matchingReport(params);
		
		return "/matching/matchingReportDone";
	}
	
	@RequestMapping(value ="/matching/commentReport.go")
	public String commentReportGo(Model model,@RequestParam String commentIdx, HttpSession session) {
		
		MatchingDTO dto = new MatchingDTO();
		dto.setCommentIdx(commentIdx);
		
		model.addAttribute("dto", dto);
		
		return "/matching/commentReport";
	}
	
	@RequestMapping(value ="/matching/commentReport.do")
	public String commentReport(@RequestParam HashMap<String, String> params) {
		logger.info("params"+params);
		
		params.put("reportContent", params.get("report")+params.get("content"));
		matchingService.commentReport(params);
		
		return "/matching/matchingReportDone";
	}
	
	
}

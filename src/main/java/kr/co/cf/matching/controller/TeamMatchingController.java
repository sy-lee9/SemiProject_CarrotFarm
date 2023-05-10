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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.cf.matching.dto.MatchingDTO;
import kr.co.cf.matching.service.MatchingService;
import kr.co.cf.matching.service.TeamMatchingService;

@Controller
public class TeamMatchingController {
	
	@Autowired MatchingService matchingService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/matching/teamList.do")
	public String matchingList(Model model, HttpSession session) {
		
		// 로그인 여부 확인해서 로그인안되어 있는 아이디면 guest라고 내려보내기 
		// 로그인되어있다면 아이디가 팀장이 맞는지 확인하기
		String userId = String.valueOf(session.getAttribute("loginId"));
		logger.info("session" + session.getAttribute("loginId"));
		logger.info("모집글 리스트 불러오기");
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		}else {
			// 본인이 리더인 (해체되지 않은)팀이 있는지
			String teamName = matchingService.leaderChk(userId);
			
			if(teamName != null) {
				model.addAttribute("teamName", teamName);
			}
		}
		
		// 지역 리스트 가져오기
		ArrayList<MatchingDTO> locationList = new ArrayList<MatchingDTO>();
		locationList = matchingService.locationList();
		model.addAttribute("locationList", locationList);
		
		
		
		return "/matching/teamMatchingList";
	}
	
	
	
	@RequestMapping(value = "/matching/teamWrite.go")
	public String matchingWriteGo(@RequestParam String categoryId,@RequestParam String teamName, Model model, HttpSession session) {

		logger.info("모집글 작성 categoryIdx : " + categoryId);

		// 로그인 정보 받아 와 작성자 저장 + team이름
		logger.info("session" + session.getAttribute("loginId"));
		String writerId = (String) session.getAttribute("loginId");
		model.addAttribute("writerId", writerId);
		model.addAttribute("teamName", teamName);
		
		// 저장된 teamNam을 이용해 팀의 등록된 선호 위치 저장
		MatchingDTO teamData = new MatchingDTO();
		teamData = matchingService.matchingTeamData(teamName);
		model.addAttribute("teamData", teamData);

		// 지역 리스트 가져오기
		ArrayList<MatchingDTO> locationList = new ArrayList<MatchingDTO>();
		locationList = matchingService.locationList();
		model.addAttribute("locationList", locationList);

		// 경기장 정보 가져오기
		ArrayList<MatchingDTO> courtList = new ArrayList<MatchingDTO>();
		courtList = matchingService.courtList();
		
		logger.info("locationIdx : " + courtList);
		model.addAttribute("courtList", courtList);

		return "/matching/teamMatchingWriteForm";
	}

	@RequestMapping(value = "/matching/teamDetail.go")
	public String matchingTeamDetail(Model model, HttpSession session, @RequestParam String matchingIdx) {
		
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
		if(session.getAttribute("loginId") != null) {
			// 초대 가능한 팀 리스트 
			ArrayList<MatchingDTO> teamList = matchingService.teamList(matchingIdx);
			model.addAttribute("teamList", teamList);
			
			// 해당 경기 초대 팀 리스트 
			ArrayList<MatchingDTO> teamInviteList = new ArrayList<MatchingDTO>();
			teamInviteList = matchingService.teamInviteList(matchingIdx);
			model.addAttribute("teamInviteList", teamInviteList);
			
			// 해당 경기 참가자 정보
			ArrayList<MatchingDTO> playerList = new ArrayList<MatchingDTO>();
			playerList = matchingService.playerTeamList(matchingIdx);
			model.addAttribute("playerList", playerList);
			
			// 해당 경기 신청자 목록
			ArrayList<MatchingDTO> teamApplyList = new ArrayList<MatchingDTO>();
			teamApplyList = matchingService.teamApplyList(matchingIdx);
			model.addAttribute("teamApplyList", teamApplyList);
			
			// 내 팀정보 
			MatchingDTO myTeamDto = new MatchingDTO();
			myTeamDto = matchingService.myTeam(String.valueOf(session.getAttribute("loginId")));
			model.addAttribute("myTeamDto", myTeamDto);
		}
		

		
		return "/matching/teamMatchingDetail";
	}
	

	
	@RequestMapping(value = "/matching/teamUpdate.go")
	public String matchingUpdateGo(@RequestParam String matchingIdx, Model model, HttpSession session) {

		logger.info(matchingIdx + "번 모집글 수정");

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
		
		String teamName = matchingDto.getTeamName();

		// 저장된 teamNam을 이용해 팀의 등록된 선호 위치 저장
		MatchingDTO teamData = new MatchingDTO();
		teamData = matchingService.matchingTeamData(teamName);
		model.addAttribute("teamData", teamData);
				
		return "/matching/teamMatchingUpdateForm";
	}
	


}

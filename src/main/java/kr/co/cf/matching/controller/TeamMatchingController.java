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

		logger.info("session" + session.getAttribute("loginId"));
		logger.info("모집글 리스트 불러오기");
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		}
		
		// 지역 리스트 가져오기
		ArrayList<MatchingDTO> locationList = new ArrayList<MatchingDTO>();
		locationList = matchingService.locationList();
		model.addAttribute("locationList", locationList);
		
		ArrayList<MatchingDTO> teamName = new ArrayList<MatchingDTO>();
		
		teamName = matchingService.teamName();
		model.addAttribute("teamName", teamName);
	
		return "/matching/teamMatchingList";
	}
	
	

}

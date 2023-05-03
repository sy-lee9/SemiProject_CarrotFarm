package kr.co.cf.court.controller;

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

import kr.co.cf.court.dto.CourtDTO;
import kr.co.cf.court.service.CourtService;

@Controller
public class CourtController {
	@Autowired CourtService courtService;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping("/")
	public String court(Model model) {
		ArrayList<CourtDTO> list = courtService.list();
		model.addAttribute("courtList",list);
		model.addAttribute("address","구로구");
		return "court2";
	}
	
	@RequestMapping("/courtDetail.do")
	public String courtDetail(Model model, @RequestParam String courtIdx) {
		logger.info("디테일 가기");
		logger.info(courtIdx);
		return "courtDetail";
		
	}
	
	@RequestMapping("/courtNameSearch.do")
	public String courtNameSearch(Model model, @RequestParam String searchCourt) {
		String page;
		logger.info(searchCourt);
		CourtDTO courtdto = courtService.courtNameSearch(searchCourt);
		if(courtdto == null) {
			model.addAttribute("msg","검색 결과가 없습니다.");
			page = "redirect:/";
		}else {
			model.addAttribute("courtNameSerach",courtdto);
			page ="court2";
		}
		return page;
	}
	
}

package kr.co.cf.court.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import kr.co.cf.court.dto.CourtDTO;
import kr.co.cf.court.service.CourtService;

@Controller
public class CourtController {
	@Autowired CourtService courtService;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping("/court")
	public String court(Model model) {
		model.addAttribute("adress","서울특별시 구로동");
		return "court";
	}
	
	@RequestMapping("/courtDetail.do")
	public String courtDetail(Model model, @RequestParam String courtName, @RequestParam String courtLatitude, @RequestParam String courtLongitude) {
		logger.info("디테일 가기");
		logger.info(courtName+"/"+courtLatitude+"/"+courtLongitude);
		CourtDTO courtdto = courtService.searchCourt(courtLatitude,courtLongitude);
		logger.info("courtdto :"+ courtdto);
		if(courtdto==null) {
			int cnt = courtService.addCourt(courtName,courtLatitude,courtLongitude);
			logger.info("업데이트 row :"+cnt);
		}else {
			model.addAttribute("courtInfo", courtdto);
		}
		return "courtDetail";
		
	}
	
	@RequestMapping("/court2")
	public String court2(Model model) {
		model.addAttribute("adress","서울특별시 구로동");
		return "court2";
	}
	
}

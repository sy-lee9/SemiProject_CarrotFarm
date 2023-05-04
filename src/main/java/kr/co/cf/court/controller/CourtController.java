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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

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
	public String courtDetail(Model model, @RequestParam String courtIdx,HttpSession session) {
		logger.info("디테일 가기");
		logger.info(courtIdx);
		CourtDTO dto =courtService.courtDetail(courtIdx);
		model.addAttribute("courtInfo",dto);
		logger.info("경기장 정보 불러오기");
		ArrayList<CourtDTO> courtReviewList = courtService.courtReviewList(courtIdx);
		logger.info("리뷰 목록 "+courtReviewList);
		if(session.getAttribute("reviewMsg") != null) {
			String msg=(String)session.getAttribute("reviewMsg");
			session.removeAttribute("reviewMsg");
			model.addAttribute("msg",msg);
		}
		model.addAttribute("courtReviewList",courtReviewList);
		ArrayList<CourtDTO> reviewPhotoList = courtService.reviewPhotoList(courtIdx);
		for(int i=0;i<reviewPhotoList.size();i++) {
			logger.info("photoName :"+reviewPhotoList.get(i).getPhotoName());
		}
		model.addAttribute("reviewPhotoList",reviewPhotoList);
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
	
	@RequestMapping(value="/courtReviewWrite.do", method = RequestMethod.POST)
	public String courtReviewWrite(Model model,@RequestParam HashMap<String, String> params,HttpSession session,MultipartFile photo) {
		logger.info("넘어오는 값: "+params);
		String userId = courtService.reviewWriter(params);
		logger.info(userId);
		String page = "redirect:/courtDetail.do?courtIdx="+params.get("courtIdx");
		if(userId==null) {
			page = courtService.courtReviewWrite(params,photo);
			logger.info("params : " + params);
		}else {
			session.setAttribute("reviewMsg","이미 리뷰를 작성하셨습니다.");
		}
		
		return page;
	}
	@RequestMapping(value="/courtReviewDelete.do")
	public String courtReviewDelete(@RequestParam HashMap<String, String> params) {
		return "redirect:/courtDetail.do?courtIdx="+params.get("courtIdx");
	}
}

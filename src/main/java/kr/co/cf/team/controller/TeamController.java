package kr.co.cf.team.controller;

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
import org.springframework.web.multipart.MultipartFile;

import kr.co.cf.team.dto.TeamDTO;
import kr.co.cf.team.service.TeamService;

@Controller
public class TeamController {
	
	@Autowired TeamService TeamService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/team")
	public String list() {
		return "/team/teamList";
	}
/*	
	@RequestMapping(value = {"/team","/team/list.do"})
	public String list(Model model) {
		logger.info("list call");
		ArrayList<TeamDTO> list = TeamService.list();
		logger.info("list size : "+list.size());
		model.addAttribute("list", list);
		return "/team/teamList";
	}
*/	
	@RequestMapping(value="/team/list.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object>list(@RequestParam String page,	@RequestParam String cnt){
		return TeamService.list(Integer.parseInt(page), Integer.parseInt(cnt));
	}
/*	
	@RequestMapping(value="/team/checkMatchState.ajax", method = RequestMethod.POST)
	@ResponseBody
	public ArrayList<TeamDTO> checkMatchState(@RequestParam String checkMatchState){
		return TeamService.checkMatchState(checkMatchState);
	}
*/	
	@RequestMapping(value = "/team/teamRegist.go")
	public String teamRegistGo() {
		return "/team/teamRegist";
	}
	
	@RequestMapping(value = "/team/overlayTeamName.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> overlay(@RequestParam String teamName) {
		logger.info("overlay-controller : " + teamName);		
		return TeamService.overlay(teamName);
	}
	
	@RequestMapping(value = "/team/teamRegist.do", method = RequestMethod.POST)
	public String teamRegist(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params) {
		String page = TeamService.teamRegist(teamProfilePhoto,params);
		
		if(page != "") {
			model.addAttribute("msg","팀생성에 성공하였습니다.");
		}
		return page;
	}
	
	@RequestMapping(value="/team/teamPage.go")
	public String teamPage(Model model, @RequestParam String teamIdx) {
		logger.info("teamPage : "+teamIdx);
		String page = "redirect:/team";		
		
		TeamDTO TeamDTO = TeamService.teamInfo(Integer.parseInt(teamIdx));
		logger.info("teamInfo");
		if(TeamDTO != null) {
			model.addAttribute("team", TeamDTO);
		}
		
		ArrayList<TeamDTO> list = TeamService.tagReview(Integer.parseInt(teamIdx));
		logger.info("list : " + list.size());		
		if(list != null) {
			page = "/team/teamPage";
			model.addAttribute("list", list);
		}				
		return page;
	}
	
	@RequestMapping(value="/team/teamPageUpdate.go")
	public String updateForm(Model model, @RequestParam String teamIdx) {
		logger.info("teamPageUpdate : "+teamIdx);
		String page = "redirect:/list.do";		
		TeamDTO TeamDTO = TeamService.teamPageUpdate(teamIdx);
		if(TeamDTO != null) {
			page = "/team/teamPageUpdate";
			model.addAttribute("team", TeamDTO);
		}				
		return page;
	}
/*
	@RequestMapping(value = "/team/teamPageUpdate.do", method = RequestMethod.POST)
	public String updateForm(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params) {
		String page = TeamService.teamRegist(teamProfilePhoto,params);
		
		if(page != "") {
			model.addAttribute("msg","팀생성에 성공하였습니다.");
		}
		return page;
	}
*/	


}














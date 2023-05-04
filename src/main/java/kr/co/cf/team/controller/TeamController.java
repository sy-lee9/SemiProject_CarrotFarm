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
	



	@RequestMapping(value = {"/team","/team/list.do"})
	public String list(Model model) {
		logger.info("list call");
		ArrayList<TeamDTO> list = TeamService.list();
		logger.info("list size : "+list.size());
		model.addAttribute("list", list);
		return "/team/teamList";


	}
	
	@RequestMapping(value = "/team/teamRegist.go")
	public String teamRegistGo() {
		return "/team/teamRegist";
	}
	
	@RequestMapping(value = "/team/overlay.ajax", method = RequestMethod.POST)
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

		return "page";
	}






}














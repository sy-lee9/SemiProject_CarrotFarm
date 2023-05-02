package kr.co.cf.team.controller;

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

import kr.co.cf.team.service.TeamService;

@Controller
public class TeamController {
	
	@Autowired TeamService TeamService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "team/teamRegist";		
	}
	
	@RequestMapping(value = "/overlay.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> overlay(@RequestParam String teamName) {
		logger.info("overlay-controller");		
		return TeamService.overlay(teamName);
	}
	
	@RequestMapping(value = "/teamRegist.do", method = RequestMethod.POST)
	public String teamRegist(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params) {
		String msg = TeamService.teamRegist(teamProfilePhoto,params);
		model.addAttribute("msg",msg);
		return "team/home";
	}





}














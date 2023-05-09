package kr.co.cf.team.controller;

import java.util.ArrayList;
import java.util.HashMap;

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

	@RequestMapping(value="/team/list.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> list(@RequestParam HashMap<String, Object> params){
		logger.info("list params : "+params);
		return TeamService.list(params);
	}

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
		logger.info("updateForm : "+teamIdx);
		String page = "/redirect:/team";		
		TeamDTO TeamDTO = TeamService.updateForm(teamIdx);
		if(TeamDTO != null) {
			page = "/team/teamPageUpdate";
			model.addAttribute("team", TeamDTO);
		}				
		return page;
	}

	@RequestMapping(value = "/team/teamPageUpdate.do", method = RequestMethod.POST)
	public String teamPageUpdate(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params) {
		logger.info("teamPageUpdate " + params);
		
		String page = TeamService.teamPageUpdate(teamProfilePhoto,params);
		logger.info("update 완료");
		
		if(page != "") {
			model.addAttribute("msg","팀정보가 수정되었습니다.");
		}
		return page;
	}

	@RequestMapping(value="/team/teamDisbanding.go")
	public String disbandForm(Model model, @RequestParam String teamIdx) {
		logger.info("DisbandingForm : "+teamIdx);				
		model.addAttribute("teamIdx", teamIdx);		
		return "/team/teamDisbanding";
	}
	
	@RequestMapping(value="/team/teamDisbanding.do")
	public String disband(Model model, @RequestParam String teamIdx) {
		logger.info("Disbanding : "+teamIdx);			
		
		int row = TeamService.disband(Integer.parseInt(teamIdx));
		//model.addAttribute("teamIdx", teamIdx);	
		logger.info("disband row : "+row);
		
		if(row == 1) {
			TeamService.disbandAlarm(teamIdx);
		}

		return "redirect:/team/teamDisbandCancle.go?teamIdx="+teamIdx;
	}
	
	@RequestMapping(value="/team/teamDisbandCancle.go")
	public String disbandCancleForm(Model model, @RequestParam String teamIdx) {
		logger.info("disbandCancleForm : "+teamIdx);		
		model.addAttribute("teamIdx", teamIdx);		
		return "/team/teamDisbandCancle";
	}

	@RequestMapping(value="/team/teamDisbandCancle.do")
	public String disbandCancle(Model model, @RequestParam String teamIdx) {
		logger.info("disbandCancle : "+teamIdx);			
		
		int row = TeamService.disbandCancle(Integer.parseInt(teamIdx));
		logger.info("disbandCancle row : "+row);
		
		model.addAttribute("teamIdx", teamIdx);	
		
		return "redirect:/team/teamDisbanding.go?teamIdx="+teamIdx;
	}
	
	@RequestMapping(value="/team/teamGame.go")
	public String teamGameList(Model model, @RequestParam String teamIdx) {
		logger.info("teamGameList : "+teamIdx);		
		model.addAttribute("teamIdx", teamIdx);		
		return "/team/teamGame";
	}
	
	@RequestMapping(value="/team/gameList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> gameList(@RequestParam HashMap<String, Object> params){
		logger.info("list params : "+params);
		return TeamService.gameList(params);
	}
	
	@RequestMapping(value="/team/gameMatchingRequest.go")
	public String gameMatchingRequest(Model model, @RequestParam String teamIdx) {
		logger.info("teamGameList : "+teamIdx);		
		model.addAttribute("teamIdx", teamIdx);		
		return "/team/gameMatchingRequest";
	}
	
	@RequestMapping(value="/team/gameMatchingRequest.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> gameMatchingRequest(@RequestParam HashMap<String, Object> params){
		logger.info("list params : "+params);
		return TeamService.gameMatchingRequest(params);
	}
	
	
	
	
	
	
	
	
	
	
	
	

}

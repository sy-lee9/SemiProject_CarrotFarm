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

import kr.co.cf.matching.dto.MatchingDTO;
import kr.co.cf.team.dto.TeamDTO;
import kr.co.cf.team.service.TeamService;

@Controller
public class TeamController {
	
	@Autowired TeamService TeamService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	// 팀 리스트 페이지로 이동
	@RequestMapping(value = "/team")
	public String list(HttpSession session, Model model) {		
		String loginId = (String) session.getAttribute("loginId");

		//지역구 리스트 불러오기
		ArrayList<TeamDTO> locationList = new ArrayList<TeamDTO>();
		locationList = TeamService.locationList();
		model.addAttribute("locationList", locationList);

		//팀 가입여부 확인
		if(loginId != null) {
			if(TeamService.teamUserChk(loginId) == 1) {
				model.addAttribute("teamUserChk", true);
			}
			
			String teamIdx = TeamService.getTeamIdx(loginId);
			model.addAttribute("teamIdx",teamIdx);
		}	

		//세션에 저장된 알림 메시지 가져오기
		String msg = (String) session.getAttribute("msg");
		if(msg != null) {
			//뷰로 내려보낸 후
			model.addAttribute("msg",msg);
			//세션에 저장된 메시지 삭제
			session.removeAttribute("msg");
		}		
		return "/team/teamList";
	}

	//팀 리스트 페이지로 이동
	@RequestMapping(value = "/team/teamList.go")
	public String teamList(HttpSession session, Model model) {	
		return "redirect:/team";
	}

	//팀 리스트 불러오기
	@RequestMapping(value="/team/teamList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getList(HttpSession session, @RequestParam HashMap<String, Object> params){
		return TeamService.list(params);
	}

	
	// 팀 생성 페이지로 이동
	@RequestMapping(value = "/team/teamRegist.go")
	public String teamRegistGo(HttpSession session, Model model) {
		
		String page = "redirect:/team";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {
			
			//현재 가입한 상태의 팀이 있는지 확인
			if(TeamService.teamUserChk(loginId) == 0) {
				//가입한 팀이 없으면 팀 생성 페이지로 이동
				page = "/team/teamRegist";
				model.addAttribute("loginId", loginId);
			}else { //가입한 팀이 있을 경우
				session.setAttribute("msg","하나의 팀에만 가입할 수 있습니다.");
			}
					
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg", "로그인 후 다시 시도해주세요!");
		}			
		return page;	
	}
	
	// 팀 이름 중복확인
	@RequestMapping(value = "/team/overlayTeamName.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> overlay(@RequestParam String teamName) {
		return TeamService.overlay(teamName);
	}

	//팀 생성 요청
	@RequestMapping(value = "/team/teamRegist.do", method = RequestMethod.POST)
	public String teamRegist(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params,HttpSession session) {

		//팀 생성 요청
		String page = TeamService.teamRegist(teamProfilePhoto,params,loginId);
		
		if(page != "") {
			session.setAttribute("msg","팀생성에 성공하였습니다.");
		}
		return page;
	}

	
	// 팀 페이지로 이동
	 @RequestMapping(value="/team/teamPage.go")
	   public String teamPage(Model model, @RequestParam String teamIdx,HttpSession session) {
	      String page = "redirect:/team";      
	      
	      String loginId = (String) session.getAttribute("loginId");
	      
	      // 팀 정보 불러오기
	      TeamDTO TeamDTO = TeamService.teamInfo(Integer.parseInt(teamIdx));
	      if(TeamDTO != null) {
	         model.addAttribute("team", TeamDTO);
	         
	         // 팀 리뷰 불러오기
	         ArrayList<TeamDTO> list = TeamService.tagReview(Integer.parseInt(teamIdx));
	         if(list != null) {            
	            model.addAttribute("list", list);   

	            //팀 가입 신청여부 확인
	            if(loginId != null) {
	               int row = TeamService.joinAppChk(Integer.parseInt(teamIdx),loginId);
	               
	               if(row != 0){
	                  //해당 팀에 가입신청을 하지 않은 경우
	                  model.addAttribute("joinAppChk",true);
	               }else if(row == 0){
	                  //해당 팀에 가입신청을 한 경우
	                  model.addAttribute("joinAppChk",false);
	               }
	               //해당 팀 팀장여부 확인
	               if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1) {
	            	   model.addAttribute("teamLeadersChk",true);
	               }
	               
	            }   
	            
	            //가입신청 버튼 노출 여부 확인(로그인 안했을 경우)
	            if(session.getAttribute("loginId") == null) {
	               model.addAttribute("joinAppChk",false);
	            }
	            
	            //가입신청 버튼 노출 여부 확인(가입한 팀이 있을 경우)
	            if(session.getAttribute("loginId") != null) {
	               if(TeamService.teamJoinChk(loginId) == 0){
	                  model.addAttribute("joinTeam",false);
	               }
	            }
	            
	            //팀 탈퇴 버튼 노출 여부 확인(해당 팀 가입 여부 확인)             
	            if(session.getAttribute("loginId") != null) {
	               if(TeamService.teamUserChk(Integer.parseInt(teamIdx),loginId) == 1){
	                  model.addAttribute("teamUserChk",true);
	               }
	            }
	         }   
	         page = "/team/teamPage";
	      }      
	      
	      String msg = (String) session.getAttribute("msg");
	      if(msg != null) {
	         model.addAttribute("msg",msg);
	         session.removeAttribute("msg");
	      }
	      return page;
	   }
	
	 // 팀 페이지 팝업창
	@RequestMapping(value="/team/teamPagePop.go")
	public String teamPagePop(Model model, @RequestParam String teamIdx,HttpSession session) {

		//팀 정보 불러오기
		TeamDTO TeamDTO = TeamService.teamInfo(Integer.parseInt(teamIdx));
		if(TeamDTO != null) { //팀 정보가 존재할 경우
			model.addAttribute("team", TeamDTO);

			//팀 리뷰 불러오기
			ArrayList<TeamDTO> list = TeamService.tagReview(Integer.parseInt(teamIdx));
			if(list != null) {				
				model.addAttribute("list", list);					
			}				
		}
		return "/team/teamPagePop";
	}
	
	
	// 팀 정보 수정 페이지로 이동
	@RequestMapping(value="/team/teamPageUpdate.go")
	public String updateForm(Model model, @RequestParam String teamIdx,HttpSession session) {
		
		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//팀장 여부 확인
			String teamLeaderId = TeamService.getTeamLeader(Integer.parseInt(teamIdx));
			//팀장일 경우 팀 정보 불러오기
			if(teamLeaderId.equals(loginId)){
				TeamDTO TeamDTO = TeamService.updateForm(teamIdx);
				if(TeamDTO != null) {
					page = "/team/teamPageUpdate";
					model.addAttribute("team", TeamDTO);
				}
			}else { //팀장이 아닐경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);	
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);	
		}

		return page;
	}

	//팀 정보 업데이트 요청
	@RequestMapping(value = "/team/teamPageUpdate.do", method = RequestMethod.POST)
	public String teamPageUpdate(Model model,MultipartFile teamProfilePhoto,@RequestParam HashMap<String, String> params) {

		//팀 정보 업데이트 요청
		String page = TeamService.teamPageUpdate(teamProfilePhoto,params);

		//성공했을 경우
		if(page != "") {
			model.addAttribute("msg","팀정보가 수정되었습니다.");
		}
		return page;
	}

	
	// 팀 해체 페이지로 이동
	@RequestMapping(value="/team/teamDisbanding.go")
	public String disbandForm(Model model, @RequestParam String teamIdx,HttpSession session) {
		
		String page = "redirect:/team/teamPage.go";		
		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
					page = "/team/teamDisbanding";
					model.addAttribute("teamIdx", teamIdx);	
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}		
		return page;
	}

	//팀 해체 요청
	@RequestMapping(value="/team/teamDisbanding.do")
	public String disband(Model model, @RequestParam String teamIdx,HttpSession session) {
		
		String page = "redirect:/team/teamPage.go";		
		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
					//팀 해체 신청
					if(TeamService.disband(Integer.parseInt(teamIdx)) == 1) {
						//팀 해체 신청 알림 전송
						TeamService.disbandAlarm(Integer.parseInt(teamIdx));
					}
					page = "redirect:/team/teamDisbandCancle.go?teamIdx="+teamIdx;
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}		
		return page;
	}
	
	
	//팀 해체 취소 페이지로 이동
	@RequestMapping(value="/team/teamDisbandCancle.go")
	public String disbandCancleForm(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";		
		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
					model.addAttribute("teamIdx", teamIdx);		
					page = "/team/teamDisbandCancle";
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}

	//팀 해체 취소 요청
	@RequestMapping(value="/team/teamDisbandCancle.do")
	public String disbandCancle(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";		
		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
				if(TeamService.disbandCancle(Integer.parseInt(teamIdx)) == 1) {
					model.addAttribute("teamIdx", teamIdx);	
					//팀 해체 신청취소 알림 전송
					TeamService.disbandCancleAlarm(Integer.parseInt(teamIdx));
					
					page = "redirect:/team/teamDisbanding.go";
				}	
				
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}	
		return page;
	}
	
	
	//참가 경기 리스트 페이지로 이동
	@RequestMapping(value="/team/teamGame.go")
	public String teamGameList(Model model, @RequestParam String teamIdx) {
		model.addAttribute("teamIdx", teamIdx);		
		return "/team/teamGame";
	}
	
	//참가 경기 리스트 불러오기
	@RequestMapping(value="/team/gameList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> gameList(@RequestParam HashMap<String, Object> params){
		return TeamService.gameList(params);
	}
	
	
	//신청한 경기 리스트 페이지로 이동
	@RequestMapping(value="/team/gameMatchingRequest.go")
	public String gameMatchingRequest(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				model.addAttribute("teamIdx", teamIdx);	
				page = "/team/gameMatchingRequest";
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}	
		return page;
	}

	//신청한 경기 리스트 불러오기
	@RequestMapping(value="/team/gameMatchingRequest.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> gameMatchingRequest(@RequestParam HashMap<String, Object> params){
		return TeamService.gameMatchingRequest(params);
	}

	//팀 가입신청 알림 페이지로 이동
	@RequestMapping(value="/team/teamJoinAppAlarm.go")
	public String teamJionAppAlarm(Model model, @RequestParam String teamIdx,HttpSession session) {
		
		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				model.addAttribute("teamIdx", teamIdx);	
				page = "/team/teamJoinAppAlarm";
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
		
	//신청한 게임 모집글 변경사항 알림 페이지로 이동
	@RequestMapping(value="/team/appGameUpdateAlarm.go")
	public String appGameUpdateAlarm(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				//모집중인 경기 참가신청 알림 불러오기
				ArrayList<TeamDTO> list = TeamService.appGameUpdateAlarm(teamIdx);				
				model.addAttribute("list", list);
				model.addAttribute("teamIdx", teamIdx);					
				page = "/team/appGameUpdateAlarm";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
	
	
	//경기 초대 알림 페이지로 이동
	@RequestMapping(value="/team/matchingInviteAlarm.go")
	public String matcingInviteAlram(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				//모집중인 경기 참가신청 알림 불러오기
				ArrayList<TeamDTO> list = TeamService.matchingInviteAlarm(teamIdx);
				model.addAttribute("list", list);
				model.addAttribute("teamIdx", teamIdx);	
				page = "/team/matchingInviteAlarm";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
	
	
	//경기 참가신청 알림 페이지로 이동
	@RequestMapping(value="/team/gameMatchingAppAlarm.go")
	public String gameMatchingAppAlarm(Model model, @RequestParam String teamIdx,HttpSession session) {

		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				//모집중인 경기 참가신청 알림 불러오기
				ArrayList<TeamDTO> list = TeamService.gameMatchingAppAlarm(teamIdx);				
				model.addAttribute("list", list);
				model.addAttribute("teamIdx", teamIdx);	
				page = "/team/gameMatchingAppAlarm";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
	
	
	//작성한 경기 리스트 페이지로 이동
	@RequestMapping(value="/team/writeMatchingList.go")
	public String writeMatchingList(Model model, @RequestParam String teamIdx,HttpSession session) {
		
		String page = "redirect:/team/teamPage.go";				
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				//작성한 모집글 리스트 불러오기
				ArrayList<TeamDTO> list = TeamService.writeMatchingList(Integer.parseInt(teamIdx));
				model.addAttribute("list", list);
				model.addAttribute("teamIdx",teamIdx);
				page = "/team/writeMatchingList";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
	
	
	//팀 가입 신청 요청
	@RequestMapping(value="/team/joinApp.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> joinApp(@RequestParam String teamIdx,HttpSession session,Model model){
		
		String loginId = (String) session.getAttribute("loginId");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		if(loginId != null) {	
			//팀 가입여부 확인
			if(TeamService.teamJoinChk(loginId) == 0){ //가입한 팀이 없을 경우
				
				//강퇴회원 확인
				if(TeamService.removeChk(Integer.parseInt(teamIdx),loginId) == 1) {
					map.put("removeChk", 1);
				}else {
					//팀 가입신청 테이블에 회원정보 저장
					if(TeamService.teamJoinApp(Integer.parseInt(teamIdx),loginId) == 1) {
						map.put("joinChk", 0);
					}
				}								
			}else { //가입한 팀이 있을 경우
				map.put("joinChk", 1);
			}
		}else { //로그인 상태가 아닐 경우
			map.put("joinChk", "false");
		}			
		
		return map;
	}
	
	//팀 가입 신청 취소 요청
	@RequestMapping(value="/team/joinCancel.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> joinCancel(@RequestParam String teamIdx,HttpSession session,Model model){	
		
		String loginId = (String) session.getAttribute("loginId");
		
		HashMap<String, Object> map = new HashMap<String, Object>();

		if(loginId != null) {
			//팀 가입 신청 여부 확인
			int row = TeamService.joinAppChk(Integer.parseInt(teamIdx),loginId);

			//팀 가입 신청한 상태일 경우
			if(row == 1){
				//팀 가입 신청 취소 요청
				TeamService.joinCancel(Integer.parseInt(teamIdx),loginId);
			}			
		}		
		return map;
	}
	
	//팀 가입 신청자 리스트 불러오기
	@RequestMapping(value="/team/teamJoinAppList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> teamJoinAppList(@RequestParam String teamIdx){
		return TeamService.teamJoinAppList(Integer.parseInt(teamIdx));
	}
	
	//팀 가입 수락 요청
	@RequestMapping(value="/team/teamJoinAccept.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> teamJoinAccept(@RequestParam String teamIdx, @RequestParam String userId){
		return TeamService.teamJoinAccept(Integer.parseInt(teamIdx),userId);
	}

	//팀 가입 거절 요청
	@RequestMapping(value="/team/teamJoinReject.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> teamJoinReject(@RequestParam String teamIdx, @RequestParam String userId){
		return TeamService.teamJoinReject(Integer.parseInt(teamIdx),userId);
	}
	
	
	//팀 탈퇴 요청
	@RequestMapping(value="/team/leaveTeam.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> leaveTeam(@RequestParam String teamIdx,HttpSession session){
		String userId = (String) session.getAttribute("loginId");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		if(userId != null) {
			//팀장일 경우
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(userId)){
				
				//부팀장에게 팀장 권한 양도
				TeamService.teamGradeUpdate(Integer.parseInt(teamIdx),userId);
			}
				map = 	TeamService.leaveTeam(Integer.parseInt(teamIdx),userId);
		}
		return map;
	}
	
	
	// 팀원 리스트 페이지로 이동
	@RequestMapping(value = "/team/teamUserList.go")
	public String teamUserListForm(HttpSession session, Model model, @RequestParam String teamIdx) {
		model.addAttribute("teamIdx",teamIdx);
		
		String loginId = (String) session.getAttribute("loginId");
		model.addAttribute("loginId",loginId);
		return "/team/teamUserList";
	}

	//팀원 리스트 불러옹기
	@RequestMapping(value="/team/teamUserList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> teamUserList(@RequestParam HashMap<String, Object> params,HttpSession session){
		String loginId = (String) session.getAttribute("loginId");

		if(loginId != null) {	
			params.put("userId", loginId);
		}else { //로그인 상태가 아닐 경우
			params.put("userId", "로그인안함");
		}

		return TeamService.teamUserList(params);
	}
	
	// 팀원 리스트(팀장용)
	@RequestMapping(value = "/team/teamUserListLeader.go")
	public String teamUserListLeader(HttpSession session, Model model, @RequestParam String teamIdx) {
		model.addAttribute("teamIdx",teamIdx);
		
		String page = "redirect:/team/teamPage.go";
		
		String loginId = (String) session.getAttribute("loginId");
		if(loginId != null) {	
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
					page = "/team/teamUserListLeader";
					model.addAttribute("teamIdx", teamIdx);	
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}		
		
		return page;
	}

	//팀원 리스트 불러오기(팀장용)
	@RequestMapping(value="/team/teamUserListLeader.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> teamUserListLeader(@RequestParam HashMap<String, Object> params,HttpSession session){
		return TeamService.teamUserListLeader(params);
	}

	//팀원 등급 변경 요청
	@RequestMapping(value="/team/changeTeamGrade.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> changeTeamGrade(@RequestParam HashMap<String, Object> params,HttpSession session){
		return TeamService.changeTeamGrade(params);
	}
	
	
	//팀원 경고 리스트 페이지로 이동
	@RequestMapping(value = "/team/warningTeamUser.go")
	public String warningTeamUser(HttpSession session, Model model, @RequestParam String teamIdx) {
		model.addAttribute("teamIdx",teamIdx);
		
		String page = "redirect:/team/teamPage.go";
		
		String loginId = (String) session.getAttribute("loginId");
		if(loginId != null) {	
			//팀장 여부 확인
			if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
					page = "/team/warningTeamUser";
					model.addAttribute("teamIdx", teamIdx);	
			}else { //팀장이 아닐 경우
				session.setAttribute("msg","팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}		
		
		return page;
	}

	//경고 리스트 불러오기
	@RequestMapping(value="/team/warningList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> warningList(@RequestParam HashMap<String, Object> params,HttpSession session){
		return TeamService.warningList(params);
	}
	
	// 팀원 경고 페이지로 이동
	@RequestMapping(value = "/team/warning.go")
	public String warningForm(HttpSession session, Model model,@RequestParam String teamIdx,@RequestParam String userId) {

		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				model.addAttribute("userId",userId);
				model.addAttribute("teamIdx",teamIdx);
				
				page = "/team/warningPop";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}				
		return page;
	}

	//경고 처리 요청
	@RequestMapping(value = "/team/warning.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> warning(HttpSession session, Model model,@RequestParam HashMap<String, Object> params) {		

		//경고 사유가 기타일 경우
		if(params.get("warning").equals("기타")) {
			//작성한 사유 params에 추가
			params.put("reason", params.get("content"));
		}else { //경고 사유가 기타가 아닐 경우
			//선택한 경고 사유 params에 추가
			params.put("reason", params.get("warning"));
		}

		//경고 처리 요청
		TeamService.warning(params);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", 1);
		
		return map;
	}
	
	//경고 취소 페이지로 이동
	@RequestMapping(value = "/team/warningCancel.go")
	public String warningCancelForm(HttpSession session, Model model,@RequestParam String teamIdx,@RequestParam String userId) {

		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				model.addAttribute("userId",userId);
				model.addAttribute("teamIdx",teamIdx);
				
				page = "/team/warningCancelPop";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}				
		return page;
	}
	
	// 경고 취소 요청
	@RequestMapping(value = "/team/warningCancel.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> warningCancel(HttpSession session, Model model,@RequestParam HashMap<String, Object> params) {	

		// 경고 취소 요청
		TeamService.warningCancel(params);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", 1);
		
		return map;
	}
	
	//팀원 강퇴 페이지로 이동
	@RequestMapping(value = "/team/remove.go")
	public String removeForm(HttpSession session, Model model,@RequestParam String teamIdx,@RequestParam String userId) {
		
		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				model.addAttribute("userId",userId);
				model.addAttribute("teamIdx",teamIdx);
				
				page = "/team/removePop";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}					
	
		return page;
	}

	//강퇴 처리 요청
	@RequestMapping(value = "/team/remove.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> remove(HttpSession session, Model model,@RequestParam HashMap<String, Object> params) {	

		//강퇴처리 성공했을 경우
		if(TeamService.remove(params) == 1) {
			//강퇴 알림 전송
			TeamService.removeAlarm(params);
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", 1);
		
		return map;
	}
	
	//경고 히스토리 보기 페이지로 이동
	@RequestMapping(value = "/team/warningDetail.go")
	public String warningHistory(HttpSession session, Model model,@RequestParam String teamIdx,@RequestParam String userId) {
		
		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	

			//경고 히스토리 불러오기
			ArrayList<TeamDTO> list = TeamService.warningHistory(Integer.parseInt(teamIdx),userId);
			if(list != null) {		
				
				//팀장일 경우
				if((TeamService.getTeamLeader(Integer.parseInt(teamIdx))).equals(loginId)){
						model.addAttribute("teamLeaderChk", true);	
				}				
				
				model.addAttribute("list", list);				
				model.addAttribute("userId",userId);
				model.addAttribute("teamIdx",teamIdx);

				page = "/team/warningHistory";
			}	

		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}			
		return page;
	}
	
	// 즉시강퇴 페이지로 이동
	@RequestMapping(value = "/team/removeNow.go")
	public String removeNowForm(HttpSession session, Model model,@RequestParam String teamIdx,@RequestParam String userId) {

		String page = "redirect:/team/teamPage.go";		
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId != null) {	
			//로그인한 아이디가 팀장, 부팀장인지 확인
			if(TeamService.teamLeadersChk(Integer.parseInt(teamIdx),loginId) == 1){
				
				model.addAttribute("userId",userId);
				model.addAttribute("teamIdx",teamIdx);
				
				page = "/team/removeNowPop";
				
			}else { //팀장 또는 부팀장이 아닐 경우
				session.setAttribute("msg","팀장, 부팀장만 접근 가능합니다.");	
				model.addAttribute("teamIdx", teamIdx);
			}
		}else { //로그인 상태가 아닐 경우
			session.setAttribute("msg","로그인 후 다시 시도해주세요.");	
			model.addAttribute("teamIdx", teamIdx);
		}		
	
		return page;
	}

	//즉시 강퇴 요청
	@RequestMapping(value = "/team/removeNow.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> removeNow(HttpSession session, Model model,@RequestParam HashMap<String, Object> params) {	

		//즉시 강퇴 처리 성공했을 경우
		if(TeamService.remove(params) == 1) {

			//강퇴 사유가 기타인 경우 
			if(params.get("remove").equals("기타")) {
				//작성한 강퇴 사유 params에 추가
				params.put("reason", params.get("content"));
			}else { //강퇴 사유가 기타가 아닌 경우
				//선택한 강퇴 사유 params에 추가
				params.put("reason", params.get("remove"));
			}
			
			//강퇴 알림 전송
			TeamService.removeNowAlarm(params);
		}
				
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", 1);
		
		return map;
	}


}

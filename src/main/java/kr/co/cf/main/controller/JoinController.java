package kr.co.cf.main.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.cf.main.dao.JoinDAO;
import kr.co.cf.main.dto.JoinDTO;
import kr.co.cf.main.service.JoinService;

@Controller
public class JoinController {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	
	@Autowired JoinService service;
	
	@RequestMapping(value="/login")
	public String home() {
		return "login";
	}
	
	@RequestMapping(value = "/idChk.ajax", method = RequestMethod.POST)
	   @ResponseBody
	   public HashMap<String, Object> idChk(@RequestParam String userId) {
	      logger.info("idChk-controller");
	      return service.idChk(userId);
	}
	
	@RequestMapping(value = "/nickChk.ajax", method = RequestMethod.POST)
	   @ResponseBody
	   public HashMap<String, Object> nickChk(@RequestParam String nickName) {
	      logger.info("nickChk-controller");
	      return service.nickChk(nickName);
	   }
	
	@RequestMapping(value="/login.ajax")
	@ResponseBody
	public HashMap<String, Object> login(
			@RequestParam String id,@RequestParam String pw, 
			HttpSession session){
		
		logger.info(id+"/"+pw);
		JoinDTO dto = service.login(id,pw);

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		if(dto != null) {
			session.setAttribute("loginId", id);
			session.setAttribute("nickName", dto.getNickName());
			map.put("user", dto);
		}
		
		
		return map;
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
       
       session.removeAttribute("nickName");
       return "adminUser";
    }

	/* 회원가입 */
	 @RequestMapping(value = "/join")
	    public String join(Model model) {
		 
	        return "join";
	    }
	 
	 @RequestMapping(value="/join.do", method = RequestMethod.POST)
		public String write(Model model, MultipartFile userProfile, @RequestParam HashMap<String, String> params) {
		 String msg = service.write(userProfile,params);
			model.addAttribute("msg",msg);
			//service.mannerDefalut(params.get("userId"));
			return "adminUser";
		}
	 
	 /* 아이디 찾기 */
	 @RequestMapping(value="/findIdView")
		public String findIdView() throws Exception{
			return"findIdView";
		}
		
		@RequestMapping(value="/findId")
		public String findId(JoinDTO dto,Model model) throws Exception{
			logger.info("email"+dto.getEmail());
					
			if(service.findIdCheck(dto.getEmail())==0) {
			model.addAttribute("msg", "해당 이메일이 존재하지 않습니다.");
			return "findIdView";
			}else {
			model.addAttribute("user", service.findId(dto.getEmail()));
			return "findId";
			}
		}
		
		/* 비밀번호 찾기 */
		@RequestMapping(value = "/findpw.go")
		public String findPwPOST1() throws Exception{
			return "findPw";
		}
		
		
		@RequestMapping(value = "/findpw")
		@ResponseBody
		public void findPwPOST(@RequestParam HashMap<String, String> params, Model model) throws Exception{
			logger.info("params : " + params);
			service.findPw(params);
		}
		
		@RequestMapping(value="/userdelete.go")
	      public String userdelete(HttpSession session) {  
	         
	         String page = "redirect:/";
	         
	         if(session.getAttribute("nickName") != null) {
	            page = "userDelete";
	         }
	         
	      return page;
	      }
	      
	      @RequestMapping(value="/userdelete.do")
	      public String userdeletetrue(HttpSession session) {  
	         
	         String page = "redirect:/";
	         
	         if(session.getAttribute("nickName") != null) {
	            service.userdeletetrue(session.getAttribute("nickName"));
	            session.removeAttribute("nickName");
	            page = "userDeleteComplete";
	         }
	         
	      return page;
	      }
	      
	      @RequestMapping(value="/userinfo.go")
	      public String userInfo(HttpSession session, Model model) {  
	         
	         String page = "redirect:/";      
	         
	         logger.info("닉네임 : "+session.getAttribute("nickName"));
	         
	          if(session.getAttribute("nickName") != null) {
	             JoinDTO dto = service.userInfo(session.getAttribute("nickName"));             
	             model.addAttribute("user",dto);
	             page = "userInfo";
	          }
	         
	         return page;
	      }
	      
	      @RequestMapping(value = "/userinfoupdate.go")
	      public String userInfoUpdate(HttpSession session, Model model) {
	    	  
	    	String page = "redirect:/";		
	  		JoinDTO dto = service.userInfo(session.getAttribute("nickName"));
	  		if(dto != null) {
	  			page = "userInfoUpdate";
	  			model.addAttribute("user", dto);
	  		}				
	  		return page;
	  	}
	      
	      @RequestMapping(value="/userinfoupdate.do", method = RequestMethod.POST)
	  	  public String userInfoUpdate(@RequestParam HashMap<String, String> params, Model model) {
	  		logger.info("params : "+params);
	  		return service.userInfoUpdate(params);
	  	}

}

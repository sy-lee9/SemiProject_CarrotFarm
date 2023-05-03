package kr.co.cf.main.controller;

import java.util.HashMap;

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
		int success = service.login(id,pw);
		logger.info("login success : "+success);
		
		if(success == 1) {
			session.setAttribute("loginId", id);
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", success);
		
		return map;
	}

	
	 @RequestMapping(value = "/join")
	    public String join(Model model) {

	        return "join";
	    }
	 
	 @RequestMapping(value="/join.do", method = RequestMethod.POST)
		public String write(Model model, MultipartFile userProfile, @RequestParam HashMap<String, String> params) {
		 String msg = service.write(userProfile,params);
			model.addAttribute("msg",msg);
			return "team/home";
		}

}

package kr.co.cf.admin.controller;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.co.cf.admin.dto.AdminUserDTO;
import kr.co.cf.admin.service.AdminUserService;

@Controller
public class AdminUserController {
	
	@Autowired AdminUserService adminUserService;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String home(Model model) {

		ArrayList<AdminUserDTO> list = new ArrayList<AdminUserDTO>();
		list=adminUserService.list();
		logger.info("list" + list);
		model.addAttribute("list",list);
		return "/admin/adminUser";

	}
}

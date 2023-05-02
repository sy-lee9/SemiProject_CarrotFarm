package kr.co.cf.admin.service;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.cf.admin.dao.AdminCourtDAO;
import kr.co.cf.admin.dao.AdminUserDAO;
import kr.co.cf.admin.dto.AdminUserDTO;

@Service
public class AdminUserService {
	
	@Autowired AdminUserDAO adminUserDAO;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	

	public ArrayList<AdminUserDTO> list() {
		
		return adminUserDAO.list();
		
		
	}

}

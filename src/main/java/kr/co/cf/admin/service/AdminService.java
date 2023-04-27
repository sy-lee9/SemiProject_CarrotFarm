package kr.co.cf.admin.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.cf.admin.dao.AdminDAO;

@Service
public class AdminService {
	
	@Autowired AdminDAO adminDAO;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public void insert(String user_name, int age) {
		logger.info(user_name,age);
		adminDAO.insert(user_name,age);
	}

}

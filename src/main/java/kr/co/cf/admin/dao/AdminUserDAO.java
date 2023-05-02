package kr.co.cf.admin.dao;

import java.util.ArrayList;

import kr.co.cf.admin.dto.AdminUserDTO;

public interface AdminUserDAO {
	

	void insert(String user_name, int age);

	ArrayList<AdminUserDTO> list();

	
}

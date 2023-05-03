package kr.co.cf.court.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.cf.court.dao.CourtDAO;
import kr.co.cf.court.dto.CourtDTO;

@Service
public class CourtService {
	
	@Autowired CourtDAO courtdao;
	Logger logger = LoggerFactory.getLogger(this.getClass());

	public CourtDTO searchCourt(String courtLatitude, String courtLongitude) {
		return courtdao.searchCourt(courtLatitude,courtLongitude);
	}

	public int addCourt(String courtName, String courtLatitude, String courtLongitude, String courtAddress) {
		
		return courtdao.addCourt(courtName,courtLatitude,courtLongitude,courtAddress);
	}

	public ArrayList<CourtDTO> list() {
		return courtdao.list();
	}

	public ArrayList<CourtDTO> location() {
		return courtdao.location();
	}

	public CourtDTO courtNameSearch(String searchCourt) {
		return courtdao.courtNameSearch(searchCourt);
	}

}

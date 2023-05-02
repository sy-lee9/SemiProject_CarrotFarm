package kr.co.cf.court.dao;

import kr.co.cf.court.dto.CourtDTO;

public interface CourtDAO {

	CourtDTO searchCourt(String courtLatitude, String courtLongitude);

	int addCourt(String courtName, String courtLatitude, String courtLongitude);

}

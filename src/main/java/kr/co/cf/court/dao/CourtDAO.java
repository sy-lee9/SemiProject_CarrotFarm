package kr.co.cf.court.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.court.dto.CourtDTO;

public interface CourtDAO {

	CourtDTO searchCourt(String courtLatitude, String courtLongitude);

	int addCourt(String courtName, String courtLatitude, String courtLongitude, String courtAddress);

	ArrayList<CourtDTO> list();

	ArrayList<CourtDTO> location();

	CourtDTO courtNameSearch(String searchCourt);

	CourtDTO courtDetail(String courtIdx);

	int courtReviewWrite(CourtDTO dto);

	ArrayList<CourtDTO> courtReviewList(String courtIdx);

	String reviewWriter(HashMap<String, String> params);

	void fileWrite(int courtReviewIdx, String photoName);

	ArrayList<CourtDTO> reviewPhotoList(String courtIdx);

}

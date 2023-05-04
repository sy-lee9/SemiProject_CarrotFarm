package kr.co.cf.court.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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

	public CourtDTO courtDetail(String courtIdx) {
		return courtdao.courtDetail(courtIdx);
	}

	public String courtReviewWrite(HashMap<String, String> params, MultipartFile photo) {
		
		// 1. 게시글만 작성한 경우
		// 방금 insert 한 값의 key 를 반환 받는 방법
		// 조건 1. 파라메터를 DTO 로 보내야 한다.
		CourtDTO dto = new CourtDTO();
		dto.setCourtIdx(Integer.parseInt(params.get("courtIdx")));
		dto.setUserId(params.get("userId"));
		dto.setCourtOneLineReview(params.get("courtOneLineReview"));
		dto.setCourtStar(Double.parseDouble(params.get("courtStar")));
		dto.setCourtName(params.get("courtName"));
		int row = courtdao.courtReviewWrite(dto);		
		logger.info("update row : "+row);
		String userId= dto.getUserId();
		// 조건 3. 받아온 키는 파라메터 DTO 에서 뺀다.
		int courtReviewIdx = dto.getCourtReviewIdx();
		logger.info("방금 insert 한 idx : "+courtReviewIdx);
		
		// 2. 파일도 업로드 한 경우
		if(!photo.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			fileSave(courtReviewIdx, photo,userId);
		}
		
		return "redirect:/courtDetail.do?courtIdx="+params.get("courtIdx");
		
		
	}
	private void fileSave(int courtReviewIdx, MultipartFile file, String userId){
		// 1. 파일을 C:/img/upload/ 에 저장
		//1-1. 원본 이름 추출
		String oriFileName = file.getOriginalFilename();
		//1-2. 확장자 추출
		String ext = oriFileName.substring(oriFileName.lastIndexOf("."));
		//1-3. 새이름 생성 + 확장자
		String photoName = userId+System.currentTimeMillis()+ext;
		logger.info(oriFileName+" => "+photoName);		
		try {
			byte[] bytes = file.getBytes();//1-4. 바이트 추출
			//1-5. 추출한 바이트 저장
			Path path = Paths.get("C:/img/upload/"+photoName);
			Files.write(path, bytes);
			logger.info(photoName+" save OK");
			// 2. 저장 정보를 DB 에 저장
			//2-1. 가져온 idx, oriFileName, newFileName insert
			courtdao.fileWrite(courtReviewIdx,photoName);
						
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	public ArrayList<CourtDTO> courtReviewList(String courtIdx) {
		return courtdao.courtReviewList(courtIdx);
	}

	public String reviewWriter(HashMap<String, String> params) {
		return courtdao.reviewWriter(params);
	}

	public ArrayList<CourtDTO> reviewPhotoList(String courtIdx) {
		return courtdao.reviewPhotoList(courtIdx);
	}

	public void courtReviewDelete(HashMap<String, String> params) {
		// 1. photo 에 해당 idx 값이 있는지?
		String photoName = courtdao.findFile(params.get("courtReviewIdx"));
		logger.info("file name : "+photoName);
		// 2. 없다면?
		int row = courtdao.courtReviewDelete(params.get("courtReviewIdx"));
		logger.info("delete data : "+row);
		courtdao.courtPhotoDelete(params.get("courtReviewIdx"));
				
		if(photoName != null && row >0) {// 3. 있다면? AND bbs 와  photo 가 확실히 삭제 되었는지?			
			File file = new File("C:/img/upload/"+photoName);
			if(file.exists()) {// 2. 해당 파일이 존재 하는지?
				file.delete();// 3. 삭제
			}			
		}
		
	}

	public ArrayList<CourtDTO> guList() {
		return courtdao.guList();
	}

	public ArrayList<CourtDTO> selectList(String gu) {
		return courtdao.selectList(gu);
	}

	public ArrayList<CourtDTO> courtList(String gu) {
		return courtdao.courtList(gu);
	}


}

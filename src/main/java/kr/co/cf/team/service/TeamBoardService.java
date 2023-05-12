package kr.co.cf.team.service;


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

import kr.co.cf.team.dao.TeamBoardDAO;
import kr.co.cf.team.dto.TeamBoardDTO;

@Service
public class TeamBoardService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired TeamBoardDAO dao;

	public ArrayList<TeamBoardDTO> tplist() {
		return dao.tplist();
	}
	
	public HashMap<String, Object> tpalist(int page, String search) {
		
		logger.info(page + "페이지 보여줘");
		logger.info("search : " + search);

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		int offset =(page-1) * 10;
		
		int total = dao.tpatotalCount();
		
		if (search.equals("default") || search.equals("")) {
			total = dao.tpatotalCount();
			
		} else {
			total = dao.tpatotalCountSearch(search);
		};
		
		

		int range = total%10 == 0 ? total/10 : (total/10)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		ArrayList<TeamBoardDTO> tpalist = dao.tpalist(10, offset);
		
		//params.put("offset", offset);
		
		if (search.equals("default") || search.equals("")) {
			tpalist = dao.tpalist(10, offset);
			
		} else {
			tpalist = dao.tpalistSearch(search);
		}
		
		map.put("currPage", page);
		map.put("pages", range);
		
		map.put("teampictureboardList", tpalist);
		return map;
	}
	
	public String tpwrite(MultipartFile[] photos, HashMap<String, String> params) {
		
		String page = "redirect:/teampictureboardList.do";
		
		TeamBoardDTO dto = new TeamBoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setUserId(params.get("userId"));
		dto.setContent(params.get("content"));
		dto.setCategoryId(params.get("categoryId"));
		
		
		
		int row = dao.tpwrite(dto);
		logger.info("업데이트 row : " + row);
		
		int bidx = dto.getBoardIdx();
		logger.info("방금 인서트한 bidx : " + bidx);
		
		 for (MultipartFile photo : photos) {
	         logger.info("photo 여부 :"+photo.isEmpty());
	         if(photo.isEmpty()==false) {
	            
	            tpfileSave(bidx, photo);
	            
	            try {
	               Thread.sleep(1);
	            } catch (InterruptedException e) {
	               e.printStackTrace();
	            }
	            
	         }
		 }
		 page = "redirect:/teampictureboardDetail.do?bidx=" + bidx;
		 return page;
	}
	

	private void tpfileSave(int photoIdx, MultipartFile photo) {
		String OriginalFileName = photo.getOriginalFilename();
		String ext = OriginalFileName.substring(OriginalFileName.lastIndexOf("."));
		String newFileName = System.currentTimeMillis() + ext;
		logger.info(OriginalFileName + " -> " + newFileName);
		
		try {
			byte[] bytes = photo.getBytes();
			Path path = Paths.get("C:/img/upload/" + newFileName);
			Files.write(path,bytes);
			logger.info(newFileName + "세이브 완료");
			dao.tpfileWrite(photoIdx, newFileName);
			logger.info("포토인덱스 : " + photoIdx + "포토네임 : " + newFileName);
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
	}

	public ArrayList<TeamBoardDTO> tpdetail(String boardIdx, String flag) {
		if(flag.equals("detail")) {
			dao.tpupHit(boardIdx);
		}
		ArrayList<TeamBoardDTO> dto = dao.tpdetail(boardIdx);
		logger.info("boardIdx : " + boardIdx);
		logger.info("dto : " + dto);
		
		return dto;
	}

	public void tpdelete(String bidx) {
		String newFileName = dao.tpfindFile(bidx);
		logger.info("파일 이름 : " + newFileName);
		
		int row = dao.tpdelete(bidx);
		logger.info("삭제 데이터 : " + row);
		
		if (newFileName != null && row > 0) {
			File file = new File("C:/img/upload/" + newFileName);
			if (file.exists()) {
				file.delete();
			}
		}
	}

	public String tpupdate(MultipartFile photo, HashMap<String, String> params) {
		int bidx = Integer.parseInt(params.get("bidx"));
		int row = dao.tpupdate(params);
		logger.info("bidx 값 : " + bidx);
		logger.info("row 값 : " + row);
		
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			tpfileSave(bidx, photo);
		}
		
		String page = row >0 ? "redirect:/teampictureboardDetail.do?bidx=" + bidx : "redirect:/teampictureboardList.do";
		logger.info("update => " + page);
		return page;
	}
	
	
	public ArrayList<TeamBoardDTO> tpcommentList(String bidx) {
		return dao.tpcommentList(bidx);
	}

	public void tpcommentWrite(HashMap<String, String> params) {
		dao.tpcommentWrite(params);
	}

	public void tpcommentDelete(String commentIdx) {
		dao.tpcommentDelete(commentIdx);
	}

	public TeamBoardDTO tpcommentGet(String commentIdx) {
		return dao.tpcommentGet(commentIdx);
	}

	public void tpcommentUpdate(HashMap<String, String> params) {
		dao.tpcommentUpdate(params);
	}

	public void tpboardReport(HashMap<String, String> params) {
		dao.tpboardReport(params);
		
	}

	public void tpboardCommentReport(HashMap<String, String> params) {
		dao.tpboardCommentReport(params);	
	}
	
};

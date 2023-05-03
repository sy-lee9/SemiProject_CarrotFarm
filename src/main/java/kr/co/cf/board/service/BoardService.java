package kr.co.cf.board.service;

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

import kr.co.cf.board.dao.BoardDAO;
import kr.co.cf.board.dto.BoardDTO;

@Service
public class BoardService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired BoardDAO dao;

	public ArrayList<BoardDTO> flist() {
		return dao.flist();
	}
	
	public HashMap<String, Object> falist(int page, int cnt) {
		logger.info(page + "페이지 보여줘");
		logger.info("한 페이지에 " + cnt + "개씩 보여줄거야");
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		 // 1page = offset:0
		 // 2page = offset:5
		 // 3page = offset:10
		int offset =(page-1) * cnt;
		
		// 만들 수 있는 총 페이지 수
		// 전체 게시물 / 페이지당 보여줄 수
		int total = dao.fatotalCount();
		int range = total%cnt == 0 ? total/cnt : (total/cnt)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		
		
		ArrayList<BoardDTO> falist = dao.falist(cnt, offset);
		map.put("freeboardList", falist);
		return map;
	}
	
	
	

	public String fwrite(MultipartFile photo, HashMap<String, String> params) {
		
		String page = "redirect:/freeboardList.do";
		BoardDTO dto = new BoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setContent(params.get("content"));
		dto.setUserId(params.get("userId"));
		dto.setCategoryId(params.get("categoryId"));
		
		int row = dao.fwrite(dto);
		logger.info("업데이트 row : " + row);
		
		int bidx = dto.getBoardIdx();
		logger.info("방금 인서트한 bidx : " + bidx);
		
		page = "redirect:/freeboardDetail.do?bidx=" + bidx;
		
		if (!photo.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			
			ffileSave(bidx,photo);
		}
		return page;
	}
		
	private void ffileSave(int photoIdx, MultipartFile photo) {
		String OriginalFileName = photo.getOriginalFilename();
		String ext = OriginalFileName.substring(OriginalFileName.lastIndexOf("."));
		String photoId = System.currentTimeMillis() + ext;
		logger.info(OriginalFileName + " -> " + photoId);
		
		try {
			byte[] bytes = photo.getBytes();
			Path path = Paths.get("C:/img/upload/" + photoId);
			Files.write(path,bytes);
			logger.info(photoId + "세이브 완료");
			dao.ffileWrite(photoIdx, photoId);
			logger.info("포토인덱스 : " + photoIdx + "포토네임 : " + photoId);
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
	}

	public BoardDTO fdetail(String boardIdx, String flag) {
		if(flag.equals("detail")) {
			dao.fupHit(boardIdx);
		}
		BoardDTO dto = dao.fdetail(boardIdx);
		
		logger.info("사진이름" +dto.getPhotoName());
		return dto;
	}

	public void fdelete(String bidx) {
		String newFileName = dao.ffindFile(bidx);
		logger.info("파일 이름 : " + newFileName);
		
		int row = dao.fdelete(bidx);
		logger.info("삭제 데이터 : " + row);
		
		if (newFileName != null && row > 0) {
			File file = new File("C:/img/upload/" + newFileName);
			if (file.exists()) {
				file.delete();
			}
		}
	}

	public String fupdate(MultipartFile photo, HashMap<String, String> params) {
		int bidx = Integer.parseInt(params.get("bidx"));
		int row = dao.fupdate(params);
		logger.info("bidx 값 : " + bidx);
		logger.info("row 값 : " + row);
		
		// 2. photo에 파일명이 존재 한다면?
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			ffileSave(bidx,photo);
		}
		
		String page = row >0 ? "redirect:/freeboardDetail.do?bidx=" + bidx : "redirect:/freeboardList.do";
		logger.info("update => " + page);
		return page;
	}

	
	
	
	
	
	
	
	
	public ArrayList<BoardDTO> nlist() {
		return dao.nlist();
	}

	public String nwrite(MultipartFile photo, HashMap<String, String> params) {
		
		String page = "redirect:/noticeboardList.do";
		BoardDTO dto = new BoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setContent(params.get("content"));
		dto.setUserId(params.get("userId"));
		dto.setCategoryId(params.get("categoryId"));
		
		int row = dao.nwrite(dto);
		logger.info("업데이트 row : " + row);
		
		int bidx = dto.getBoardIdx();
		logger.info("방금 인서트한 bidx : " + bidx);
		
		page = "redirect:/noticeboardDetail.do?bidx=" + bidx;
		
		if (!photo.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			
			nfileSave(bidx,photo);
		}
		return page;
	}

	private void nfileSave(int photoIdx, MultipartFile photo) {
		String OriginalFileName = photo.getOriginalFilename();
		String ext = OriginalFileName.substring(OriginalFileName.lastIndexOf("."));
		String photoId = System.currentTimeMillis() + ext;
		logger.info(OriginalFileName + " -> " + photoId);
		
		try {
			byte[] bytes = photo.getBytes();
			Path path = Paths.get("C:/img/upload/" + photoId);
			Files.write(path,bytes);
			logger.info(photoId + "세이브 완료");
			dao.nfileWrite(photoIdx, photoId);
			logger.info("포토인덱스 : " + photoIdx + "포토네임 : " + photoId);
		} catch (IOException e) {			
			e.printStackTrace();
		}
	}
	
	public BoardDTO ndetail(String boardIdx, String flag) {
		if(flag.equals("detail")) {
			dao.nupHit(boardIdx);
		}
		BoardDTO dto = dao.ndetail(boardIdx);
		
		logger.info("사진이름" +dto.getPhotoName());
		return dto;
	}

	public void ndelete(String bidx) {
		String newFileName = dao.ffindFile(bidx);
		logger.info("파일 이름 : " + newFileName);
		
		int row = dao.ndelete(bidx);
		logger.info("삭제 데이터 : " + row);
		
		if (newFileName != null && row > 0) {
			File file = new File("C:/img/upload/" + newFileName);
			if (file.exists()) {
				file.delete();
			}
		}
	}

	public String nupdate(MultipartFile photo, HashMap<String, String> params) {
		int bidx = Integer.parseInt(params.get("bidx"));
		int row = dao.nupdate(params);
		logger.info("bidx 값 : " + bidx);
		logger.info("row 값 : " + row);
		
		// 2. photo에 파일명이 존재 한다면?
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			nfileSave(bidx,photo);
		}
		
		String page = row >0 ? "redirect:/noticeboardDetail.do?bidx=" + bidx : "redirect:/noticeboardList.do";
		logger.info("update => " + page);
		return page;
	}

	
	
}	
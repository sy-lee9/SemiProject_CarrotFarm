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
	
	public HashMap<String, Object> falist(int page, String search) {
		
		logger.info(page + "페이지 보여줘");
		logger.info("search : " + search);

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		int offset =(page-1) * 10;
		
		int total = dao.fatotalCount();
		
		if (search.equals("default") || search.equals("")) {
			total = dao.fatotalCount();
			
		} else {
			total = dao.fatotalCountSearch(search);
		};
		
		

		int range = total%10 == 0 ? total/10 : (total/10)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		ArrayList<BoardDTO> falist = dao.falist(10, offset);
		
		//params.put("offset", offset);
		
		if (search.equals("default") || search.equals("")) {
			falist = dao.falist(10, offset);
			
		} else {
			falist = dao.falistSearch(search);
		}
		
		map.put("currPage", page);
		map.put("pages", range);
		
		map.put("freeboardList", falist);
		return map;
	}
	
	public String fwrite(MultipartFile photo, HashMap<String, String> params) {
		
		String page = "redirect:/freeboardList.do";
		BoardDTO dto = new BoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setUserId(params.get("userId"));
		dto.setContent(params.get("content"));
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
		logger.info("boardIdx : " + boardIdx);
		logger.info("dto : " + dto);
		
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
		
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			ffileSave(bidx,photo);
		}
		
		String page = row >0 ? "redirect:/freeboardDetail.do?bidx=" + bidx : "redirect:/freeboardList.do";
		logger.info("update => " + page);
		return page;
	}
	
	
	public ArrayList<BoardDTO> fcommentList(String bidx) {
		return dao.fcommentList(bidx);
	}

	public void fcommentWrite(HashMap<String, String> params) {
		dao.fcommentWrite(params);
	}

	public void fcommentDelete(String commentIdx) {
		dao.fcommentDelete(commentIdx);
	}

	public BoardDTO fcommentGet(String commentIdx) {
		return dao.fcommentGet(commentIdx);
	}

	public void fcommentUpdate(HashMap<String, String> params) {
		dao.fcommentUpdate(params);
	}

	public void fboardReport(HashMap<String, String> params) {
		dao.fboardReport(params);
		
	}

	public void fboardCommentReport(HashMap<String, String> params) {
		dao.fboardCommentReport(params);
		
	}
	
	public void fdownHit(String bidx) {
		dao.fdownHit(bidx);
		
	}
	

	
	
	
	
	
	public ArrayList<BoardDTO> nlist() {
		return dao.nlist();
	}
	
	public HashMap<String, Object> nalist(int page, String search) {
		
		logger.info(page + "페이지 보여줘");
		logger.info("search : " + search);

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		int offset =(page-1) * 10;
		
		int total = dao.natotalCount();
		
		if (search.equals("default") || search.equals("")) {
			total = dao.natotalCount();
			
		} else {
			total = dao.natotalCountSearch(search);
		};
		
		

		int range = total%10 == 0 ? total/10 : (total/10)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		ArrayList<BoardDTO> nalist = dao.nalist(10, offset);
		
		//params.put("offset", offset);
		
		if (search.equals("default") || search.equals("")) {
			nalist = dao.nalist(10, offset);
			
		} else {
			nalist = dao.nalistSearch(search);
		}
		
		map.put("currPage", page);
		map.put("pages", range);
		
		map.put("noticeboardList", nalist);
		return map;
	}
	
	public String nwrite(MultipartFile photo, HashMap<String, String> params) {
		
		String page = "redirect:/noticeboardList.do";
		BoardDTO dto = new BoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setUserId(params.get("userId"));
		dto.setContent(params.get("content"));
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
		logger.info("boardIdx : " + boardIdx);
		logger.info("dto : " + dto);
		
		logger.info("사진이름" +dto.getPhotoName());
		return dto;
	}

	public void ndelete(String bidx) {
		String newFileName = dao.nfindFile(bidx);
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
		
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			nfileSave(bidx,photo);
		}
		
		String page = row >0 ? "redirect:/noticeboardDetail.do?bidx=" + bidx : "redirect:/noticeboardList.do";
		logger.info("update => " + page);
		return page;
	}


	public void nboardReport(HashMap<String, String> params) {
		dao.nboardReport(params);
		
	}

	public void nboardCommentReport(HashMap<String, String> params) {
		dao.nboardCommentReport(params);
		
	}
	
	public void ndownHit(String bidx) {
		dao.ndownHit(bidx);
		
	}
	
	public String nuserRight(String loginId) {
		return dao.nuserRight(loginId);
	}
	
	/*public ArrayList<BoardDTO> nlist() {
		return dao.nlist();
	}
	
	public HashMap<String, Object> nalist(int page, int cnt) {
		logger.info(page + "페이지 보여줘");
		logger.info("한 페이지에 " + cnt + "개씩 보여줄거야");
		HashMap<String, Object> map = new HashMap<String, Object>();
		

		int offset =(page-1) * cnt;
		
		int total = dao.natotalCount();
		int range = total%cnt == 0 ? total/cnt : (total/cnt)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		
		ArrayList<BoardDTO> nalist = dao.nalist(cnt, offset);
		map.put("noticeboardList", nalist);
		return map;
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
		String newFileName = dao.nfindFile(bidx);
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

	
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	public ArrayList<BoardDTO> ilist() {
		return dao.ilist();
	}
	
	public HashMap<String, Object> ialist(int page, int cnt) {
		logger.info(page + "페이지 보여줘");
		logger.info("한 페이지에 " + cnt + "개씩 보여줄거야");
		HashMap<String, Object> map = new HashMap<String, Object>();
		

		int offset =(page-1) * cnt;
		
		int total = dao.iatotalCount();
		int range = total%cnt == 0 ? total/cnt : (total/cnt)+1;
		logger.info("전체 게시물 수 : " + total);
		logger.info("총 페이지 수 : " + range);
		
		page = page >range ? range : page;
		
		map.put("currPage", page);
		map.put("pages", range);
		
		ArrayList<BoardDTO> ialist = dao.ialist(cnt, offset);
		map.put("inquiryboardList", ialist);
		return map;
	}

	public String iwrite(MultipartFile photo, HashMap<String, String> params) {
		
		String page = "redirect:/inquiryboardList.do";
		BoardDTO dto = new BoardDTO();
		dto.setSubject(params.get("subject"));
		dto.setContent(params.get("content"));
		dto.setUserId(params.get("userId"));
		dto.setCategoryId(params.get("categoryId"));
		
		int row = dao.iwrite(dto);
		logger.info("업데이트 row : " + row);
		
		int bidx = dto.getBoardIdx();
		logger.info("방금 인서트한 bidx : " + bidx);
		
		page = "redirect:/inquiryboardDetail.do?bidx=" + bidx;
		
		if (!photo.getOriginalFilename().equals("")) {
			logger.info("파일 업로드 작업");
			
			ifileSave(bidx,photo);
		}
		return page;
	}

	private void ifileSave(int photoIdx, MultipartFile photo) {
		String OriginalFileName = photo.getOriginalFilename();
		String ext = OriginalFileName.substring(OriginalFileName.lastIndexOf("."));
		String photoId = System.currentTimeMillis() + ext;
		logger.info(OriginalFileName + " -> " + photoId);
		
		try {
			byte[] bytes = photo.getBytes();
			Path path = Paths.get("C:/img/upload/" + photoId);
			Files.write(path,bytes);
			logger.info(photoId + "세이브 완료");
			dao.ifileWrite(photoIdx, photoId);
			logger.info("포토인덱스 : " + photoIdx + "포토네임 : " + photoId);
		} catch (IOException e) {			
			e.printStackTrace();
		}
	}
	
	public BoardDTO idetail(String boardIdx, String flag) {
		if(flag.equals("detail")) {
			dao.iupHit(boardIdx);
		}
		BoardDTO dto = dao.idetail(boardIdx);
		
		logger.info("사진이름" +dto.getPhotoName());
		return dto;
	}

	public void idelete(String bidx) {
		String newFileName = dao.ifindFile(bidx);
		logger.info("파일 이름 : " + newFileName);
		
		int row = dao.idelete(bidx);
		logger.info("삭제 데이터 : " + row);
		
		if (newFileName != null && row > 0) {
			File file = new File("C:/img/upload/" + newFileName);
			if (file.exists()) {
				file.delete();
			}
		}
	}

	public String iupdate(MultipartFile photo, HashMap<String, String> params) {
		int bidx = Integer.parseInt(params.get("bidx"));
		int row = dao.iupdate(params);
		logger.info("bidx 값 : " + bidx);
		logger.info("row 값 : " + row);
		
		// 2. photo에 파일명이 존재 한다면?
		if(photo != null && !photo.getOriginalFilename().equals("")) {
			ifileSave(bidx,photo);
		}
		
		String page = row >0 ? "redirect:/inquiryboardDetail.do?bidx=" + bidx : "redirect:/inquiryboardList.do";
		logger.info("update => " + page);
		return page;
	}

	public String iuserRight(String loginId) {
		return dao.iuserRight(loginId);
	}



	
}	
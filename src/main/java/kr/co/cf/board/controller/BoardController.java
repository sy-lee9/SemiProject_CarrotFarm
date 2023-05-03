package kr.co.cf.board.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.cf.board.dto.BoardDTO;
import kr.co.cf.board.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired BoardService service;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value="/list.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> list(@RequestParam String page, @RequestParam String cnt){
		
		return service.falist(Integer.parseInt(page),Integer.parseInt(cnt));
	}
	
	
	@RequestMapping(value = "/freeboardList.do")
	public String flist(Model model) {
		logger.info("flist 불러오기");
		ArrayList<BoardDTO> flist = service.flist();
		logger.info("flist cnt : " + flist.size());
		model.addAttribute("list", flist);
		return "freeboardList";
	}
	
	@RequestMapping(value="/freeboardWrite.go")
	public String fwriteForm() {
		logger.info("글쓰기로 이동");
		return "freeboardWriteForm";
	}
	
	@RequestMapping(value="/freeboardWrite.do", method=RequestMethod.POST)
	public String fwrite(MultipartFile photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		return service.fwrite(photo, params);
	}
	
	@RequestMapping(value="/freeboardDetail.do")
	public String fdetail(Model model, @RequestParam String bidx) {
		logger.info("fdetail : " + bidx);
		String page = "redirect:/freeboardList.do";
		
		BoardDTO dto = service.fdetail(bidx,"detail");
		if(dto != null) {
			page = "freeboardDetail";
			model.addAttribute("dto", dto);
			logger.info("사진이름" +dto.getPhotoName());
		}
		return page;
	}
	
	@RequestMapping(value = "/freeboardDelete.do")
	public String fdelete(@RequestParam String bidx) {
		service.fdelete(bidx);
		return "redirect:/freeboardList.do";
	}
	
	@RequestMapping(value = "/freeboardUpdate.go")
	public String fupdateForm(Model model, @RequestParam String bidx) {
		logger.info("fupdate : " + bidx);
		String page = "redirect:/freeboardList.do";
		
		BoardDTO dto = service.fdetail(bidx,"freeboardUpdate");
		logger.info("dto 들어갔음? : " + dto);
		if(dto != null) {
			page = "freeboardUpdateForm";
			model.addAttribute("dto", dto);
		}
		return page;
	}
	
	@RequestMapping(value="/freeboardUpdate.do", method=RequestMethod.POST)
	public String fupdate(MultipartFile photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		return service.fupdate(photo, params);
	}
	
	
	
	
	
	
	
	
	@RequestMapping(value = {"/noticeboardList.do"})
	public String nlist(Model model) {
		logger.info("nlist 불러오기");
		ArrayList<BoardDTO> nlist = service.nlist();
		logger.info("flist cnt : " + nlist.size());
		model.addAttribute("list", nlist);
		return "noticeboardList";
	}
	
	@RequestMapping(value="/noticeboardWrite.go")
	public String nwriteForm() {
		logger.info("글쓰기로 이동");
		return "noticeboardWriteForm";
	}
	
	@RequestMapping(value="/noticeboardWrite.do", method=RequestMethod.POST)
	public String nwrite(MultipartFile photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		return service.nwrite(photo, params);
	}
	
	@RequestMapping(value="/noticeboardDetail.do")
	public String ndetail(Model model, @RequestParam String bidx) {
		logger.info("ndetail : " + bidx);
		String page = "redirect:/noticeboardList.do";
		
		BoardDTO dto = service.ndetail(bidx,"detail");
		if(dto != null) {
			page = "noticeboardDetail";
			model.addAttribute("dto", dto);
			logger.info("사진이름" +dto.getPhotoName());
		}
		return page;
	}
	
	@RequestMapping(value = "/noticeboardDelete.do")
	public String ndelete(@RequestParam String bidx) {
		service.ndelete(bidx);
		return "redirect:/noticeboardList.do";
	}
	
	@RequestMapping(value = "/noticeboardUpdate.go")
	public String nupdateForm(Model model, @RequestParam String bidx) {
		logger.info("nupdate : " + bidx);
		String page = "redirect:/noticeboardList.do";
		
		BoardDTO dto = service.ndetail(bidx,"noticeboardUpdate");
		logger.info("dto 들어갔음? : " + dto);
		if(dto != null) {
			page = "noticeboardUpdateForm";
			model.addAttribute("dto", dto);
		}
		return page;
	}
	
	@RequestMapping(value="/noticeboardUpdate.do", method=RequestMethod.POST)
	public String nupdate(MultipartFile photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		return service.nupdate(photo, params);
	}
	
	
	
}

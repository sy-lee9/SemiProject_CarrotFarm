package kr.co.cf.team.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

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

import kr.co.cf.team.dto.TeamBoardDTO;
import kr.co.cf.team.service.TeamBoardService;

@Controller
public class TeamBoardController {
	
	@Autowired TeamBoardService service;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value="/tplist.ajax", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> tpalist(@RequestParam String page, @RequestParam String search){
		logger.info("search : " + search);
		
		return service.tpalist(Integer.parseInt(page), search);
		
	}
	
	@RequestMapping(value = "/teampictureboardList.do")
	public String flist(Model model, HttpSession session) {
		logger.info("session : " + session.getAttribute("loginId"));
		logger.info("tplist 불러오기");
		ArrayList<TeamBoardDTO> tplist = service.tplist();
		logger.info("tplist cnt : " + tplist.size());
		model.addAttribute("list", tplist);
		return "teampictureboardList";
	}
	
	@RequestMapping(value="/teampictureboardWrite.go")
	public String tpwriteForm(Model model, HttpSession session) {
		
		logger.info("글쓰기로 이동");
		model.addAttribute("userId", session.getAttribute("loginId"));
		return "teampictureboardWriteForm";
	}
	
	@RequestMapping(value="/teampictureboardWrite.do", method=RequestMethod.POST)
	public String tpwrite(MultipartFile[] photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		logger.info("fileName : "+photo);
		return service.tpwrite(photo, params);
	}	
	
	@RequestMapping(value="/teampictureboardDetail.do")
	public String tpdetail(Model model, @RequestParam String bidx, HttpSession session) {
		logger.info("tpdetail : " + bidx);
		String page = "redirect:/teampictureboardList.do";
		
		if(session.getAttribute("loginId") == null) {logger.info("로그인된 아이디가 없습니다. ");}
		logger.info("게시글 bidx : " + bidx + "번 상세보기");
		
		ArrayList<TeamBoardDTO> dto = service.tpdetail(bidx,"detail");
		
		if(dto != null) {
			page = "teampictureboardDetail";
			model.addAttribute("dto", dto);

		}
	
		ArrayList<TeamBoardDTO> tpcommentList = new ArrayList<TeamBoardDTO>();
		tpcommentList = service.tpcommentList(bidx);
		model.addAttribute("tpcommentList", tpcommentList);
		logger.info("모집글 tpcommentList : " + tpcommentList);
		return "/teampictureboardDetail";

	}
	
	
	@RequestMapping(value = "/teampictureboardDelete.do")
	public String tpdelete(@RequestParam String bidx) {
		service.tpdelete(bidx);
		return "redirect:/teampictureboardList.do";
	}
	
	@RequestMapping(value = "/teampictureboardUpdate.go")
	public String tpupdateForm(Model model, @RequestParam String bidx) {
		logger.info("tpupdate : " + bidx);
		String page = "redirect:/teampictureboardList.do";
		
		ArrayList<TeamBoardDTO> dto = service.tpdetail(bidx,"teampictureboardUpdate");

		if(dto != null) {
			page = "teampictureboardUpdateForm";
			model.addAttribute("dto", dto);
		}
		return page;
	}
	
	@RequestMapping(value="/teampictureboardUpdate.do", method=RequestMethod.POST)
	public String tpupdate(MultipartFile photo, @RequestParam HashMap<String, String> params) {
		logger.info("Params : " + params);
		return service.tpupdate(photo, params);
	}
	

	@RequestMapping(value = "teampictureboardcommentWrite.do")
	public String tpcommentWrite(@RequestParam HashMap<String, String> params) {

		logger.info("댓글 작성" + params);

		service.tpcommentWrite(params);
		return "redirect:/teampictureboardDetail.do?bidx=" + params.get("comentId");
	}
	
	@RequestMapping(value = "teampictureboardcommentDelete.do")
	public String tpcommentDelete(@RequestParam String commentIdx,@RequestParam String bidx) {

		logger.info("댓글 지우기 commentIdx : " + commentIdx);
		service.tpcommentDelete(commentIdx);
		return "redirect:/teampictureboardDetail.do?bidx=" + bidx ;
	}
	
	
	@RequestMapping(value = "teampictureboardcommentUpdate.go")
	public String tpcommentUpdateGo(@RequestParam String commentIdx,@RequestParam String bidx, Model model, HttpSession session) {

		logger.info("댓글 수정 commentIdx : " + commentIdx);
		
		//TeamBoardDTO dto = new TeamBoardDTO();
		ArrayList<TeamBoardDTO> dto = service.tpdetail(bidx, commentIdx);
		model.addAttribute("dto", dto);

		ArrayList<TeamBoardDTO> tpcommentList = new ArrayList<TeamBoardDTO>();
		tpcommentList = service.tpcommentList(bidx);
		model.addAttribute("tpcommentList", tpcommentList);
		logger.info("모집글 tpcommentList : " + tpcommentList);
		
		if(session.getAttribute("loginId") == null) {
			model.addAttribute("loginId", "guest");
		};
		
		
		if(session.getAttribute("loginId") != null) {
		TeamBoardDTO tpcommentDto = new TeamBoardDTO();
		tpcommentDto = service.tpcommentGet(commentIdx);
		logger.info("수정할 코멘트 내용 : " +tpcommentDto.getCommentContent());
		model.addAttribute("tpcommentDto", tpcommentDto);
				
		};
		return "/teampictureboardCommentUpdate" ;
	}
	
	@RequestMapping(value = "teampictureboardcommentUpdate.do")
	public String tpcommentUpdateGo(@RequestParam HashMap<String, String> params) {

		service.tpcommentUpdate(params);
		String bidx = params.get("bidx");
		logger.info("bidx : "+ bidx);		
		return "redirect:/teampictureboardDetail.do?bidx="+bidx ;
	};
	
	@RequestMapping(value= "teampictureboardReport.go")
	public String tpboardReportGo(Model model, @RequestParam String bidx, HttpSession session) {
		
		TeamBoardDTO dto = new TeamBoardDTO();
		dto.setBidx(Integer.parseInt(bidx));
		
		model.addAttribute("dto", dto);
		return "teampictureboardReportDo";
	};
	
	@RequestMapping(value= "teampictureboardReport.do")
	public String tpboardReportDo(@RequestParam HashMap<String, String> params) {
		logger.info("params : " + params);
		
		params.put("reportContent", params.get("report") + " : " + params.get("content"));
		service.tpboardReport(params);
		return "tpboardReportSubmit";
	};
	
	@RequestMapping(value= "teampictureboardCReport.go")
	public String tpboardCReportGo(Model model, String commentIdx, HttpSession session) {
		
		TeamBoardDTO dto = new TeamBoardDTO();
		dto.setCommentIdx(commentIdx);
		
		model.addAttribute("dto", dto);
		return "teampictureboardCommentReportDo";
	};
	
	@RequestMapping(value= "teampictureboardCReport.do")
	public String tpboardCReportDo(@RequestParam HashMap<String, String> params) {
		logger.info("params : " + params);
		
		params.put("reportContent", params.get("report") + " : " + params.get("content"));
		service.tpboardCommentReport(params);
		return "tpboardReportSubmit";
	};
};
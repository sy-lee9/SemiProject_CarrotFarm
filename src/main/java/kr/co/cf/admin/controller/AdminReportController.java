package kr.co.cf.admin.controller;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.cf.admin.dto.AdminReportDTO;
import kr.co.cf.admin.service.AdminReportService;

@Controller
public class AdminReportController {
	
	@Autowired AdminReportService adminReportService;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value="/adminReport")
	public String adminReport() {
		return "/admin/adminReport";
	}
	@RequestMapping(value="/adminReportList.ajax")
	@ResponseBody
	public HashMap<String, Object> adminReportList(@RequestParam HashMap<String, String> params){
		logger.info("리스트 출력 :"+params);
		return adminReportService.adminReportList(params);
	}
	
	@RequestMapping(value="/adminReportDetail.go")
	public String adminReportDetailGO(@RequestParam String reportIdx, Model model) {
		AdminReportDTO reportInfo = adminReportService.reportInfo(reportIdx);
		model.addAttribute("reportInfo",reportInfo);
		return "/admin/adminReportDetail";
	}

}

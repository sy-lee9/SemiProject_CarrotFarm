package kr.co.cf.admin.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.cf.admin.dao.AdminReportDAO;
import kr.co.cf.admin.dto.AdminReportDTO;


@Service
public class AdminReportService {
	@Autowired AdminReportDAO adminReportdao;
	Logger logger = LoggerFactory.getLogger(this.getClass());

	public HashMap<String, Object> adminReportList(HashMap<String, String> params) {
		String page = params.get("page");
		String category=params.get("category");
		String searchText = params.get("searchText");
		String searchCategory=params.get("searchCategory");
		String reportState=params.get("reportState");
		HashMap<String, Object> map = new HashMap<String, Object>();
		ArrayList<AdminReportDTO> list = new ArrayList<AdminReportDTO>();
		int offSet = (Integer.parseInt(page)-1)*10;
		
		if(searchText.equals("default")) {
			if(category.equals("default") && reportState.equals("default")) {
			// 전체 보여주기
				int reportCnt = adminReportdao.reportCnt();
				map.put("totalList", reportCnt);
				list=adminReportdao.reportList(offSet);
				map.put("list", list);
			}else if(!category.equals("default") && reportState.equals("default")) {
				// category에 따라 출력
				int categoryCnt = adminReportdao.categoryCnt(category);
				map.put("totalList", categoryCnt);
				list=adminReportdao.categoryList(category,offSet);
				map.put("list", list);
			}else if(category.equals("default") && !reportState.equals("default")) {
				// 처리상태에 따라 출력
				int reportStateCnt = adminReportdao.reportStateCnt(reportState);
				map.put("totalList", reportStateCnt);
				list=adminReportdao.reportStateList(reportState,offSet);
				map.put("list", list);
			}else {
				//처리 상태 + 카테고리에 따라 출력
				int sortCnt = adminReportdao.sortCnt(reportState,category);
				map.put("totalList", sortCnt);
				list=adminReportdao.sortList(reportState,category,offSet);
				map.put("list", list);
			}
		}else {
			if(searchCategory.equals("default")) {
				//검색 종류 없이 검색어에 따라 출력
				int reportSearchCnt = adminReportdao.reportSearchCnt(searchText);
				map.put("totalList", reportSearchCnt);
				list=adminReportdao.reportSearchList(searchText,offSet);
				map.put("list", list);
			}else {
				//검색어 종류가 있을 때
				int searchCategoryCnt = adminReportdao.searchCategoryCnt(searchCategory,searchText);
				map.put("totalList", searchCategoryCnt);
				list=adminReportdao.searchCategoryList(searchCategory,searchText,offSet);
				map.put("list", list);
			}
		}
		return map;
	}

	public AdminReportDTO reportInfo(String reportIdx) {
		return adminReportdao.reportInfo(reportIdx);
		
	}
	

}

package kr.co.cf.admin.dao;

import java.util.ArrayList;

import kr.co.cf.admin.dto.AdminReportDTO;
import kr.co.cf.admin.dto.AdminUserDTO;

public interface AdminReportDAO {

	int reportCnt();

	ArrayList<AdminReportDTO> reportList(int offSet);

	int categoryCnt(String category);

	ArrayList<AdminReportDTO> categoryList(String category, int offSet);

	int reportStateCnt(String reportState);

	ArrayList<AdminReportDTO> reportStateList(String reportState, int offSet);

	int sortCnt(String reportState, String category);

	ArrayList<AdminReportDTO> sortList(String reportState, String category, int offSet);

	int reportSearchCnt(String searchText);

	ArrayList<AdminReportDTO> reportSearchList(String searchText, int offSet);

	int searchCategoryCnt(String searchCategory, String searchText);

	ArrayList<AdminReportDTO> searchCategoryList(String searchCategory, String searchText, int offSet);

	AdminReportDTO reportInfo(String reportIdx);

}

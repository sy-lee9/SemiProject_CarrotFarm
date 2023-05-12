package kr.co.cf.admin.dto;

public class AdminReportDTO {
	private int reportIdx;
	private String categoryId;
	private String userId;
	private String reportContent;
	private String reportState;
	private int reportId;
	private String reportUserId;
	public int getReportIdx() {
		return reportIdx;
	}
	public void setReportIdx(int reportIdx) {
		this.reportIdx = reportIdx;
	}
	public String getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getReportContent() {
		return reportContent;
	}
	public void setReportContent(String reportContent) {
		this.reportContent = reportContent;
	}
	public String getReportState() {
		return reportState;
	}
	public void setReportState(String reportState) {
		this.reportState = reportState;
	}
	public int getReportId() {
		return reportId;
	}
	public void setReportId(int reportId) {
		this.reportId = reportId;
	}
	public String getReportUserId() {
		return reportUserId;
	}
	public void setReportUserId(String reportUserId) {
		this.reportUserId = reportUserId;
	}
	
	
}

package kr.co.cf.team.dto;

public class TeamDTO {
	
	private int teamIdx;
	private String teamName;
	private String teamFavTime;
	private int teamFavNum;
	private String teamIntroduce;
	private String teamMatchState;
	private boolean teamDisband;
	private int locationIdx;
	private int teamManner;
	private int teamUser;
	private String photoName;
	private String tagContent;
	private String gu;
	private String userId;
	
	public int getTeamIdx() {
		return teamIdx;
	}
	public void setTeamIdx(int teamIdx) {
		this.teamIdx = teamIdx;
	}
	public String getTeamName() {
		return teamName;
	}
	public void setTeamName(String teamName) {
		this.teamName = teamName;
	}
	public String getTeamFavTime() {
		return teamFavTime;
	}
	public void setTeamFavTime(String teamFavTime) {
		this.teamFavTime = teamFavTime;
	}
	public int getTeamFavNum() {
		return teamFavNum;
	}
	public void setTeamFavNum(int teamFavNum) {
		this.teamFavNum = teamFavNum;
	}
	public String getTeamIntroduce() {
		return teamIntroduce;
	}
	public void setTeamIntroduce(String teamIntroduce) {
		this.teamIntroduce = teamIntroduce;
	}
	public String getTeamMatchState() {
		return teamMatchState;
	}
	public void setTeamMatchState(String teamMatchState) {
		this.teamMatchState = teamMatchState;
	}
	public boolean isTeamDisband() {
		return teamDisband;
	}
	public void setTeamDisband(boolean teamDisband) {
		this.teamDisband = teamDisband;
	}
	public int getLocationIdx() {
		return locationIdx;
	}
	public void setLocationIdx(int locationIdx) {
		this.locationIdx = locationIdx;
	}
	public int getTeamManner() {
		return teamManner;
	}
	public void setTeamManner(int teamManner) {
		this.teamManner = teamManner;
	}
	public int getTeamUser() {
		return teamUser;
	}
	public void setTeamUser(int teamUser) {
		this.teamUser = teamUser;
	}
	public String getPhotoName() {
		return photoName;
	}
	public void setPhotoName(String photoName) {
		this.photoName = photoName;
	}
	public String getTagContent() {
		return tagContent;
	}
	public void setTagContent(String tagContent) {
		this.tagContent = tagContent;
	}
	public String getGu() {
		return gu;
	}
	public void setGu(String gu) {
		this.gu = gu;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
}
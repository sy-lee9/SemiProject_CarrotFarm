package kr.co.cf.team.dto;

public class TeamDTO {
	
	private String teamName;
	private String teamFavTime;
	private int teamFavNum;
	private String teamIntroduce;
	private String teamMatchState;
	private boolean teamDisband;
	private int locationIdx;

	public int getLocationIdx() {
		return locationIdx;
	}

	public void setLocationIdx(int locationIdx) {
		this.locationIdx = locationIdx;
	}

	public String isTeamMatchState() {
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

}

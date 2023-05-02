package kr.co.cf.court.dto;

public class CourtDTO {
	private int courtIdx;
	private int locationId;
	private String courtName;
	private String courtTel;
	private String courtInOut;
	private String courtState;
	private double courtLatitude;
	private double courtLongitude;
	public int getCourtIdx() {
		return courtIdx;
	}
	public void setCourtIdx(int courtIdx) {
		this.courtIdx = courtIdx;
	}
	public int getLocationId() {
		return locationId;
	}
	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}
	public String getCourtName() {
		return courtName;
	}
	public void setCourtName(String courtName) {
		this.courtName = courtName;
	}
	public String getCourtTel() {
		return courtTel;
	}
	public void setCourtTel(String courtTel) {
		this.courtTel = courtTel;
	}
	public String getCourtInOut() {
		return courtInOut;
	}
	public void setCourtInOut(String courtInOut) {
		this.courtInOut = courtInOut;
	}
	public String getCourtState() {
		return courtState;
	}
	public void setCourtState(String courtState) {
		this.courtState = courtState;
	}
	public double getCourtLatitude() {
		return courtLatitude;
	}
	public void setCourtLatitude(double courtLatitude) {
		this.courtLatitude = courtLatitude;
	}
	public double getCourtLongitude() {
		return courtLongitude;
	}
	public void setCourtLongitude(double courtLongitude) {
		this.courtLongitude = courtLongitude;
	}
	
	
}

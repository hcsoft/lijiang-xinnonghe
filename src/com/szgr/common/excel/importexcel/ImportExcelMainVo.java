package com.szgr.common.excel.importexcel;

import java.util.List;

public class ImportExcelMainVo {

	private String mainid;
	private String configname;
	private Integer startrow;
	private Integer endrow;
	private String receiveobj;
	private String procobj;
	
	private List<ImportExcelSubVo> subList;
	
	public String getMainid() {
		return mainid;
	}
	public void setMainid(String mainid) {
		this.mainid = mainid;
	}
	public String getConfigname() {
		return configname;
	}
	public void setConfigname(String configname) {
		this.configname = configname;
	}
	public Integer getStartrow() {
		return startrow;
	}
	public void setStartrow(Integer startrow) {
		this.startrow = startrow;
	}
	public Integer getEndrow() {
		return endrow;
	}
	public void setEndrow(Integer endrow) {
		this.endrow = endrow;
	}
	public String getReceiveobj() {
		return receiveobj;
	}
	public void setReceiveobj(String receiveobj) {
		this.receiveobj = receiveobj;
	}
	public String getProcobj() {
		return procobj;
	}
	public void setProcobj(String procobj) {
		this.procobj = procobj;
	}
	public List<ImportExcelSubVo> getSubList() {
		return subList;
	}
	public void setSubList(List<ImportExcelSubVo> subList) {
		this.subList = subList;
	}
	
}

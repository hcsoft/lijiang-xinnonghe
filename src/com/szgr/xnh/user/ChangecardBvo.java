package com.szgr.xnh.user;

import com.szgr.vo.XnhUserVO;

public class ChangecardBvo extends XnhUserVO{

	private String old_card_id;
	private String new_card_id;
	public String getOld_card_id() {
		return old_card_id;
	}
	public void setOld_card_id(String old_card_id) {
		this.old_card_id = old_card_id;
	}
	public String getNew_card_id() {
		return new_card_id;
	}
	public void setNew_card_id(String new_card_id) {
		this.new_card_id = new_card_id;
	}
	
	
}

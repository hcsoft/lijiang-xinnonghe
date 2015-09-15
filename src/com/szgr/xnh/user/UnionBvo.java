package com.szgr.xnh.user;

import java.util.ArrayList;
import java.util.List;

import com.szgr.vo.XnhUserVO;

public class UnionBvo extends XnhUserVO{
	
	List<XnhUserVO> memberlist = new ArrayList<XnhUserVO>();

	public List<XnhUserVO> getMemberlist() {
		return memberlist;
	}

	public void setMemberlist(List<XnhUserVO> memberlist) {
		this.memberlist = memberlist;
	}
	
	

}

package com.szgr.common.upload;

import net.sf.json.JSONArray;

public class TTT {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		JSONArray users = new JSONArray();
		AttachmentBo b1 = new AttachmentBo();
		b1.setAttachmentcode("001");
		b1.setAttachmentname("111");
		b1.setIsdefault("1");
		AttachmentBo b2 = new AttachmentBo();
		b2.setAttachmentcode("002");
		b2.setAttachmentname("222");
		b2.setIsdefault("2");
		users.add(b1);
		users.add(b2);
		System.out.println(users);
	}

}

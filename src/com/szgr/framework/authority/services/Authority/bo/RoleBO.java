package com.szgr.framework.authority.services.Authority.bo;

import java.io.Serializable;

import com.szgr.framework.authority.vo.SystemRolesVO;



/**
 * ½ÇÉ«BO

 *
 */
public class RoleBO extends SystemRolesVO implements Serializable{

	public RoleBO(){
		
	}
	public RoleBO(String role_id,String role_code){
		this.setRole_id(role_id);
		this.setRole_code(role_code);
	}
}

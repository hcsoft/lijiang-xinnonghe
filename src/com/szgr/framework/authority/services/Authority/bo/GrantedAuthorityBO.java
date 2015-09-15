package com.szgr.framework.authority.services.Authority.bo;

import java.io.Serializable;

import org.springframework.security.core.GrantedAuthority;

/**
 * ÓÃ»§½ÇÉ«
 *
 */
public class GrantedAuthorityBO implements GrantedAuthority, Serializable{

	private RoleBO roleBO;
	public GrantedAuthorityBO(RoleBO roleBO){
		this.setRoleBO(roleBO);
	}
	public String getAuthority() {
		// TODO Auto-generated method stub
		return roleBO.getRole_code();
	}
	public RoleBO getRoleBO() {
		return roleBO;
	}
	public void setRoleBO(RoleBO roleBO) {
		this.roleBO = roleBO;
	}
	
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((roleBO == null) ? 0 : roleBO.getRole_id().hashCode());
		return result;
	}
	
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final GrantedAuthorityBO other = (GrantedAuthorityBO) obj;
		if (roleBO == null) {
			if (other.roleBO != null)
				return false;
		} else if (!roleBO.getRole_id().equals(other.roleBO.getRole_id()))
			return false;
		return true;
	}

	
	
}

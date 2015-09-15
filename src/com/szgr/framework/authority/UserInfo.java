package com.szgr.framework.authority;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.szgr.framework.authority.datarights.RightEntity;
import com.thtf.ynds.vo.CodTaxempcodeVO;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

/**
 * (用户信息)
 */
public class UserInfo extends CodTaxempcodeVO implements UserDetails {
	private Set<GrantedAuthority> authorities;
	private boolean accountNonExpired = true;
	private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
	private boolean enabled = true;
	private String username;
	private String orgName;
	private List<RightEntity> userrights = new ArrayList<RightEntity>();

	/**
	 * 当前用户机关信息
	 */
	private CodTaxorgcodeVO codTaxorgcodeVO;

	/**
	 * 模块名
	 */
	private String moduleAuth;
	/**
	 * 登录标志 loginFlag = 'autologin'表示自动登录 loginFlag = 'normallogin'表示自动登录
	 */
	private String loginFlag = "normallogin";

	public Set<GrantedAuthority> getAuthorities() {
		return authorities;
	}

	public void setAuthorities(Set<GrantedAuthority> authorities) {
		this.authorities = authorities;
	}

	public String getUsername() {
		return this.getLogincode();
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return this.accountNonExpired;
	}

	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return this.accountNonLocked;
	}

	public boolean isCredentialsNonExpired() {
		return this.credentialsNonExpired;
	}

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setAccountNonExpired(boolean accountNonExpired) {
		this.accountNonExpired = accountNonExpired;
	}

	public void setAccountNonLocked(boolean accountNonLocked) {
		this.accountNonLocked = accountNonLocked;
	}

	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getLoginFlag() {
		return loginFlag;
	}

	public void setLoginFlag(String loginFlag) {
		this.loginFlag = loginFlag;
	}

	public CodTaxorgcodeVO getCodTaxorgcodeVO() {
		return codTaxorgcodeVO;
	}

	public void setCodTaxorgcodeVO(CodTaxorgcodeVO codTaxorgcodeVO) {
		this.codTaxorgcodeVO = codTaxorgcodeVO;
	}

	public String getModuleAuth() {
		return moduleAuth;
	}

	public void setModuleAuth(String moduleAuth) {
		this.moduleAuth = moduleAuth;
	}

	public List<RightEntity> getUserrights() {
		return userrights;
	}

	public void setUserrights(List<RightEntity> userrights) {
		this.userrights = userrights;
	}

	/**
	 * 打印用户数据权限
	 */
	public void printallrights() {
		if (!(this.userrights == null))
			// logger.debug("this list is null");
			// else
			for (int a = 0; a < this.userrights.size(); ++a) {
				RightEntity re = (RightEntity) this.userrights.get(a);
//				System.out.println(re.getRighttype() + ":" + re.getLabel() + ":" + re.getSqlstring());
			}
	}
	public String getRightDesc(){
		if(this.userrights != null){
			StringBuffer sb = new StringBuffer();
		   sb.append("------------当前用户权限描述---------------\r\n");
		   sb.append("当前用户的信息:"+this.getLogincode()+";机关信息:"+codTaxorgcodeVO.getTaxorgcode()+",模块权限为:"+this.getModuleAuth());
		   for(RightEntity right : this.userrights){
			   sb.append(right+"\r\n");
		   }
		   sb.append("-------------------当前用户权限描述-------------------------");
		   return sb.toString();
		}else{
		    return "当前用户无权限描述！";
		}
	}

}

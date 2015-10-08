package com.szgr.framework.authority.datarights;

import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.szgr.framework.authority.UserInfo;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

public class SystemUserAccessor {
	private static Logger log = Logger.getLogger(SystemUserAccessor.class);
	private UserInfo systemUser = null;

	public static synchronized SystemUserAccessor getInstance() {
		return new SystemUserAccessor();
	}

	protected SystemUserAccessor() {
    	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(); 
        HttpSession httpSession = request.getSession();
		if (httpSession.getAttribute("userInfoSession") != null) {
			this.systemUser = (UserInfo) httpSession.getAttribute("userInfoSession");
		}
	}
	
	public Set<GrantedAuthority> getAuthorities() {
		return this.systemUser.getAuthorities();
	}
	
	/**
	 * ����ģ��ID
	 * 
	 * @param moduleAuth
	 */
	public void insertModuleAuth(String moduleAuth) {
		this.systemUser.setModuleAuth(moduleAuth);
	}

	public String getUserDataRight(String righttype) {
		return getRightSqlFromType(righttype);
	}

	public String getUserDataRight(String righttype, String prefix) {
		return DataRightsUtil.addPrefixs(getUserDataRight(righttype), prefix);
	}
    
	public String getAuthflag() {
		return this.systemUser.getAuthflag();
	}

	public String getNormalflag() {
		return this.systemUser.getNormalflag();
	}

	public String getDoctorflag() {
		return this.systemUser.getDoctorflag();
	}
	public String getPassword() {
		return this.systemUser.getPassword();
	}

	public String getTaxempcode() {
		return this.systemUser.getTaxempcode();
	}

	public String getTaxempname() {
		return this.systemUser.getTaxempname();
	}

	public String getNurseflag() {
		return this.systemUser.getNurseflag();
	}
	public String getPublicdoctorflag() {
		return this.systemUser.getPublicdoctorflag();
	}
	public String getTaxorgcode() {
		return this.systemUser.getTaxorgcode();
	}

	public String getValid() {
		return this.systemUser.getValid();
	}

	public String getAuthDescription(){
		StringBuffer sb = new StringBuffer();
		String righttype = this.systemUser.getModuleAuth();
		String rightssql = getRightSqlFromType(righttype + "s");
		sb.append("��ǰ�û��������û�Ȩ��Ϊ��"+righttype+"="+rightssql);
		return sb.toString();
	}
	public String[] getCurrentModuleSelectRight() {
		String righttype = this.systemUser.getModuleAuth();
		String rightssql = getRightSqlFromType(righttype + "s");
		return DataRightsUtil.getParsedSelectAuth(rightssql);
	}

	public String getCurrentModuleSelectRightSql() {
		String righttype = this.systemUser.getModuleAuth();
		String rightssql = getRightSqlFromType(righttype + "s");
		return rightssql;
	}

	public String getCurrentModuleSelectRightSql(String prefix) {
		return DataRightsUtil.addPrefixs(prefix,
				getCurrentModuleSelectRightSql());
	}

	private String getRightSqlFromType(String righttype) {
		List rightlist = this.systemUser.getUserrights();
		for (int a = 0; a < rightlist.size(); ++a) {
			RightEntity re = (RightEntity) rightlist.get(a);

			if (re.getRighttype().equals(righttype))
				return re.getSqlstring();
		}

		return null;
	}

	public void printCurrentModuleSelectRight() {
		String[] array = getCurrentModuleSelectRight();
	}

	public CodTaxorgcodeVO getUserTaxOrgVO() {
		return this.systemUser.getCodTaxorgcodeVO();
	}

}
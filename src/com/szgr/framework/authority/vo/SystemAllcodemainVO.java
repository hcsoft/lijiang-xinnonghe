package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

public class SystemAllcodemainVO implements Serializable {
	private String codetablename;
	private String codekey;
	private String codevalue;
	private String codevoname;
	private String enabled;

	private int muteFlag;

	// contructors
	public SystemAllcodemainVO() {
	}

	public SystemAllcodemainVO(String codetablename) {
		this.codetablename = codetablename;
	}

	public String getCodetablename() {
		return codetablename;
	}

	public void setCodetablename(String codetablename) {
		this.codetablename = codetablename;
	}

	public String getCodekey() {
		return codekey;
	}

	public void setCodekey(String codekey) {
		this.codekey = codekey;
	}

	public String getCodevalue() {
		return codevalue;
	}

	public void setCodevalue(String codevalue) {
		this.codevalue = codevalue;
	}

	public String getCodevoname() {
		return codevoname;
	}

	public void setCodevoname(String codevoname) {
		this.codevoname = codevoname;
	}

	public int getMuteFlag() {
		return muteFlag;
	}

	public void setMuteFlag(int muteFlag) {
		this.muteFlag = muteFlag;
	}

	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("[codetablename:").append(codetablename).append("]");
		sb.append("[codekey:").append(codekey).append("]");
		sb.append("[codevalue:").append(codevalue).append("]");
		sb.append("[codevoname:").append(codevoname).append("]");
		sb.append("[enabled:").append(enabled).append("]");
		return sb.toString();
	}

	public int hashCode() {
		int result = 0;
		result = 29 * result
				+ (codetablename == null ? 0 : codetablename.hashCode());
		return result;
	}

	public boolean equals(Object vo) {
		if (this == vo)
			return true;
		if (!(vo instanceof SystemAllcodemainVO))
			return false;
		SystemAllcodemainVO eq = (SystemAllcodemainVO) vo;
		return codetablename == null ? eq.getCodetablename() == null
				: codetablename.equals(eq.getCodetablename());
	}

	public String getEnabled() {
		return enabled;
	}

	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}
}
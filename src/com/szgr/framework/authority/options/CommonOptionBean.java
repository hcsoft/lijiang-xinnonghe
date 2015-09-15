package com.szgr.framework.authority.options;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;

import com.szgr.framework.authority.UserInfo;
import com.szgr.framework.authority.vo.SystemUsersVO;

public class CommonOptionBean extends OptionBean {

	
	/**
	 * 下拉选择框查询参数
	 */
	private String searchString;

	/**
	 * 州市机关
	 */
	private String taxOrgSupCode;
	/**
	 * 区县机关
	 */
	private String taxOrgCode;
	/**
	 * 征收部门
	 */
	private String taxDeptCode;
	/**
	 * 模块编码
	 */
	private String moduleAuth;

	/**
	 * 税务人员类型
	 * 
	 * @see com.tfhz.ynds.constants.PubConstants() //税务人员类型 //领导 public static
	 *      String TAXEMPCODE_AUTH_TYPE = "10"; //征收人员 public static String
	 *      TAXEMPCODE_LEVY_TYPE = "20"; //税收管理员 public static String
	 *      TAXEMPCODE_TAXMANAGER_TYPE = "30";
	 */
	private String emptype;
	List returnList = new ArrayList<Object>();

	private JSONArray taxSupOrgOptionJsonArray = new JSONArray();
	private JSONArray taxOrgOptionJsonArray = new JSONArray();
	private JSONArray taxDeptOptionJsonArray = new JSONArray();
	private JSONArray taxEmpOptionJsonArray = new JSONArray();
	
	private UserInfo currentUserInfo; 

	public String getSearchString() {
		return searchString;
	}

	public void setSearchString(String searchString) {
		this.searchString = searchString;
	}

	public List getReturnList() {
		return returnList;
	}

	public void setReturnList(List returnList) {
		this.returnList = returnList;
	}

	public String getTaxOrgSupCode() {
		return taxOrgSupCode;
	}

	public void setTaxOrgSupCode(String taxOrgSupCode) {
		this.taxOrgSupCode = taxOrgSupCode;
	}

	public String getTaxOrgCode() {
		return taxOrgCode;
	}

	public void setTaxOrgCode(String taxOrgCode) {
		this.taxOrgCode = taxOrgCode;
	}

	public String getTaxDeptCode() {
		return taxDeptCode;
	}

	public void setTaxDeptCode(String taxDeptCode) {
		this.taxDeptCode = taxDeptCode;
	}

	public String getModuleAuth() {
		return moduleAuth;
	}

	public void setModuleAuth(String moduleAuth) {
		this.moduleAuth = moduleAuth;
	}

	public String getEmptype() {
		return emptype;
	}

	public void setEmptype(String emptype) {
		this.emptype = emptype;
	}

	public JSONArray getTaxSupOrgOptionJsonArray() {
		return taxSupOrgOptionJsonArray;
	}

	public void setTaxSupOrgOptionJsonArray(JSONArray taxSupOrgOptionJsonArray) {
		this.taxSupOrgOptionJsonArray = taxSupOrgOptionJsonArray;
	}

	public JSONArray getTaxOrgOptionJsonArray() {
		return taxOrgOptionJsonArray;
	}

	public void setTaxOrgOptionJsonArray(JSONArray taxOrgOptionJsonArray) {
		this.taxOrgOptionJsonArray = taxOrgOptionJsonArray;
	}

	public JSONArray getTaxDeptOptionJsonArray() {
		return taxDeptOptionJsonArray;
	}

	public void setTaxDeptOptionJsonArray(JSONArray taxDeptOptionJsonArray) {
		this.taxDeptOptionJsonArray = taxDeptOptionJsonArray;
	}

	public JSONArray getTaxEmpOptionJsonArray() {
		return taxEmpOptionJsonArray;
	}

	public void setTaxEmpOptionJsonArray(JSONArray taxEmpOptionJsonArray) {
		this.taxEmpOptionJsonArray = taxEmpOptionJsonArray;
	}

	public UserInfo getCurrentUserInfo() {
		return currentUserInfo;
	}

	public void setCurrentUserInfo(UserInfo currentUserInfo) {
		this.currentUserInfo = currentUserInfo;
	}

	
}

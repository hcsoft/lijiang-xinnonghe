package com.szgr.framework.authority.options;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;

import com.szgr.framework.authority.UserInfo;
import com.szgr.framework.authority.vo.SystemUsersVO;

public class CommonOptionBean extends OptionBean {

	
	/**
	 * ����ѡ����ѯ����
	 */
	private String searchString;

	/**
	 * ���л���
	 */
	private String taxOrgSupCode;
	/**
	 * ���ػ���
	 */
	private String taxOrgCode;
	/**
	 * ���ղ���
	 */
	private String taxDeptCode;
	/**
	 * ģ�����
	 */
	private String moduleAuth;

	/**
	 * ˰����Ա����
	 * 
	 * @see com.tfhz.ynds.constants.PubConstants() //˰����Ա���� //�쵼 public static
	 *      String TAXEMPCODE_AUTH_TYPE = "10"; //������Ա public static String
	 *      TAXEMPCODE_LEVY_TYPE = "20"; //˰�չ���Ա public static String
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

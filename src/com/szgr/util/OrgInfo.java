package com.szgr.util;


public class OrgInfo {
    
	private String taxorgsupcode;
    private String taxorgcode;
    private String taxdeptcode;
    private String taxmanagercode;
    
    private String optorgcode;
	private String optempcode;
	
    public OrgInfo(){
    	
    }
    public OrgInfo(String taxorgsupcode,String taxorgcode,String taxdeptcode,String taxmanagercode){
    	this.taxorgsupcode = taxorgsupcode;
    	this.taxorgcode = taxorgcode;
    	this.taxdeptcode = taxdeptcode;
    	this.taxmanagercode = taxmanagercode;
    }
    public OrgInfo(String taxorgsupcode,String taxorgcode,String taxdeptcode,
    		String taxmanagercode,String optorgcode,String optempcode){
    	this.taxorgsupcode = taxorgsupcode;
    	this.taxorgcode = taxorgcode;
    	this.taxdeptcode = taxdeptcode;
    	this.taxmanagercode = taxmanagercode;
    	this.optorgcode = optorgcode;
    	this.optempcode = optempcode;
    	
    }
	public String getTaxorgsupcode() {
		return taxorgsupcode;
	}
	public void setTaxorgsupcode(String taxorgsupcode) {
		this.taxorgsupcode = taxorgsupcode;
	}
	public String getTaxorgcode() {
		return taxorgcode;
	}
	public void setTaxorgcode(String taxorgcode) {
		this.taxorgcode = taxorgcode;
	}
	public String getTaxdeptcode() {
		return taxdeptcode;
	}
	public void setTaxdeptcode(String taxdeptcode) {
		this.taxdeptcode = taxdeptcode;
	}
	public String getTaxmanagercode() {
		return taxmanagercode;
	}
	public void setTaxmanagercode(String taxmanagercode) {
		this.taxmanagercode = taxmanagercode;
	}
	public String getOptorgcode() {
		return optorgcode;
	}
	public void setOptorgcode(String optorgcode) {
		this.optorgcode = optorgcode;
	}
	public String getOptempcode() {
		return optempcode;
	}
	public void setOptempcode(String optempcode) {
		this.optempcode = optempcode;
	}
    
}

package com.szgr.framework.authority.services.authority_mgr.resource_mgr;

public class ResourceMgrBo {

	private String resource_id;
	private String brandName;
	private String leaf_type;
	private String resource_content;

	public String getResource_id() {
		return resource_id;
	}

	public void setResource_id(String resource_id) {
		this.resource_id = resource_id;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getLeaf_type() {
		return leaf_type;
	}

	public void setLeaf_type(String leaf_type) {
		this.leaf_type = leaf_type;
	}

	public String getResource_content() {
		return resource_content;
	}

	public void setResource_content(String resource_content) {
		this.resource_content = resource_content;
	}
}

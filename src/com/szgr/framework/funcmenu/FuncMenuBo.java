package com.szgr.framework.funcmenu;

public class FuncMenuBo {

	private String resource_id;
	private String resource_name;
	private String resource_content;
	private String parent_menu_id;
	private String leaf_type;
	private String sort_str;

	private String selfId;
	private String parentId;
	private String isDouble;
	private String bgColor;
	private String tileType;
	private String imgSrc;
	private String brandName;
	private String brandCount;
	private String badgeColor;
	private String tileHtml;
	private String menuIcon;
	private String menuUrl;
	private String todoUrl;
	private String todoMenuid;
	

	public String getTodoMenuid() {
		return todoMenuid;
	}

	public void setTodoMenuid(String todoMenuid) {
		this.todoMenuid = todoMenuid;
	}

	public String getSelfId() {
		return selfId;
	}

	public FuncMenuBo(String resource_id, String resource_name,
			String resource_content, String parent_menu_id, String leaf_type,
			String sort_str, String selfId, String parentId, String isDouble,
			String bgColor, String tileType, String imgSrc, String brandName,
			String brandCount, String badgeColor, String tileHtml,
			String menuIcon, String menuUrl ,String todoUrl,String todoMenuid) {
		super();
		this.resource_id = resource_id;
		this.resource_name = resource_name;
		this.resource_content = resource_content;
		this.parent_menu_id = parent_menu_id;
		this.leaf_type = leaf_type;
		this.sort_str = sort_str;
		this.selfId = selfId;
		this.parentId = parentId;
		this.isDouble = isDouble;
		this.bgColor = bgColor;
		this.tileType = tileType;
		this.imgSrc = imgSrc;
		this.brandName = brandName;
		this.brandCount = brandCount;
		this.badgeColor = badgeColor;
		this.tileHtml = tileHtml;
		this.menuIcon = menuIcon;
		this.menuUrl = menuUrl;
		this.todoUrl = todoUrl;
		this.todoMenuid = todoMenuid;
		
	}
	
	
	
	public String getTodoUrl() {
		return todoUrl;
	}

	public void setTodoUrl(String todoUrl) {
		this.todoUrl = todoUrl;
	}

	public void setSelfId(String selfId) {
		this.selfId = selfId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getIsDouble() {
		return isDouble;
	}

	public void setIsDouble(String isDouble) {
		this.isDouble = isDouble;
	}

	public String getBgColor() {
		return bgColor;
	}

	public void setBgColor(String bgColor) {
		this.bgColor = bgColor;
	}

	public String getTileType() {
		return tileType;
	}

	public void setTileType(String tileType) {
		this.tileType = tileType;
	}

	public String getImgSrc() {
		return imgSrc;
	}

	public void setImgSrc(String imgSrc) {
		this.imgSrc = imgSrc;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getBrandCount() {
		return brandCount;
	}

	public void setBrandCount(String brandCount) {
		this.brandCount = brandCount;
	}

	public String getBadgeColor() {
		return badgeColor;
	}

	public void setBadgeColor(String badgeColor) {
		this.badgeColor = badgeColor;
	}

	public String getTileHtml() {
		return tileHtml;
	}

	public void setTileHtml(String tileHtml) {
		this.tileHtml = tileHtml;
	}

	public String getMenuIcon() {
		return menuIcon;
	}

	public void setMenuIcon(String menuIcon) {
		this.menuIcon = menuIcon;
	}

	public String getMenuUrl() {
		return menuUrl;
	}

	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}

	public String getResource_id() {
		return resource_id;
	}

	public void setResource_id(String resource_id) {
		this.resource_id = resource_id;
	}

	public String getResource_name() {
		return resource_name;
	}

	public void setResource_name(String resource_name) {
		this.resource_name = resource_name;
	}

	public String getResource_content() {
		return resource_content;
	}

	public void setResource_content(String resource_content) {
		this.resource_content = resource_content;
	}

	public String getParent_menu_id() {
		return parent_menu_id;
	}

	public void setParent_menu_id(String parent_menu_id) {
		this.parent_menu_id = parent_menu_id;
	}

	public String getLeaf_type() {
		return leaf_type;
	}

	public void setLeaf_type(String leaf_type) {
		this.leaf_type = leaf_type;
	}

	public String getSort_str() {
		return sort_str;
	}

	public void setSort_str(String sort_str) {
		this.sort_str = sort_str;
	}

	// {selfId:"mainId6_1",parentId:"#subFuncId",
	// isDouble:"no",bgColor:"bg-color-pinkDark",
	// tileType:"icon",imgSrc:"/images/MB_0016_multitask1.png",
	// brandName:"Î´½ÉÄÉ¸ûÕ¼Ë°Çå²á",brandCount:"",
	// badgeColor:"",tileHtml:"",
	// menuIcon:"/images/MB_0016_multitask1.png",
	// menuUrl:"url:demo/datagrid/checkbox.html"},

}

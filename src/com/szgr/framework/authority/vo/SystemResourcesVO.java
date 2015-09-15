package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
 * <p>
 * Title:系统资源信息
 * </p>
 * <p>
 * Description: 系统资源信息,Hibernate 映射VO
 * </p>
 * <p>
 * Company: thtf yun nan Branch
 * </p>
 * 
 * @author PdmToVoGen1.0
 * @version 1.0
 * @create datetime 2013-04-22 16:43:06.328
 */

public class SystemResourcesVO implements Serializable {
	// Fields
	// 资源ID
	private String resource_id;
	// 资源名称
	private String resource_name;
	// 资源类型
	private String resource_type;
	// 资源内容
	private String resource_content;
	// 资源描述
	private String resouce_describe;
	// 是否可用
	private String enabled;
	// 父菜单
	private String parent_menu_id;
	// 菜单类型
	private String leaf_type;
	// 排序
	private String sort_str;

	private int muteFlag;

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

	// contructors
	public SystemResourcesVO() {
	}

	public SystemResourcesVO(String resource_id) {
		this.resource_id = resource_id;
	}

	// methods
	public String getResource_id() {
		return this.resource_id;
	}

	public void setResource_id(String resource_id) {
		this.resource_id = resource_id;
	}

	public String getResource_name() {
		return this.resource_name;
	}

	public void setResource_name(String resource_name) {
		this.resource_name = resource_name;
	}

	public String getResource_type() {
		return this.resource_type;
	}

	public void setResource_type(String resource_type) {
		this.resource_type = resource_type;
	}

	public String getResource_content() {
		return this.resource_content;
	}

	public void setResource_content(String resource_content) {
		this.resource_content = resource_content;
	}

	public String getResouce_describe() {
		return this.resouce_describe;
	}

	public void setResouce_describe(String resouce_describe) {
		this.resouce_describe = resouce_describe;
	}

	public String getEnabled() {
		return this.enabled;
	}

	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}

	public String getParent_menu_id() {
		return this.parent_menu_id;
	}

	public void setParent_menu_id(String parent_menu_id) {
		this.parent_menu_id = parent_menu_id;
	}

	public String getLeaf_type() {
		return this.leaf_type;
	}

	public void setLeaf_type(String leaf_type) {
		this.leaf_type = leaf_type;
	}

	public String getSort_str() {
		return this.sort_str;
	}

	public void setSort_str(String sort_str) {
		this.sort_str = sort_str;
	}

	public void setMuteFlag(int muteFlag) {
		this.muteFlag = muteFlag;
	}

	public int getMuteFlag() {
		return muteFlag;
	}
	

	public String getTodoUrl() {
		return todoUrl;
	}

	public void setTodoUrl(String todoUrl) {
		this.todoUrl = todoUrl;
	}

	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("[resource_name:").append(resource_name).append("]");
		sb.append("[resource_type:").append(resource_type).append("]");
		sb.append("[resource_content:").append(resource_content).append("]");
		sb.append("[resouce_describe:").append(resouce_describe).append("]");
		sb.append("[enabled:").append(enabled).append("]");
		sb.append("[parent_menu_id:").append(parent_menu_id).append("]");
		sb.append("[leaf_type:").append(leaf_type).append("]");
		sb.append("[sort_str:").append(sort_str).append("]");
		return sb.toString();
	}

	public int hashCode() {
		int result = 0;
		result = 29 * result
				+ (resource_id == null ? 0 : resource_id.hashCode());
		return result;
	}

	public boolean equals(Object vo) {
		if (this == vo)
			return true;
		if (!(vo instanceof SystemResourcesVO))
			return false;
		SystemResourcesVO eq = (SystemResourcesVO) vo;
		return resource_id == null ? eq.getResource_id() == null : resource_id
				.equals(eq.getResource_id());
	}
}
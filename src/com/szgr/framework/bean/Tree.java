package com.szgr.framework.bean;

import java.util.ArrayList;
import java.util.List;

public class Tree{

	private String id ; 
    private String pid ; 
    private String text ; 
    
    
    public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	private List<Tree> children = new ArrayList<Tree>() ;

	public List<Tree> getChildren() {
		return children;
	}

	public void setChildren(List<Tree> children) {
		this.children = children;
	}

    
    
}

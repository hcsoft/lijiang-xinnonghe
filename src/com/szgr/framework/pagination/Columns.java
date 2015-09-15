package com.szgr.framework.pagination;

public class Columns {
	
	private String field;
	private String title;
	private String hidden;
	private String align;
	private String sortable;
	
	public Columns() {}

	public Columns(String field, String title, String hidden) {
		super();
		this.field = field;
		this.title = title;
		this.hidden = hidden;
	}

	public Columns(String field, String title, String hidden, String align,
			String sortable) {
		super();
		this.field = field;
		this.title = title;
		this.hidden = hidden;
		this.align = align;
		this.sortable = sortable;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getHidden() {
		return hidden;
	}

	public void setHidden(String hidden) {
		this.hidden = hidden;
	}

	public String getAlign() {
		return align;
	}

	public void setAlign(String align) {
		this.align = align;
	}

	public String getSortable() {
		return sortable;
	}

	public void setSortable(String sortable) {
		this.sortable = sortable;
	}
}

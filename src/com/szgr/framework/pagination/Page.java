package com.szgr.framework.pagination;

import java.math.BigDecimal;
import java.util.List;

import org.json.simple.JSONArray;

/**
 * 
 */
public class Page {
	/**
	 * �������
	 */
	private JSONArray results = new JSONArray();

	/**
	 * ��ǰҳ
	 */
	private Integer currentpage;

	/**
	 * ҳ��С
	 */
	private Integer pagesize;

	/**
	 * ������
	 */
	private Integer itemnum;

	/**
	 * ��ҳ��
	 */
	private Integer totalPage;

	public Integer getCurrentpage() {
		return currentpage;
	}

	public void setCurrentpage(Integer currentpage) {
		this.currentpage = currentpage;
	}

	public Integer getPagesize() {
		return pagesize;
	}

	public void setPagesize(Integer pagesize) {
		this.pagesize = pagesize;
	}

	public Integer getItemnum() {
		return itemnum;
	}

	public void setItemnum(Integer itemnum) {
		this.itemnum = itemnum;
	}

	public JSONArray getResults() {
		return results;
	}

	public Page setResults(JSONArray results) {
		this.results = results;
		return this;
	}

	public Integer getTotalPage() {
		if (pagesize > 0) {
			return Integer.valueOf(countPageNums(itemnum, pagesize));
		}
		return totalPage;
	}

	public void setTotalPage(Integer totalPage) {
		this.totalPage = totalPage;
	}

	private int countPageNums(Integer totalItems, Integer pageSize) {
		BigDecimal total = new BigDecimal(totalItems.intValue());
		BigDecimal page = new BigDecimal(pageSize.intValue());
		BigDecimal pageNums = total.divide(page, BigDecimal.ROUND_UP);
		return pageNums.intValue();

	}
}

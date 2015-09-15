package com.szgr.common.excel;

import java.util.LinkedHashMap;

import org.apache.poi.ss.usermodel.IndexedColors;
import org.mortbay.log.Log;

import com.szgr.common.excel.ExcelExportModel;
import com.szgr.framework.core.ApplicationException;

public abstract class AbstractExcelExportModel implements ExcelExportModel {
    
	protected static final String SPLIT_STR = ","; 
	
	private  LinkedHashMap<String,String> map = new LinkedHashMap<String, String>();
	private  int startRow;
	private  int startCol;
	
	
	private String[] hiddenPropertys;
	
	private short headBackGroudColor = -99;
	
	protected AbstractExcelExportModel(){
		
	}
	protected AbstractExcelExportModel(String keyStr,String nameStr,int startRow,int startCol){
		if(keyStr == null || nameStr == null){
			throw new ApplicationException("key is not null and name is not null");
		}
		String[] key = keyStr.split(SPLIT_STR);
		String[] name = nameStr.split(SPLIT_STR);
		Log.info(key.length+"="+name.length);
		if(key.length != name.length){
			throw new ApplicationException("key's length must equal name's length ");
		}
		for(int i = 0;i < key.length;i++){
			this.map.put(key[i], name[i]);
		}
		this.startRow = startRow;
		this.startCol = startCol;
	}
	protected AbstractExcelExportModel(String[] key,String[] name,int startRow,int startCol){
		if(key == null || name == null){
			throw new ApplicationException("key is not null and name is not null");
		}
		if(key.length != name.length){
			throw new ApplicationException("key's length must equal name's length ");
		}
		for(int i = 0;i < key.length;i++){
			this.map.put(key[i], name[i]);
		}
		this.startRow = startRow;
		this.startCol = startCol;
	}
	protected AbstractExcelExportModel(int startRow,int startCol){
	    this.startRow = startRow;
		this.startCol = startCol;
	}
	
	public LinkedHashMap<String, String> getHeadDisplayInfo() {
		return this.map;
	}
	public String getFileName(){
		return getModelName()+".xls";
	}
	public abstract String getModelName();

	
	public int getStartCol() {
		return this.startCol;
	}

	
	public int getStartRow() {
		return this.startRow;
	}
	
	
	public String[] getHiddenPropertys() {
		return this.hiddenPropertys;
	}
	
	protected void push(String property,String value){
		if(!this.getHeadDisplayInfo().containsKey(property)){
			this.getHeadDisplayInfo().put(property, value);
		}
	}
	public void setHiddenProperty(String[] hiddenPropertys){
		this.hiddenPropertys = hiddenPropertys;
	}
	
	public short getHeadBackGroudColor() {
		if(this.headBackGroudColor == -99){
			this.headBackGroudColor = IndexedColors.GREY_25_PERCENT.getIndex();
		}
		return this.headBackGroudColor;
	}
	
	public void setHeadBackGroudColor(short headBackGroudColor) {
		this.headBackGroudColor = headBackGroudColor;
	}
	public LinkedHashMap<String, String> getMap() {
		return map;
	}
	public void setMap(LinkedHashMap<String, String> map) {
		this.map = map;
	}
	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}
	public void setStartCol(int startCol) {
		this.startCol = startCol;
	}
	public void setHiddenPropertys(String[] hiddenPropertys) {
		this.hiddenPropertys = hiddenPropertys;
	}

}

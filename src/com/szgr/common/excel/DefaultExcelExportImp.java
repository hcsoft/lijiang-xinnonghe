package com.szgr.common.excel;

import java.beans.PropertyDescriptor;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.beanutils.PropertyUtils;

import com.szgr.util.FileUtils;

/**
* 
* <p>Title: ExcelExportImp.java</p>
* <p>Description:excel标准导出 </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-7-31
* @version 1.0
 */
public class DefaultExcelExportImp implements ExcelExport {

	private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DefaultExcelExportImp.class);
	
	private static final String ROW_SPLIT = "\r\n";
	
	protected ExcelExportModel model;
	
	protected PoiExcel excel;
	
	protected final String filePath;
	
	protected final String folderName;
	
	protected final String fileName;
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	private int startRow;
	
	private final Map<Integer,Integer> map = new HashMap<Integer, Integer>();  //存取列号和列的宽度呢
	
	private final Map<String,Integer> propColMap = new LinkedHashMap<String, Integer>(); //存取列和行的对应关系的
	
	private final Map<String,Method> cachMethod = new HashMap<String, Method>(); //缓存vo类的属性和方法
	
	public DefaultExcelExportImp(ExcelExportModel model){
		this.model = model;
		this.startRow = this.model.getStartRow();
		this.folderName = UUID.randomUUID().toString().replace("-","");
		this.fileName = this.model.getModelName()+".xls"; 
		this.filePath = DOWNLOADPATH+"/"+this.folderName+"/"+fileName;
		int startCol = this.model.getStartCol();
		Map<String,String> headerMap = model.getHeadDisplayInfo();
		int index = 0;
		for(String prop : headerMap.keySet()){
			int col = startCol+index;
			this.propColMap.put(prop, col);
			index++;
		}
	}
	/**
	 * 子类可以继承用来数据完全加载完毕后处理小计合计的
	 * 在export调用完毕后，调用此方法
	 */
	public void processAfterDataWriteComplete(){
		
	}
    
	
	public String export(List dataList) throws ExcelException {		
		if(startRow == this.model.getStartRow()){  //表示还没进行写数据
			try {
				String classPath =  this.getClass().getClassLoader().getResource("").toURI().getPath();
				String directoryInfo = classPath+"/"+DOWNLOADPATH;
				File f = new File(directoryInfo);
				if(!f.exists()){
				    f.mkdir();
				}
				directoryInfo = directoryInfo+"/"+this.folderName;
				f = new File(directoryInfo);
				if(!f.exists()){
				    f.mkdir();
				}
				String afilePath = directoryInfo+"/"+this.fileName;
				FileOutputStream fos = new FileOutputStream(afilePath);
				this.excel = new PoiExcel(model.getModelName());
				writeHead();
				writeData(dataList);
				setColumnWidth();  //调整列的宽度
				hiddenColumns(); //隐藏某些列
				this.excel.exportExcel(fos);
				fos.close();
			} catch (URISyntaxException e) {
				deleteFile();
				log.info(e.toString());
				throw new ExcelException(e);
			}catch (IOException e) {
				deleteFile();
				log.info(e.toString());
				throw new ExcelException(e);
			}
		}else{
			 InputStream is = this.getClass().getClassLoader().getResourceAsStream(this.filePath);
			 try {
				 String classPath =  this.getClass().getClassLoader().getResource("").toURI().getPath();
			     String tempFilePath = classPath+"/"+DOWNLOADPATH+"/"+this.folderName + "/a.xls";
				 FileOutputStream fos = new FileOutputStream(tempFilePath);
    		     this.excel = new PoiExcel(is);
				 writeData(dataList);
				 setColumnWidth();  //调整列的宽度
				 hiddenColumns(); //隐藏某些列
				 this.excel.exportExcel(fos);
				 fos.close();
				 is.close();
				 String deleteFilePath = classPath+this.filePath;
				 File file  = new File(deleteFilePath);
				 
				 if(file.exists()){
					 file.delete();
				 }
				 File f = new File(tempFilePath);
				 file = new File(deleteFilePath);
				 if(f.exists()){
					 f.renameTo(file);
				 }
				 
			}
			catch (URISyntaxException e) {
				deleteFile();
				log.info(e.toString());
				throw new ExcelException(e);
			}
			catch (IOException e) {
				deleteFile();
				log.info(e.toString());
				throw new ExcelException(e);
			}
		}
		
		return this.filePath;
	}
	
	public int getEndRow(){
		return this.startRow;
	}
	/**
	 * @param value  此属性所对应的对象
	 * @param property 属性名
	 * @return
	 */
	protected Object processObject(Object value,String property){
		Object result = value;
		if(value instanceof Date){
			if(value != null){
				Date d = (Date)value;
				result =  sdf.format(d);
			}
		}
		
		return result;
	}
	protected Map<String,Integer> getPropertyColMapping(){
		return this.propColMap;
	}
	/**
	 * 删除当前的目录及文件
	 */
	public void deleteFile(){
		FileUtils.deleteClassPathFile(this.filePath);
	}
	
	private int getWidth(String str){
		try {
			return str.getBytes("utf-8").length;
		} catch (UnsupportedEncodingException e) {
			throw new ExcelException(e);
		}
	}
	
	private void processColWidth(String value,int col){
		if(value == null){
			this.map.put(col,10);
			return;
		}
		String[] values = value.split(ROW_SPLIT);
		if(values != null){
			for(int i = 0 ;i < values.length;i++){
				String v = values[i];
				int width = getWidth(v);
				if(map.containsKey(col)){
					int tempWidth = map.get(col);
					if(width > tempWidth){
						map.put(col,width);
					}
				}else{
					map.put(col,width);
				}
			}
		}
		
	}
	private void writeHead(){
		LinkedHashMap<String,String> map = this.model.getHeadDisplayInfo();
		int sRow = this.model.getStartRow();
		int sCol = this.model.getStartCol();
		int i = 0;
		int col = 0;
		for(String key:map.keySet()){
			String colName = map.get(key);
			col = sCol+i;
			excel.setCellValue(sRow,col,colName);
			processColWidth(colName,col);
			i++;
		}
		this.excel.setRowHeight(this.startRow,25);
		//写上背景色
		this.excel.setBackColor(this.startRow,this.startRow,sCol,col,this.model.getHeadBackGroudColor());
		
		this.excel.frozenPane(0,this.startRow+1,0, this.startRow+1); //冻结列的行
		this.startRow++;
	}
	
	private Object getValue(Object bean,String properyty){
		try {
			Method m = this.cachMethod.get(properyty);
			if(m == null){
				m = this.cachMethod.get(properyty.toLowerCase());
			}
			Object result = m.invoke(bean,new Object[]{});
			return result;
		} catch (IllegalAccessException e) {
			log.info(e.toString());
			throw new ExcelException(e);
		} catch (InvocationTargetException e) {
			log.info(e.toString());
			throw new ExcelException(e);
		}
	}
	public void initialVoMethod(Class cls){
		if(!this.cachMethod.isEmpty()){
			return;
		}
		try {
			PropertyDescriptor[] pds = PropertyUtils.getPropertyDescriptors(cls);
			for (int i = 0; i < pds.length; i++) {
				PropertyDescriptor pd = pds[i];
				Method readMethod = pd.getReadMethod();
				if (readMethod == null)
					continue;
				this.cachMethod.put(pd.getName().toLowerCase(), readMethod);
			}
		} finally {
			PropertyUtils.clearDescriptors();
		}
	}
	private void writeData(List dataList){
		if(dataList != null && dataList.size() > 0){
			
			initialVoMethod(dataList.get(0).getClass());
			
			LinkedHashMap<String,String> map = this.model.getHeadDisplayInfo();
			int startCol = this.model.getStartCol();
			for(int i = 0;i < dataList.size();i++){
				Object obj = dataList.get(i);
				int col = 0;
				for(String key:map.keySet()){
					Object value = getValue(obj,key);
					value = this.processObject(value,key); //交给子类继承，默认不进行任何处理
					int newCol = startCol+col; 
					processColWidth(value != null ? value.toString() : "",newCol);
					this.excel.setCellValue(this.startRow,newCol,value);
					if(col == 0){
						
					}
					col++;
				}
				this.startRow++;
			}
		}
	}
	private void setColumnWidth(){
		for(int col : this.map.keySet()){
			int width = this.map.get(col);
			this.excel.setColumnWidth(col,width);
		}
	}
	
	private void hiddenColumns(){
		String[] columns = this.model.getHiddenPropertys();
		if(columns != null){
			for(String col : columns){
				int colIndex = this.propColMap.get(col);
				this.excel.hiddenColumn(colIndex);
			}
		}
	}
}

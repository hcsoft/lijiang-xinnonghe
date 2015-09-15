package com.szgr.util.fileexport;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

/**
 * 
 * 缩减部分代码 增加支持固定模块为表头的excel 导出
 * @author 熊杰  E-mail:xiongjie@tongfang.net.cn
 * @version 0 创建时间：2:39:06 PMNov 9, 2009
 *  
 */

 /** 使用说明
 
  相关类文件：import com.util.fileexport.*;
 
	如需要使用本功能 所需条件如下：
	 
	在xxxAction中使用
	 
	导出的数据必须保存在java.util.List对象中
	List中存储的必须为po或自定义的javabean
	 
	 
	 
	1.自定义列名模式
	//list中为从数据库返回的javabean或po对象
	List list =  (List)this.getProcessor().process(vo); 
	//实例化导出类   
	ExcelExportConsole exportConsole=new ExcelExportConsole();
	 
	//创建表头 ColumnEntry类二参数： excel中列名，list对象中的字段名
	//注意第二字段不能写错 不然抛出解析错误
	ColumnEntry[] title = {
	  ColumnEntry.getColumnEntryInstance("项目名称", "xmmc"),
	  ColumnEntry.getColumnEntryInstance("项目发包方名称", "fbfmc"),
	  ColumnEntry.getColumnEntryInstance("非居民企业名称", "fjmqymc"),
	  ColumnEntry.getColumnEntryInstance("国别 ", "gb"),
	  ColumnEntry.getColumnEntryInstance("合同编号", "htbh"),
	  ColumnEntry.getColumnEntryInstance("合同名称", "htmc"),
	  ColumnEntry.getColumnEntryInstance("合同金额", "htje"),
	  ColumnEntry.getColumnEntryInstance("合同币种", "htbz"),
	  ColumnEntry.getColumnEntryInstance("折合人民币金额", "zhrmbje"),
	  ColumnEntry.getColumnEntryInstance("项目类型", "xmlx"),
	  ColumnEntry.getColumnEntryInstance("营业税", "yezzs"),
	  ColumnEntry.getColumnEntryInstance("个人所得税税额", "grsds"),
	  ColumnEntry.getColumnEntryInstance("印花税税额", "yhs"),
	  ColumnEntry.getColumnEntryInstance("合计", "hj") };
	//设置表头
	exportConsole.setTitle(title);
	 
	//设置输出流 action中的response
	exportConsole.setResponse(response);
	   
	//设置导出文件名
	exportConsole.setFileName("重点税源统计");
	 
	//设置数据
	exportConsole.setData(list);
	   
	//设置是否有自动序号 true：有自动序号，false：无自动序号  默认为true 
	exportConsole.setAutoRowNum(true);
	   
	//导出
	exportConsole.doExport();
	 
	return null;
	 
	
	2.通过固定模板格式导出
	 
	//list中为从数据库返回的javabean或po对象
	List list =  (List)this.getProcessor().process(vo); 
	//实例化导出类   
	ExcelExportConsole exportConsole=new ExcelExportConsole();
	 
	//创建解析javabean所需列名
	String [] colCode={"xmmc","fbfmc","fjmqymc","gb","htbh","htmc","htje","htbz","zhrmbje","xmlx","yezzs","grsds","yhs","hj"};
	   
	//设置输出流
	exportConsole.setResponse(response);
	   
	//设置导出文件名
	exportConsole.setFileName("重点税源统计");
	   
	//设置数据
	exportConsole.setData(list);
	   
	//导出 参数一：模板路径,参数二：colCode数组
	//注意模板路径\要改为 / 或\\ 可以使用相对路径
	exportConsole.doExport("E:/工作/深圳/dzswglcj/trunk/documents/1-需求分析/原始需求/向缔约国提供自动情报情况/向缔约国提供自动情报情况表_模板_正式版.xls",colCode);
	 
	return null;
 
*/
 
public class ExcelExportConsole implements ExcelExportBase {
	private final static Logger log = Logger.getLogger(ExcelExportConsole.class);
	public ExcelExportConsole() {
		workbook = new HSSFWorkbook();
	}
	
	//response 对象
	private HttpServletResponse response;
	
	//文件名称
	private String fileName = "导出excel";
	
	//excel表格对象
	private HSSFWorkbook workbook;
	
	//是否有自动行号,默认值为true
	private boolean autoRowNum = true;
	
	//数据写入开始行
	private int startrow = 1;
	
	//数据写入开始列
	private int startclo = 1;
	
	//表头
	private ColumnEntry[] title;
	
	//中文名数组
	private String[] chineseName;

	//英文名数组
	private String[] englishName;
	
	//导出数据
	private List Data;
	               

	//导出exel
	public void doExport() throws Exception {
//		long starttime = System.currentTimeMillis();

	    //校验数据的正确性
	    this.checkTableTitle();
	    
	    //需要写入的数据
	    List dataList=this.getData();
			
		 //创建一张工作表
	    workbook.createSheet("第"+(1)+"页");
	    //将表头数据写入文档
	    ExcelExportUtil.writeTableTitleToFile(this.workbook,0, chineseName,this.autoRowNum);
	    
	    //将业务数据写入数据表
	    this.writeDataToFile(dataList,0);
			
	    
	    //将工作表输出
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());

//	    long endtime = System.currentTimeMillis();
//		log.debug("export spend time==============================:" + (endtime - starttime)+"ms");
		
	}
	
	/**
	 * 通过固定模板作为表头导出exel
	 * @param path 模板路径
	 * @throws Exception
	 */
	public void doExport(String path,String []colCode,boolean autorownum,int startrow) throws Exception {
		
		if(colCode.length<=0)
		{
			log.error("解析bean所需列名为空！");
			throw new IOException("解析bean所需列名为空！");
		}
		
		//设置为无自动行号
		setAutoRowNum(autorownum);
		//读取模板 
		InputStream fis = ExcelExportConsole.class.getResourceAsStream(path);
		
		//读取工作簿
		workbook = new HSSFWorkbook(fis);
		
//		//删除其他工作表 只保留第一页 模板页
//		for (int i = 1; i < workbook.getNumberOfSheets(); i++) {
//			workbook.removeSheetAt(i);
//			i--;
//		}
		
		//设置解析bean所需的列名
		this.setEnglishName(colCode);
		
		//需要写入的数据
	    List dataList=this.getData();
	    
		
		//从模板页复制一张工作表
//		HSSFSheet sheet = workbook.cloneSheet(0);
//		workbook.setSheetName(1, "第"+1+"页");
		
		//设置开始行
		this.setStartrow(startrow-1);
	    
	    //将业务数据写入数据表
	    this.writeDataToFile(dataList,0);
			
//		//数据写入 后在删除空的模板页
//		workbook.removeSheetAt(0);
	    
	    //将工作表输出
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());
		fis.close();
		
	}
	
	/**
	 * 通过固定模板作为表头导出exel
	 * @param path 模板路径
	 * @throws Exception
	 */
	public void doExport2(InputStream fis,String []colCode,boolean autorownum,int startrow) throws Exception {
		
		if(colCode.length<=0)
		{
			log.error("解析bean所需列名为空！");
			throw new IOException("解析bean所需列名为空！");
		}
		
		//设置为无自动行号
		setAutoRowNum(autorownum);
		
		//读取工作簿
		workbook = new HSSFWorkbook(fis);
		
		
		//设置解析bean所需的列名
		this.setEnglishName(colCode);
		
		//需要写入的数据
	    List dataList=this.getData();
	    
		
		//设置开始行
		this.setStartrow(startrow-1);
	    
	    //将业务数据写入数据表
	    this.writeDataToFile(dataList,0);
			
	    //将工作表输出
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());
		fis.close();
		
	}
	
	 /**
	   *向excel数据表中写入业务数
	   */
	private void writeDataToFile(List covertedlist,int SheetIndex) throws Exception {
	    int rownum = covertedlist.size();
	    //总列数等于表头列数+1(序号)
	    
	    int col = this.autoRowNum?this.getEnglishName().length + 1:this.getEnglishName().length;
	    HSSFSheet sheet = workbook.getSheetAt(SheetIndex);
	    for (int i = 0; i < rownum; i++) 
	    {
	      HSSFRow row = sheet.createRow(this.startrow + i);
	      for (int j = 0; j < col; j++) 
	      {

	        HSSFCell cell = row.createCell((short)j);
//	        cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	        if (j == 0 && this.autoRowNum) { //序号列不做处理
	          cell.setCellType(HSSFCell.CELL_TYPE_BLANK);
	          cell.setCellValue(i + 1);
	        }
	        else {
	          //列名
	          String columnname = this.autoRowNum?this.englishName[j-1]:this.englishName[j];
	          //行数据对象
	          Object rowobj = covertedlist.get(i);
	          Object cellobj = null;
	          try {
	            cellobj = PropertyUtils.getProperty(rowobj, columnname);
	            ExcelExportUtil.setValuetoCell(cell, cellobj);
	          }
	          catch (Exception ex) {
//	            cell.setCellValue(new HSSFRichTextString(columnname + ":属性获取失败"));
	            //将对象的值设定为属性无
	            ex.printStackTrace();
	          }

	        }
	      }
	      
	    }
//	    for (int i = 0; i < sheet.getPhysicalNumberOfRows(); i++) {
//			HSSFRow row=sheet.getRow(i);
//			for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
//				HSSFCell cell0 = row.getCell((short)j);
//				if(cell0.getCellType()==HSSFCell.CELL_TYPE_STRING)
//					System.out.print(cell0.getStringCellValue());
//			}
//			System.out.println("");
//	    }
	  }
	
	/**
	   * 检查数据表头的正确性，并校验表头
	   * @throws CommandException
	   */
	  private void checkTableTitle() throws Exception {
	    if (this.title == null) {
	      log.error("无数据表头，请设置！");
	      throw new Exception("无数据表头，请设置！");
	    }
	    //获取导出文件的列数
	    int colsize = title.length;
	    this.chineseName = new String[colsize];
	    this.englishName = new String[colsize];
	    for (int a = 0; a < colsize; a++) {
	      ColumnEntry tmp = this.title[a];
	        chineseName[a] = tmp.getChineseName();
	        englishName[a] = tmp.getEnglishName();
	    }
	  }
	
	public HttpServletResponse getResponse() {
		return response;
	}
	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public int getStartrow() {
		return startrow;
	}
	public void setStartrow(int startrow) {
		this.startrow = startrow;
	}
	public int getStartclo() {
		return startclo;
	}
	public void setStartclo(int startclo) {
		this.startclo = startclo;
	}
	public String[] getChineseName() {
		return chineseName;
	}
	public void setChineseName(String[] chineseName) {
		this.chineseName = chineseName;
	}
	public String[] getEnglishName() {
		return englishName;
	}
	public void setEnglishName(String[] englishName) {
		this.englishName = englishName;
	}
	public ColumnEntry[] getTitle() {
		return title;
	}
	public void setTitle(ColumnEntry[] title) {
		this.title = title;
	}
	public boolean isAutoRowNum() {
		return autoRowNum;
	}
	public void setAutoRowNum(boolean autoRowNum) {
		this.autoRowNum = autoRowNum;
	}
	public List getData() {
		return Data;
	}
	public void setData(List data) {
		Data = data;
	}
	
}

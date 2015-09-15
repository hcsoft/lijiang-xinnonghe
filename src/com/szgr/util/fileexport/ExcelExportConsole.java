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
 * �������ִ��� ����֧�̶ֹ�ģ��Ϊ��ͷ��excel ����
 * @author �ܽ�  E-mail:xiongjie@tongfang.net.cn
 * @version 0 ����ʱ�䣺2:39:06 PMNov 9, 2009
 *  
 */

 /** ʹ��˵��
 
  ������ļ���import com.util.fileexport.*;
 
	����Ҫʹ�ñ����� �����������£�
	 
	��xxxAction��ʹ��
	 
	���������ݱ��뱣����java.util.List������
	List�д洢�ı���Ϊpo���Զ����javabean
	 
	 
	 
	1.�Զ�������ģʽ
	//list��Ϊ�����ݿⷵ�ص�javabean��po����
	List list =  (List)this.getProcessor().process(vo); 
	//ʵ����������   
	ExcelExportConsole exportConsole=new ExcelExportConsole();
	 
	//������ͷ ColumnEntry��������� excel��������list�����е��ֶ���
	//ע��ڶ��ֶβ���д�� ��Ȼ�׳���������
	ColumnEntry[] title = {
	  ColumnEntry.getColumnEntryInstance("��Ŀ����", "xmmc"),
	  ColumnEntry.getColumnEntryInstance("��Ŀ����������", "fbfmc"),
	  ColumnEntry.getColumnEntryInstance("�Ǿ�����ҵ����", "fjmqymc"),
	  ColumnEntry.getColumnEntryInstance("���� ", "gb"),
	  ColumnEntry.getColumnEntryInstance("��ͬ���", "htbh"),
	  ColumnEntry.getColumnEntryInstance("��ͬ����", "htmc"),
	  ColumnEntry.getColumnEntryInstance("��ͬ���", "htje"),
	  ColumnEntry.getColumnEntryInstance("��ͬ����", "htbz"),
	  ColumnEntry.getColumnEntryInstance("�ۺ�����ҽ��", "zhrmbje"),
	  ColumnEntry.getColumnEntryInstance("��Ŀ����", "xmlx"),
	  ColumnEntry.getColumnEntryInstance("Ӫҵ˰", "yezzs"),
	  ColumnEntry.getColumnEntryInstance("��������˰˰��", "grsds"),
	  ColumnEntry.getColumnEntryInstance("ӡ��˰˰��", "yhs"),
	  ColumnEntry.getColumnEntryInstance("�ϼ�", "hj") };
	//���ñ�ͷ
	exportConsole.setTitle(title);
	 
	//��������� action�е�response
	exportConsole.setResponse(response);
	   
	//���õ����ļ���
	exportConsole.setFileName("�ص�˰Դͳ��");
	 
	//��������
	exportConsole.setData(list);
	   
	//�����Ƿ����Զ���� true�����Զ���ţ�false�����Զ����  Ĭ��Ϊtrue 
	exportConsole.setAutoRowNum(true);
	   
	//����
	exportConsole.doExport();
	 
	return null;
	 
	
	2.ͨ���̶�ģ���ʽ����
	 
	//list��Ϊ�����ݿⷵ�ص�javabean��po����
	List list =  (List)this.getProcessor().process(vo); 
	//ʵ����������   
	ExcelExportConsole exportConsole=new ExcelExportConsole();
	 
	//��������javabean��������
	String [] colCode={"xmmc","fbfmc","fjmqymc","gb","htbh","htmc","htje","htbz","zhrmbje","xmlx","yezzs","grsds","yhs","hj"};
	   
	//���������
	exportConsole.setResponse(response);
	   
	//���õ����ļ���
	exportConsole.setFileName("�ص�˰Դͳ��");
	   
	//��������
	exportConsole.setData(list);
	   
	//���� ����һ��ģ��·��,��������colCode����
	//ע��ģ��·��\Ҫ��Ϊ / ��\\ ����ʹ�����·��
	exportConsole.doExport("E:/����/����/dzswglcj/trunk/documents/1-�������/ԭʼ����/���Լ���ṩ�Զ��鱨���/���Լ���ṩ�Զ��鱨�����_ģ��_��ʽ��.xls",colCode);
	 
	return null;
 
*/
 
public class ExcelExportConsole implements ExcelExportBase {
	private final static Logger log = Logger.getLogger(ExcelExportConsole.class);
	public ExcelExportConsole() {
		workbook = new HSSFWorkbook();
	}
	
	//response ����
	private HttpServletResponse response;
	
	//�ļ�����
	private String fileName = "����excel";
	
	//excel������
	private HSSFWorkbook workbook;
	
	//�Ƿ����Զ��к�,Ĭ��ֵΪtrue
	private boolean autoRowNum = true;
	
	//����д�뿪ʼ��
	private int startrow = 1;
	
	//����д�뿪ʼ��
	private int startclo = 1;
	
	//��ͷ
	private ColumnEntry[] title;
	
	//����������
	private String[] chineseName;

	//Ӣ��������
	private String[] englishName;
	
	//��������
	private List Data;
	               

	//����exel
	public void doExport() throws Exception {
//		long starttime = System.currentTimeMillis();

	    //У�����ݵ���ȷ��
	    this.checkTableTitle();
	    
	    //��Ҫд�������
	    List dataList=this.getData();
			
		 //����һ�Ź�����
	    workbook.createSheet("��"+(1)+"ҳ");
	    //����ͷ����д���ĵ�
	    ExcelExportUtil.writeTableTitleToFile(this.workbook,0, chineseName,this.autoRowNum);
	    
	    //��ҵ������д�����ݱ�
	    this.writeDataToFile(dataList,0);
			
	    
	    //�����������
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());

//	    long endtime = System.currentTimeMillis();
//		log.debug("export spend time==============================:" + (endtime - starttime)+"ms");
		
	}
	
	/**
	 * ͨ���̶�ģ����Ϊ��ͷ����exel
	 * @param path ģ��·��
	 * @throws Exception
	 */
	public void doExport(String path,String []colCode,boolean autorownum,int startrow) throws Exception {
		
		if(colCode.length<=0)
		{
			log.error("����bean��������Ϊ�գ�");
			throw new IOException("����bean��������Ϊ�գ�");
		}
		
		//����Ϊ���Զ��к�
		setAutoRowNum(autorownum);
		//��ȡģ�� 
		InputStream fis = ExcelExportConsole.class.getResourceAsStream(path);
		
		//��ȡ������
		workbook = new HSSFWorkbook(fis);
		
//		//ɾ������������ ֻ������һҳ ģ��ҳ
//		for (int i = 1; i < workbook.getNumberOfSheets(); i++) {
//			workbook.removeSheetAt(i);
//			i--;
//		}
		
		//���ý���bean���������
		this.setEnglishName(colCode);
		
		//��Ҫд�������
	    List dataList=this.getData();
	    
		
		//��ģ��ҳ����һ�Ź�����
//		HSSFSheet sheet = workbook.cloneSheet(0);
//		workbook.setSheetName(1, "��"+1+"ҳ");
		
		//���ÿ�ʼ��
		this.setStartrow(startrow-1);
	    
	    //��ҵ������д�����ݱ�
	    this.writeDataToFile(dataList,0);
			
//		//����д�� ����ɾ���յ�ģ��ҳ
//		workbook.removeSheetAt(0);
	    
	    //�����������
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());
		fis.close();
		
	}
	
	/**
	 * ͨ���̶�ģ����Ϊ��ͷ����exel
	 * @param path ģ��·��
	 * @throws Exception
	 */
	public void doExport2(InputStream fis,String []colCode,boolean autorownum,int startrow) throws Exception {
		
		if(colCode.length<=0)
		{
			log.error("����bean��������Ϊ�գ�");
			throw new IOException("����bean��������Ϊ�գ�");
		}
		
		//����Ϊ���Զ��к�
		setAutoRowNum(autorownum);
		
		//��ȡ������
		workbook = new HSSFWorkbook(fis);
		
		
		//���ý���bean���������
		this.setEnglishName(colCode);
		
		//��Ҫд�������
	    List dataList=this.getData();
	    
		
		//���ÿ�ʼ��
		this.setStartrow(startrow-1);
	    
	    //��ҵ������д�����ݱ�
	    this.writeDataToFile(dataList,0);
			
	    //�����������
	    ExcelExportUtil.writeFileToIE(this.workbook, this.response,this.getFileName());
		fis.close();
		
	}
	
	 /**
	   *��excel���ݱ���д��ҵ����
	   */
	private void writeDataToFile(List covertedlist,int SheetIndex) throws Exception {
	    int rownum = covertedlist.size();
	    //���������ڱ�ͷ����+1(���)
	    
	    int col = this.autoRowNum?this.getEnglishName().length + 1:this.getEnglishName().length;
	    HSSFSheet sheet = workbook.getSheetAt(SheetIndex);
	    for (int i = 0; i < rownum; i++) 
	    {
	      HSSFRow row = sheet.createRow(this.startrow + i);
	      for (int j = 0; j < col; j++) 
	      {

	        HSSFCell cell = row.createCell((short)j);
//	        cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	        if (j == 0 && this.autoRowNum) { //����в�������
	          cell.setCellType(HSSFCell.CELL_TYPE_BLANK);
	          cell.setCellValue(i + 1);
	        }
	        else {
	          //����
	          String columnname = this.autoRowNum?this.englishName[j-1]:this.englishName[j];
	          //�����ݶ���
	          Object rowobj = covertedlist.get(i);
	          Object cellobj = null;
	          try {
	            cellobj = PropertyUtils.getProperty(rowobj, columnname);
	            ExcelExportUtil.setValuetoCell(cell, cellobj);
	          }
	          catch (Exception ex) {
//	            cell.setCellValue(new HSSFRichTextString(columnname + ":���Ի�ȡʧ��"));
	            //�������ֵ�趨Ϊ������
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
	   * ������ݱ�ͷ����ȷ�ԣ���У���ͷ
	   * @throws CommandException
	   */
	  private void checkTableTitle() throws Exception {
	    if (this.title == null) {
	      log.error("�����ݱ�ͷ�������ã�");
	      throw new Exception("�����ݱ�ͷ�������ã�");
	    }
	    //��ȡ�����ļ�������
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

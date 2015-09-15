package com.szgr.util.fileexport;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

public class ExcelExportUtil {
	
	private final static Logger log = Logger.getLogger(ExcelExportUtil.class);
	private ExcelExportUtil() {
	  }
	
	/**
	   * 输出文件到浏览器
	   * @param workbook HSSFWorkbook 工作表
	   * @param response HttpServletResponse 请求
	   * @param filename String  文件名
	   * @throws Exception
	   */
	  public static void writeFileToIE(HSSFWorkbook workbook,
	                                   HttpServletResponse response,
	                                   String filename) throws Exception {
	    if (response == null) {
	      log.error("请指定response对象!");
	      throw new Exception("请指定response对象!");
	    }
	    try {
	      ByteArrayOutputStream bos = new ByteArrayOutputStream();
	      OutputStream out = response.getOutputStream();
	      try {
	        //设定文件类型
	        response.setContentType("application/msexcel");
	        System.out.println(filename);
	        int i = filename.indexOf(".xls");
		    if (i < 0) {
		    	filename = filename + ".xls";
		    }
		    System.out.println(filename);
	        response.setHeader("Content-disposition",
	                           "attachment;filename=" +
	                           new String(filename.getBytes(),
	                                      "iso-8859-1"));
	        //设置为附件
//	        response.setHeader("Content-disposition",
//	                           "filename=" +
//	                           ExcelExportUtil.convertFileName(filename));
	        workbook.write(bos);
	        bos.writeTo(out);
	      }
	      catch (IOException ie) {
	        ie.toString();
	      }
	      finally {
	        try {
	          if (bos != null) {
	            bos.close();
	          }
	          if (out != null) {
	            out.close();
	          }
	        }
	        catch (Exception e) {
	          e.printStackTrace();
	        }
	      }

	    }
	    catch (Exception ex) {
	    	ex.printStackTrace();
	    }

	  }
	  /**
	   * 向excel工作表中写入表头
	   * @param workbook HSSFWorkbook
	   * @param SheetIndex 工作簿页数 下标
	   * @param title String[]
	   * @throws Exception
	   */

	  public static void writeTableTitleToFile(HSSFWorkbook workbook,int SheetIndex,
	                                           String[] tableTitle,
	                                           boolean hasrownum) throws
	      Exception {

	    //得到第一张工作表
	    HSSFSheet sheet = workbook.getSheetAt(SheetIndex);
	    if (tableTitle == null) {
	      log.error("文件表头为空，请设置！");
	      throw new Exception("文件表头为空，请设置！");

	    }
	    int startclo = 0;
	    HSSFRow row = sheet.createRow(0);
	    HSSFCellStyle cellstyle = createTableTitleCellStyle(workbook);
	    //带自动行号
	    if (hasrownum) {
	      startclo = 1;
	      HSSFCell cell0 = row.createCell((short)0);
	      cell0.setCellStyle(cellstyle);
	      cell0.setCellType(HSSFCell.CELL_TYPE_STRING);
//	      cell0.setEncoding(HSSFWorkbook.ENCODING_UTF_16);
	      cell0.setCellValue("序号");
	    }

	    for (int a = 0; a < tableTitle.length; a++) {
	      HSSFCell cell = row.createCell((short)(a + startclo));
	      cell.setCellStyle(cellstyle);
	      cell.setCellType(HSSFCell.CELL_TYPE_STRING);
//	      cell.setEncoding(HSSFWorkbook.ENCODING_UTF_16);
	      cell.setCellValue(tableTitle[a]);
	    }
	  }
	  
	  
	  /**
	   * 将数据数据对象转换成对应的格式并写入单元格
	   * @param cell HSSFCell
	   * @param valueobj Object
	   */
	  public static void setValuetoCell(HSSFCell cell, Object valueobj) {
	    if (valueobj == null) {
	      cell.setCellType(HSSFCell.CELL_TYPE_STRING);
	      cell.setCellValue("");
	    }
	    else if (valueobj instanceof String) {
	      cell.setCellType(HSSFCell.CELL_TYPE_STRING);
//	      cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	      cell.setCellValue(valueobj.toString());
	    }
	    else if (valueobj instanceof BigDecimal) {
	      cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
	      cell.setCellValue( ( (BigDecimal) valueobj).doubleValue());
	    }
	    else if (valueobj instanceof Timestamp) {
	      cell.setCellType(HSSFCell.CELL_TYPE_STRING);

//	      String timestr = ( (Timestamp) valueobj).toString();

//	      if (timestr.length() > 11 && timestr.substring(11).equals("00:00:00.0")) {
//	        timestr = timestr.substring(0, 11);
//	      }
	      //导出日期格式 修改为 yyyy-MM-dd  熊杰 2009-11-17
	      cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd").format((Timestamp)valueobj));
//	      cell.setCellValue(new HSSFRichTextString(timestr));
	    }
	    else if (valueobj instanceof Long) {
	      cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
	      cell.setCellValue( ( (Long) valueobj).longValue());
	    }
	    else if (valueobj instanceof Integer) {
	      cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
	      cell.setCellValue( ( (Integer) valueobj).intValue());
	    }else if(valueobj instanceof java.sql.Date){
	       cell.setCellType(HSSFCell.CELL_TYPE_STRING);
	       cell.setCellValue(((java.sql.Date)valueobj).toString());
	    }else if(valueobj instanceof Double){
		       cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		       cell.setCellValue(new DecimalFormat("#.##").format(valueobj));
		    }
	    else {
	      cell.setCellType(HSSFCell.CELL_TYPE_BLANK);
	      cell.setCellValue("数据类型未知");
	    }

	  }
	  
	  /**
	   * 获取表头单元格的格式对象
	   * @param workbook HSSFWorkbook
	   * @return HSSFCellStyle
	   */
	  public static HSSFCellStyle createTableTitleCellStyle(HSSFWorkbook workbook) {
	    org.apache.poi.hssf.usermodel.HSSFCellStyle cellstyle = workbook.
	        createCellStyle();
	    HSSFFont hSSFFont = workbook.createFont();
	    hSSFFont.setFontHeightInPoints( (short) 18);
	    hSSFFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	    cellstyle.setFont(hSSFFont);
	    return cellstyle;
	  }	  
	  
	  /**
	   * 获取文件 导出文件格式+上当前时间年-月-日
	   * @param filename String
	   * @return String
	   */
	  public static String convertFileName(String filename) {
	    String tmp = filename;
	    int a = tmp.indexOf(".xls");
	    if (a > 0) {
	      tmp = filename.substring(0, a);
	    }
	    tmp = tmp + DateFormat.getDateInstance().format(new Date()) + ".xls";
	    try {
	      tmp = new String(tmp.getBytes(),
	                       "iso-8859-1");
	    }
	    catch (Exception ex) {
	      ex.printStackTrace();
	    }
	    return tmp;
	  }
	  
	  
	  public static void copyRow(HSSFWorkbook workbook, HSSFSheet worksheet, int sourceRowNum, int destinationRowNum) {
	        // Get the source / new row
	        HSSFRow newRow = worksheet.getRow(destinationRowNum);
	        HSSFRow sourceRow = worksheet.getRow(sourceRowNum);

	        // If the row exist in destination, push down all rows by 1 else create a new row
	        if (newRow != null) {
	            worksheet.shiftRows(destinationRowNum, worksheet.getLastRowNum(), 1,true,false);
	        } else {
	            newRow = worksheet.createRow(destinationRowNum);
	        }

	        // Loop through source columns to add to new row
	        for (int i = 0; i < sourceRow.getLastCellNum(); i++) {
	            // Grab a copy of the old/new cell
	            HSSFCell oldCell = sourceRow.getCell(i);
	            HSSFCell newCell = newRow.getCell(i);
	            
	            if(null==newCell)
	            	newCell = newRow.createCell(i);

	            // If the old cell is null jump to next cell
	            if (oldCell == null) {
	                newCell = null;
	                continue;
	            }

	            // Copy style from old cell and apply to new cell
	            HSSFCellStyle newCellStyle = workbook.createCellStyle();
	            newCellStyle.cloneStyleFrom(oldCell.getCellStyle());
//	            newCell.setCellStyle(newCellStyle);

	            // If there is a cell comment, copy
	            if (oldCell.getCellComment() != null) {
	                newCell.setCellComment(oldCell.getCellComment());
	            }

	            // If there is a cell hyperlink, copy
	            if (oldCell.getHyperlink() != null) {
	                newCell.setHyperlink(oldCell.getHyperlink());
	            }

	            // Set the cell data type
	            newCell.setCellType(oldCell.getCellType());

	            // Set the cell data value
	            switch (oldCell.getCellType()) {
	                case HSSFCell.CELL_TYPE_BLANK:
	                    newCell.setCellValue(oldCell.getStringCellValue());
	                    break;
	                case HSSFCell.CELL_TYPE_BOOLEAN:
	                    newCell.setCellValue(oldCell.getBooleanCellValue());
	                    break;
	                case HSSFCell.CELL_TYPE_ERROR:
	                    newCell.setCellErrorValue(oldCell.getErrorCellValue());
	                    break;
	                case HSSFCell.CELL_TYPE_FORMULA:
	                    newCell.setCellFormula(oldCell.getCellFormula());
	                    break;
	                case HSSFCell.CELL_TYPE_NUMERIC:
	                    newCell.setCellValue(oldCell.getNumericCellValue());
	                    break;
	                case HSSFCell.CELL_TYPE_STRING:
	                    newCell.setCellValue(oldCell.getRichStringCellValue());
	                    break;
	            }
	        }

	        // If there are are any merged regions in the source row, copy to new row
	        for (int i = 0; i < worksheet.getNumMergedRegions(); i++) {
	            CellRangeAddress cellRangeAddress = worksheet.getMergedRegion(i);
	            if (cellRangeAddress.getFirstRow() == sourceRow.getRowNum()) {
	                CellRangeAddress newCellRangeAddress = new CellRangeAddress(newRow.getRowNum(),
	                        (newRow.getRowNum() +
	                                (cellRangeAddress.getLastRow() - cellRangeAddress.getFirstRow()
	                                        )),
	                        cellRangeAddress.getFirstColumn(),
	                        cellRangeAddress.getLastColumn());
//	                System.out.println(newRow.getRowNum()+","+(newRow.getRowNum() +
//                            (cellRangeAddress.getLastRow() - cellRangeAddress.getFirstRow()
//                                    ))+" "+cellRangeAddress.getFirstColumn()+" "+cellRangeAddress.getLastColumn());
	                worksheet.addMergedRegion(newCellRangeAddress);
	            }
	        }
	    }
	  
}	

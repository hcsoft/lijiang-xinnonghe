package com.szgr.util.fileexport;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class ExcelTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		try {
			File file = new File("D:/compare.xls");
			if (!file.exists()) {
				file.createNewFile();
			} 
			HSSFWorkbook workbook = new HSSFWorkbook(); 
			HSSFSheet sheet=workbook.createSheet();
			HSSFRow row=sheet.createRow(0);
			HSSFCell cell= row.createCell(0);
			cell.setCellValue("12312312");
			
			FileOutputStream out=new FileOutputStream(file);
			
			workbook.write(out);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

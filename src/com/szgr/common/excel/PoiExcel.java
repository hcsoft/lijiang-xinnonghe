package com.szgr.common.excel;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.util.CellRangeAddress;

/**
 * 
 * <p>
 * Title: PoiExcel.java
 * </p>
 * <p>
 * Description:代表一个excel的操作 ，此类有个默认的sheet，做为当前焦点，可以通过focusSheet来转换焦点
 * 此类支持poi3.9及以后版本
 * </p>
 * <p>
 * Copyright: Copyright (c) 2013
 * </p>
 * <p>
 * Company: szgr
 * </p>
 * 
 * @author xuhong
 * @date 2013-7-30
 * @version 1.0
 */
public class PoiExcel {

	private HSSFWorkbook workBook; // 当前的工作表

	private HSSFSheet sheet; // 当前默认的焦点sheet

	private HSSFCellStyle cellStyle;

	private HSSFFont font;

	/**
	 * 创建工作表，并创建sheet,获取焦点
	 */
	public PoiExcel() {
		workBook = new HSSFWorkbook();
		sheet = workBook.createSheet(" new sheet ");
		initial();
	}

	public PoiExcel(String sheetName) {
		workBook = new HSSFWorkbook();
		sheet = workBook.createSheet(sheetName);
		initial();
	}

	/**
	 * 默认获取第一个sheet
	 * 
	 * @param stream
	 * @throws IOException
	 */
	public PoiExcel(InputStream stream) throws IOException {
		workBook = new HSSFWorkbook(stream);
		sheet = workBook.getSheetAt(0);
		initial();
	}

	public PoiExcel(InputStream stream, String sheetName) throws IOException {
		workBook = new HSSFWorkbook(stream);
		sheet = workBook.getSheet(sheetName);
	}

	public PoiExcel(InputStream stream, int sheetNum) throws IOException {
		workBook = new HSSFWorkbook(stream);
		sheet = workBook.getSheetAt(sheetNum);
		initial();
	}

	/**
	 * 取焦点
	 * 
	 * @param sheetIndex
	 */
	public void focusSheet(int sheetIndex) {
		this.workBook.setSelectedTab(sheetIndex);
		this.sheet = this.workBook.getSheetAt(sheetIndex);
	}

	/**
	 * 如果没有sheetName的sheet，创建并获取焦点
	 * 
	 * @param sheetName
	 */
	public void createSheet(String sheetName) {
		sheet = workBook.getSheet(sheetName);
		if (sheet == null) {
			sheet = workBook.createSheet(sheetName);
		}
	}
	
	public HSSFSheet getSheet(int sheetIndex){
		return this.workBook.getSheetAt(sheetIndex);
	}
	public HSSFSheet getSheet(String sheetName){
		return this.workBook.getSheet(sheetName);
	}

	/**
	 * 设置单元格的内容 A1为0,0
	 * 
	 * @param row
	 *            行号
	 * @param col
	 *            列号
	 * @param double 单元格的值
	 */
	public void setCellValue(int row, int col, double d) {
		setCellValue(row, col, new Double(d), this.cellStyle);
	}

	public void setCellValue(int row, int col, boolean d) {
		setCellValue(row, col, new Boolean(d), this.cellStyle);
	}
	
	public void setCellValue(int row, int col, Object value){
		setCellValue(row,col,value,this.cellStyle);
	}

	/**
	 * 
	 * @param row
	 * @param col
	 * @param value
	 */
	public void setCellValue(int row, int col, Object value,
			HSSFCellStyle cellStyle) {
		HSSFRow dataRow = null;
		HSSFCell dataCell = null;
		if (checkRow(row) && checkCol(col)) {
			try {
				dataRow = sheet.getRow(row);
				dataCell = dataRow.getCell(col);
				if (dataCell == null) {
					dataCell = dataRow.createCell(col);
				}
			} catch (NullPointerException e) {
				dataRow = sheet.createRow(row);
				dataCell = dataRow.createCell(col);
			}
		}
		if (cellStyle != null) {
			dataCell.setCellStyle(cellStyle);
		}
		if (value == null) {
			dataCell.setCellValue("");
		} else {
			if (value instanceof Boolean) {
				dataCell.setCellValue((Boolean) value);
			} else if (value instanceof Calendar) {
				dataCell.setCellValue((Calendar) value);
			} else if (value instanceof Date) {
				dataCell.setCellValue((Date) value);
			} else if (value instanceof Double) {
				dataCell.setCellValue((Double) value);
			} else if (value instanceof RichTextString) {
				dataCell.setCellValue((RichTextString) value);
			} else {
				dataCell.setCellValue(value.toString());
			}
		}
		
	}

	public void setCellRangeValue(int startRow, int startCol,
			String[][] strValues) {
		setCellRangeValue(startRow, startCol, strValues, false);
	}

	/**
	 * 批量设置值
	 * 
	 * @param startRow
	 * @param startCol
	 * @param strValues
	 * @param setDefaultCellStyle
	 */
	public void setCellRangeValue(int startRow, int startCol,
			String[][] strValues, boolean setDefaultCellStyle) {
		if (checkRow(startRow) && checkCol(startCol)) {
			for (int row = 0; row < strValues.length; row++) {
				String[] strs = strValues[row];
				HSSFRow dataRow = null;
				dataRow = sheet.getRow(startRow + row);
				if (dataRow == null) {
					dataRow = sheet.createRow(startRow + row);
				}
				for (int col = 0; col < strs.length; col++) {
					HSSFCell dataCell = dataRow.getCell((col + startCol));
					if (dataCell == null) {
						dataCell = dataRow.createCell(col + startCol);
					}

					String cellValue = strValues[row][col];
					if (!NumberUtils.isNumber(cellValue)) {
						if (!"".equals(cellValue)) {
							dataCell.setCellValue(cellValue);
						}
					} else {
						double d = Double.valueOf(cellValue).doubleValue();
						dataCell.setCellValue(d);
					}
					if (setDefaultCellStyle)
						dataCell.setCellStyle(this.cellStyle);

				}
			}
		}
	}
	public Object getCellObjectValue(int row, int col) {
		HSSFCell dataCell = checkCell(row, col);
		Object result = null;
		if (dataCell != null) {
			int cellType = dataCell.getCellType();
			switch (cellType) {
			case HSSFCell.CELL_TYPE_STRING:
				result = String.valueOf(dataCell.getRichStringCellValue());
				break;
			case HSSFCell.CELL_TYPE_BOOLEAN:
				result = dataCell.getBooleanCellValue();
				break;
			case HSSFCell.CELL_TYPE_ERROR:
				result = dataCell.getErrorCellValue();
				break;
			case HSSFCell.CELL_TYPE_NUMERIC:
				result = dataCell.getNumericCellValue();
				break;
			case HSSFCell.CELL_TYPE_FORMULA:
				result = dataCell.getCellFormula();
				break;
			}
			return result;
		}
		return result;
	}
	public Date getCellDateValue(int row,int col){
		HSSFCell dataCell = checkCell(row, col);
		return dataCell.getDateCellValue();
	}
	public String getCellStringValue(int row, int col) {
		HSSFCell dataCell = checkCell(row, col);
		String strValue = "";
		if (dataCell != null) {
			int cellType = dataCell.getCellType();
			switch (cellType) {
			case HSSFCell.CELL_TYPE_STRING:
				strValue = String.valueOf(dataCell.getRichStringCellValue());
				break;
			case HSSFCell.CELL_TYPE_BOOLEAN:
				strValue = String.valueOf(dataCell.getBooleanCellValue());
				break;
			case HSSFCell.CELL_TYPE_ERROR:
				strValue = String.valueOf(dataCell.getErrorCellValue());
				break;
			case HSSFCell.CELL_TYPE_NUMERIC:
				strValue = String.valueOf(dataCell.getNumericCellValue());
				break;
			case HSSFCell.CELL_TYPE_FORMULA:
				strValue = String.valueOf(dataCell.getCellFormula());
				break;
			}
			return strValue;
		}
		return strValue;
	}

	/**
	 * 合并单元格
	 * 
	 * @param startRow
	 * @param endRow
	 * @param startCol
	 * @param endCol
	 */
	public void mergeCell(int startRow, int endRow, int startCol, int endCol) {
		CellRangeAddress range = new CellRangeAddress(startRow, endRow,
				startCol, endCol);
		this.sheet.addMergedRegion(range);
	}

	/**
	 * 单元格拷贝
	 * 
	 * @param sourceSheetIndex
	 * @param targetSheetIndex
	 * @param sourceStartRow
	 * @param sourceEndRow
	 * @param sourceStartCol
	 * @param sourceEndCol
	 * @param targetStartRow
	 * @param targetStateCol
	 */
	public void copyArea(int sourceSheetIndex, int targetSheetIndex,
			int sourceStartRow, int sourceEndRow, int sourceStartCol,
			int sourceEndCol, int targetStartRow, int targetStateCol) {
		HSSFSheet sourceSheet = this.workBook.getSheetAt(sourceSheetIndex);
		HSSFSheet targetSheet = this.workBook.getSheetAt(targetSheetIndex);
		copyArea(sourceSheet, targetSheet, sourceStartRow, sourceEndRow,
				sourceStartCol, sourceEndCol, targetStartRow, targetStateCol);
	}
	public void copyArea(int sourceSheetIndex, String targetSheetName,
			int sourceStartRow, int sourceEndRow, int sourceStartCol,
			int sourceEndCol, int targetStartRow, int targetStateCol) {
		HSSFSheet sourceSheet = this.workBook.getSheetAt(sourceSheetIndex);
		HSSFSheet targetSheet = this.workBook.getSheet(targetSheetName);
		copyArea(sourceSheet, targetSheet, sourceStartRow, sourceEndRow,
				sourceStartCol, sourceEndCol, targetStartRow, targetStateCol);
	}
	public void copyArea(String sourceSheetName, int targetSheetIndex,
			int sourceStartRow, int sourceEndRow, int sourceStartCol,
			int sourceEndCol, int targetStartRow, int targetStateCol) {
		HSSFSheet sourceSheet = this.workBook.getSheet(sourceSheetName);
		HSSFSheet targetSheet = this.workBook.getSheetAt(targetSheetIndex);
		copyArea(sourceSheet, targetSheet, sourceStartRow, sourceEndRow,
				sourceStartCol, sourceEndCol, targetStartRow, targetStateCol);
	}

	public void copyArea(String sourceSheetName, String targetSheetName,
			int sourceStartRow, int sourceEndRow, int sourceStartCol,
			int sourceEndCol, int targetStartRow, int targetStateCol) {
		HSSFSheet sourceSheet = this.workBook.getSheet(sourceSheetName);
		HSSFSheet targetSheet = this.workBook.getSheet(targetSheetName);
		copyArea(sourceSheet, targetSheet, sourceStartRow, sourceEndRow,
				sourceStartCol, sourceEndCol, targetStartRow, targetStateCol);
	}
	
	

	public void copyArea(HSSFSheet sourceSheet, HSSFSheet targetSheet,
			int sourceStartRow, int sourceEndRow, int sourceStartCol,
			int sourceEndCol, int targetStartRow, int targetStartCol) {
		checkRow(sourceStartRow);
		checkRow(sourceEndRow);
		checkRow(targetStartRow);
		checkCol(sourceStartCol);
		checkCol(sourceEndCol);
		checkCol(targetStartCol);
		if (sourceStartRow <= sourceEndRow && sourceStartCol <= sourceEndCol) {
			// 复制合并的单元格
			int regionNum = sourceSheet.getNumMergedRegions();
			for (int i = 0; i < regionNum; i++) {
				CellRangeAddress region = sourceSheet.getMergedRegion(i);
				if (region.getFirstRow() >= sourceStartRow
						&& region.getLastRow() <= sourceEndRow
						&& region.getFirstColumn() >= sourceStartCol
						&& region.getLastColumn() <= sourceEndCol) {
					int targetRowFrom = targetStartRow + region.getFirstRow()
							- sourceStartRow;
					int targetRowTo = targetStartRow + region.getLastRow()
							- sourceStartRow;
					int targetColFrom = targetStartCol
							+ region.getFirstColumn() - sourceStartCol;
					int targetColTo = targetStartCol + region.getLastColumn()
							- sourceStartCol;
					
					//System.out.println(region.getFirstRow()+","+region.getLastRow()+","+region.getFirstColumn()+","+region.getLastColumn());
					//System.out.println(targetRowFrom+","+targetRowTo+","+targetColFrom+","+targetColTo);
					CellRangeAddress newRegion = region.copy();
					newRegion.setFirstRow(targetRowFrom);
					newRegion.setFirstColumn(targetColFrom);
					newRegion.setLastRow(targetRowTo);
					newRegion.setLastColumn(targetColTo);
					targetSheet.addMergedRegion(newRegion);
				}
			}
			// 拷贝单元格
			int row = 0;
			
			for (int i = sourceStartRow; i <= sourceEndRow; i++,row++) {
				HSSFRow sourceRow = sourceSheet.getRow(i);
				if (sourceRow != null) {
					int col = 0;
					HSSFRow newRow = targetSheet.createRow(targetStartRow + row);
					newRow.setHeight(sourceRow.getHeight());
					for (int j = sourceStartCol; j <= sourceEndCol; j++,col++) {
						HSSFCell tempCell = sourceRow.getCell(j);
						if (tempCell != null) {
							HSSFCell newCell = newRow.createCell(targetStartCol
									+ col);
							copyCell(tempCell, newCell);
						}
					}
				}
			}
		} else {
			throw new ExcelException(
					"sourceStartRow > sourceEndRow and sourceStartCol > sourceEndCol ");
		}
	}

	/**
	 * 拷贝单元格
	 * 
	 * @param sourceCell
	 * @param targetCell
	 */
	public void copyCell(HSSFCell sourceCell, HSSFCell targetCell) {
		targetCell.setCellStyle(sourceCell.getCellStyle());
		if (sourceCell.getCellComment() != null) {
			targetCell.setCellComment(sourceCell.getCellComment());
		}
		int srcCellType = sourceCell.getCellType();
		targetCell.setCellType(srcCellType);
		if (srcCellType == HSSFCell.CELL_TYPE_NUMERIC) {
			if (HSSFDateUtil.isCellDateFormatted(sourceCell)) {
				targetCell.setCellValue(sourceCell.getDateCellValue());
			} else {
				targetCell.setCellValue(sourceCell.getNumericCellValue());
			}
		} else if (srcCellType == HSSFCell.CELL_TYPE_STRING) {
			targetCell.setCellValue(sourceCell.getRichStringCellValue());
		} else if (srcCellType == HSSFCell.CELL_TYPE_BLANK) {

		} else if (srcCellType == HSSFCell.CELL_TYPE_BOOLEAN) {
			targetCell.setCellValue(sourceCell.getBooleanCellValue());
		} else if (srcCellType == HSSFCell.CELL_TYPE_ERROR) {
			targetCell.setCellErrorValue(sourceCell.getErrorCellValue());
		} else if (srcCellType == HSSFCell.CELL_TYPE_FORMULA) {
			targetCell.setCellFormula(sourceCell.getCellFormula());
		} else {

		}
	}
    public void setBackColor(int row,int col,Color color){
    	 this.setBackColor(row, row, col, col, color);
    }
    public void setBackColor(int startRow,int endRow,int startCol,int endCol,IndexedColors color){
		this.setBackColor(startRow, endRow, startCol, endCol, color.getIndex());
    }
    public void setBackColor(int startRow,int endRow,int startCol,int endCol,short colorIndex){
    	for(int i = startRow;i <= endRow;i++){
			HSSFRow row = sheet.getRow(i);
			if(row != null){
				for(int j = startCol;j <= endCol;j++){
					HSSFCell cell = row.getCell(j);
					if(cell != null){
					   HSSFCellStyle cellStyle =  cell.getCellStyle();
					   HSSFCellStyle newCellStyle = this.workBook.createCellStyle();
					   newCellStyle.cloneStyleFrom(cellStyle);
					   newCellStyle.setFillForegroundColor(colorIndex);
					   newCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
					   cell.setCellStyle(newCellStyle);
					}
				}
			}
		}
    }
	public void setBackColor(int startRow,int endRow,int startCol,int endCol,Color color){
        this.setBackColor(startRow, endRow, startCol, endCol, getColorIndex(color));
	}
	
	public short getColorIndex(Color color){
		HSSFPalette palette = this.workBook.getCustomPalette();
		HSSFColor newColor = palette.findSimilarColor(color.getRed(), color.getGreen(), color.getBlue());
		return newColor.getIndex();
	}
	public void exportExcel(OutputStream out) throws IOException {
		workBook.write(out);
		out.close();
	}

	public void setRowHeight(int row, int height) {
		HSSFRow dataRow = sheet.getRow(row);
		if(dataRow == null){
			dataRow = this.sheet.createRow(row);
		}
		//dataRow.setHeightInPoints((float)height);
		dataRow.setHeight((short)(height*20));   //1/20
	}
	public int getRowHeight(int row){
		HSSFRow dataRow = sheet.getRow(row);
		if(dataRow == null){
			dataRow = this.sheet.createRow(row);
		}
		return dataRow.getHeight();
	}
	/**
	 * 单位width是1/256个字符宽度
	 * @param col
	 * @param width
	 */
	public void setColumnWidth(int col, int width) {
		this.sheet.setColumnWidth(col, width * 256);
	}
	
	public int getColumnWidth(int col){
		return this.sheet.getColumnWidth(col);
	}

	public void insertRow(int startRow, int rowCount) {
		sheet.shiftRows(startRow + 1, sheet.getLastRowNum(), rowCount);
	}

	public int getSheets() {
		return this.workBook.getNumberOfSheets();
	}

	public HSSFCellStyle getCellStyle() {
		return cellStyle;
	}

	public HSSFFont getFont() {
		return font;
	}
	
	public HSSFWorkbook getWorkBook(){
		return this.workBook;
	}
	
	public void hiddenColumn(int colIndex){
		this.sheet.setColumnHidden(colIndex,true);
	}
	
	public void frozenPane(int colSplit,int rowSplit,int leftMostColumn,int topRow){
		this.sheet.createFreezePane(colSplit,rowSplit,leftMostColumn,topRow);
	}
	
//	public void setComment(int rowIndex,int cellIndex,String comment){
//		HSSFRow row = this.sheet.getRow(rowIndex);
//		if(row == null){
//			row = this.sheet.createRow(rowIndex);
//		}
//		HSSFCell cell = row.getCell(cellIndex);
//		if(cell == null){
//			cell = row.createCell(cellIndex);
//		}
//	}

	private void initial() {
		this.cellStyle = createDefaultCellStyle();
		this.font = createDefaultFont();
	}

	public HSSFFont createDefaultFont() {
		return this.workBook.createFont();
	}

	public HSSFCellStyle createDefaultCellStyle() {
		HSSFCellStyle style = null;
		style = workBook.createCellStyle();
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		return style;
	}

	/**
	 * 检验行参数是否在Excel的行范围内
	 * 
	 * @param row
	 * @return
	 */
	private boolean checkRow(int row) throws ExcelException {
		if (row < 0 || row > 65535) {
			throw new ExcelException("row 必须>=0 并且<= 65535，实际row的值为=" + row);
		}
		return true;
	}

	/**
	 * 检验列参数是否在Excel的列范围内
	 * 
	 * @param col
	 * @return
	 */
	private boolean checkCol(int col) throws ExcelException {
		if (col < 0 || col > 255) {
			throw new ExcelException("col 必须>=0 并且<= 255，实际col的值为=" + col);
		}
		return true;
	}

	private HSSFCell checkCell(int row, int col) {
		HSSFRow dataRow = null;
		HSSFCell dataCell = null;
		if (checkRow(row) && checkCol(col)) {
			try {
				dataRow = sheet.getRow(row);
				dataCell = dataRow.getCell(col);
				if (dataCell == null) {
					dataCell = dataRow.createCell(col);
				}
			} catch (NullPointerException e) {
				dataRow = sheet.createRow(row);
				dataCell = dataRow.createCell(col);
			}
		}
		return dataCell;
	}
}

package com.szgr.common.excel;

import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.util.Assert;

import com.szgr.common.download.DownLoadClassPathFile;
import com.szgr.common.download.DownloadFile;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.util.FileUtils;
import com.szgr.util.PageInfo;

/**
 * 
 * <p>
 * Title: ExportExcelImp.java
 * </p>
 * <p>
 * Description: Excel����
 * </p>
 * <p>
 * Copyright: Copyright (c) 2013
 * </p>
 * <p>
 * Company: szgr
 * </p>
 * 
 * @author xuhong
 * @date 2013-12-25
 * @version 1.0
 */
public class ExportExcelImp {

	private static final Logger log = Logger.getLogger(ExportExcelImp.class);

	private ExcelExportModel excelMode;

	private ExcelExport excelExport;

	private IExcelExportExecute exportExecute;

	public ExportExcelImp(ExcelExportModel excelMode, ExcelExport excelExport,
			IExcelExportExecute exportExecute) {
		this.excelMode = excelMode;
		this.excelExport = excelExport;
		this.exportExecute = exportExecute;
	}

	public ExportExcelImp(String modelName, String keyStr, String nameStr,
			IExcelExportExecute exportExecute) {
		Assert.notNull(modelName);
		Assert.notNull(keyStr);
		Assert.notNull(nameStr);
		this.excelMode = new DefaultExportModel(modelName, keyStr, nameStr, 0,0);
		this.excelExport = new DefaultExcelExportImp(this.excelMode);
		this.exportExecute = exportExecute;
	}
	
	
//	OutputStream out = null;
//	String excelFileName = null;

	
	public String executeExcelExport(PageInfo pageInfo,HttpServletResponse response){
		OutputStream out = null;
		String excelFileName = null;
		try {
			out = response.getOutputStream();
			String fileName = this.excelMode.getModelName()+".xls";
			fileName = new String(fileName.getBytes(), "ISO-8859-1");
			response.reset();
			response.setBufferSize(1024 * 1024);
			response.setContentType("application/octet-stream;charset=UTF-8");
			response.addHeader("Content-Disposition", "attachment; filename=\""
					+ fileName + "\"");
			// �˷����н�����flush�����Ĺر�
			excelFileName = executeExcelExport(pageInfo, out);
		} catch (Exception ex) {
			log.info(ex);
		} finally {
			if (excelFileName != null) {
				FileUtils.deleteClassPathFile(excelFileName);
				log.info("control delete file " + excelFileName);
			}
		}
		return excelFileName;
	}

	/**
	 * ���ķ���
	 * 
	 * @return
	 */
	public String executeExcelExport(PageInfo pageInfo, OutputStream os) {
		int firstPage = 1;
		pageInfo.setPage(firstPage);
		pageInfo.setPagesize(IExcelExportExecute.FETCH_ROW);
		JSONObject json = this.exportExecute.execute(pageInfo);
		// �����һҳ
		List list = (List) json.get(PageUtil.PAGE_ROW);
		String fileName = this.excelExport.export(list);
		int totalRow = (Integer) json.get(PageUtil.PAGE_TOTAL); // ������;
		log.info("��ǰ��ѯ���ļ�¼����Ϊ========" + totalRow);
		if (totalRow > IExcelExportExecute.FETCH_ROW) { // �и����ҳ�����ٽ��в�ѯ����
			int startPage = firstPage + 1;
			int endPage = totalRow / IExcelExportExecute.FETCH_ROW;
			if (totalRow % IExcelExportExecute.FETCH_ROW > 0) {
				endPage++;
			}
			for (int page = startPage; page <= endPage; page++) {
				pageInfo.setPage(page);
				json = this.exportExecute.execute(pageInfo);
				list = (List) json.get(PageUtil.PAGE_ROW);
				this.excelExport.export(list);
			}
		}
		this.excelExport.processAfterDataWriteComplete();
		DownloadFile fileUtil = new DownLoadClassPathFile(true);
		log.info("������excel�ļ�·��Ϊ=" + fileName);
		if (os != null && fileName != null) {
			fileUtil.download(fileName, os);
		} else {
			log.info("�����Ϊnull����fileNameΪnull��");
		}
		return fileName;
	}

	public ExcelExportModel getExcelMode() {
		return excelMode;
	}

	public void setExcelMode(ExcelExportModel excelMode) {
		this.excelMode = excelMode;
	}

	public ExcelExport getExcelExport() {
		return excelExport;
	}

	public void setExcelExport(ExcelExport excelExport) {
		this.excelExport = excelExport;
	}

	public IExcelExportExecute getExportExecute() {
		return exportExecute;
	}

	public void setExportExecute(IExcelExportExecute exportExecute) {
		this.exportExecute = exportExecute;
	}

}

package com.szgr.common.excel.importexcel;


import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.szgr.common.excel.PoiExcel;
import com.szgr.framework.core.ApplicationContextUtils;
import com.szgr.framework.core.ApplicationException;
import com.szgr.framework.core.DefaultRowMapper;

@Service
public class ImportExcelService {
   
	private static Logger logger = Logger.getLogger(ImportExcelService.class);
    
	private void importData(PoiExcel poiExcel,ImportExcelMainVo mainVo) 
	      throws ApplicationException{		 
         String receiveObjClassName = mainVo.getReceiveobj();
         String procObjClassName = mainVo.getProcobj();
         Class receiveObjClass = null;
         Class procObjClass = null;
         IProcessImportExcelObj processExcel = null;
         try {
		    receiveObjClass = Class.forName(receiveObjClassName);
			procObjClass = Class.forName(procObjClassName);
			Object tempObj =  procObjClass.newInstance();
			if(tempObj instanceof IProcessImportExcelObj){
				processExcel = (IProcessImportExcelObj)tempObj;
			}else{
				throw new ApplicationException(procObjClassName+"所生成的对象不是IProcessImportExcelObj对象！");
			}
		 } catch (Exception e) {
			logger.info(e);
			throw new ApplicationException(e);
		 }
		 for(int row = mainVo.getStartrow();row <= mainVo.getEndrow();row++){
			try {
				Object newObj = receiveObjClass.newInstance();
				BeanWrapper bw = new BeanWrapperImpl(newObj);
				List<ImportExcelSubVo> subList = mainVo.getSubList();
				if(subList != null){
					for(int i = 0;i < subList.size();i++){
						ImportExcelSubVo subVo = subList.get(i);
						String property = subVo.getPropname();
						Object value = poiExcel.getCellObjectValue(row,subVo.getExcelcol());
						bw.setPropertyValue(property, value);
					}
				}
				newObj = bw.getWrappedInstance();
				processExcel.processExcelObj(newObj);
			}catch(Exception e) {
				logger.info(e);
				throw new ApplicationException(e);
			}
		 }
		
	}
	@Transactional(propagation=Propagation.REQUIRED)
	public void processImport(InputStream is,String configname){
		try{
			Assert.notNull(is);
			String sql = "select * from IMPORT_EXCEL_CONFIG_MAIN where configname = ? ";
		    List<ImportExcelMainVo> mainList = ApplicationContextUtils.getJdbcTemplate().query(sql, new Object[]{configname}, 
				                              new DefaultRowMapper(ImportExcelMainVo.class));
		    if(mainList == null || mainList.size() == 0){
		    	throw new ApplicationException("从Excel模板配置中没有找到模板名称为["+configname+"]配置信息！");
		    }
		    if(mainList.size() > 1){
		    	logger.warn("从模板配置中找到不止一个模板名称为【"+configname+"】的模板！");
		    }
		    ImportExcelMainVo mainVo = mainList.get(0);
		    sql = "select * from IMPORT_EXCEL_CONFIG_SUB where mainid = ? ";
		    List<ImportExcelSubVo> subList = ApplicationContextUtils.getJdbcTemplate().query(sql, new Object[]{mainVo.getMainid()}, 
		    		                        new DefaultRowMapper(ImportExcelSubVo.class));
		    if(subList == null || subList.size() == 0){
		    	throw new ApplicationException("从Excel模板配置子表中没有找到模板名称为["+configname+"]的配置信息！"); 
		    }
		    mainVo.setSubList(subList);
		    PoiExcel poiExcel = new PoiExcel(is);
		    ImportExcelService excelService = new ImportExcelService();
		    excelService.importData(poiExcel, mainVo);
		}catch(IOException ex){
			logger.info(ex);
			throw new ApplicationException(ex);
		}
		finally{
			if(is != null){
				try {
					is.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}

package com.szgr.util;

import java.io.File;
import java.net.URISyntaxException;

public class FileUtils {
   private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(FileUtils.class);
   /*
    * 从classpath下删除文件,如果当前路径只有一个文件
    * 则同时删除此目录
    * */
   public static void deleteClassPathFile(String fileName){
	   String directoryInfo = null;
		try {
			String classPath = FileUtils.class.getClassLoader().getResource("").toURI().getPath();
			String newFilePath = classPath+"/"+fileName;
			File file = new File(newFilePath);
			if(file.exists()){
				file.delete();
			}
			File directory = new File(file.getParent());
			if(directory.exists() && directory.listFiles().length == 0){
				directory.delete();
			}
		} catch (URISyntaxException e) {
			log.info("删除目录【"+directoryInfo+"】失败，失败原因为="+e.toString());
		}
   }
}

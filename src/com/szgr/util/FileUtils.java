package com.szgr.util;

import java.io.File;
import java.net.URISyntaxException;

public class FileUtils {
   private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(FileUtils.class);
   /*
    * ��classpath��ɾ���ļ�,�����ǰ·��ֻ��һ���ļ�
    * ��ͬʱɾ����Ŀ¼
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
			log.info("ɾ��Ŀ¼��"+directoryInfo+"��ʧ�ܣ�ʧ��ԭ��Ϊ="+e.toString());
		}
   }
}

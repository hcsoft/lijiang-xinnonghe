/**
 * Title:        OpenObjects (:开放对象:)
 * Description:  The Openo Software License, Version 1.0
 * (:Openo软件许可协议 1.0:)
 * Copyright (c) 2001 The Openo Software Group.  All rights reserved.
 * Use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * (:Openo(开放对象)软件组织版权注册于2001年:)
 * (:关于产品的使用规则：不论是源代码级别和可执行代码级别，无论是否进
 * 行修改，若要进行合法使用，必须符合以下条件:)
 * 1. Reuse of source code for Business must be accredited and payed
 * by Martin.
 * (:1.如果源代码用于商业用途必须由Martin亲自授权和付费:)
 * 2. Reuse binary for Business must be payed to Martin.
 * (:2.如果发布程序用于商业用途必须给Martin付费:)
 * 3. Reuse of source for Research must be accredited to Martin.
 * (:3.如果发布程序用于研究用途必须由Martin亲自授权:)
 * ====================================================================
 * For more information on the Openo Software Group, please see
 * <http://www.openo.org/>.
 * (:获取更多的信息请访问开放对象组织网站<http://www.openo.org/>:)
 */
package com.szgr.common.uid;

import java.io.*;

/**
 * 产生测试用UUID.
 *
 * @author    Martin Mars
 * @created   2002年6月20日
 * @version   1.0
 */
public class UUIDGener {

	private static  UIDFactory  uuid  = null;

    static {
        try {
            uuid = UIDFactory.getInstance( "UUID" );
        } catch ( UIDNotSupportException unsex ) {}
        ;
    }
	/**Constructor for the UUIDGener object */
	public UUIDGener() { }

    public static String getUUID() {
        return uuid.getNextUID();
    }

	public static void main( String[] args ) {
		try {
			BufferedWriter  fw  = new BufferedWriter( new FileWriter( "F:\\id.txt" ) );
			for ( int i = 1; i < 1000; i++ ) {
				fw.write( uuid.getNextUID() );
				fw.write( System.getProperty( "line.separator" ) );
			}
			fw.close();
		} catch ( Exception ex ) {
			ex.printStackTrace();
		}
	}

}

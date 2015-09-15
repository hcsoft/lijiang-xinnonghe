/**
 * Title:        OpenObjects (:���Ŷ���:)
 * Description:  The Openo Software License, Version 1.0
 * (:Openo������Э�� 1.0:)
 * Copyright (c) 2001 The Openo Software Group.  All rights reserved.
 * Use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * (:Openo(���Ŷ���)�����֯��Ȩע����2001��:)
 * (:���ڲ�Ʒ��ʹ�ù��򣺲�����Դ���뼶��Ϳ�ִ�д��뼶�������Ƿ��
 * ���޸ģ���Ҫ���кϷ�ʹ�ã����������������:)
 * 1. Reuse of source code for Business must be accredited and payed
 * by Martin.
 * (:1.���Դ����������ҵ��;������Martin������Ȩ�͸���:)
 * 2. Reuse binary for Business must be payed to Martin.
 * (:2.�����������������ҵ��;�����Martin����:)
 * 3. Reuse of source for Research must be accredited to Martin.
 * (:3.����������������о���;������Martin������Ȩ:)
 * ====================================================================
 * For more information on the Openo Software Group, please see
 * <http://www.openo.org/>.
 * (:��ȡ�������Ϣ����ʿ��Ŷ�����֯��վ<http://www.openo.org/>:)
 */
package com.szgr.common.uid;

import java.io.*;

/**
 * ����������UUID.
 *
 * @author    Martin Mars
 * @created   2002��6��20��
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

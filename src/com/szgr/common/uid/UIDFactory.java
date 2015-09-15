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

import java.net.InetAddress;
import java.security.MessageDigest;
import java.util.Random;

/**
 * Unified Identifier manager factory, UUID is default type.
 *
 * <p> For Examples:
 * <pre>
 * private static UIDFactory uuid = null;
 *
 * try {
 *      uuid = UIDFactory.getInstance("UUID");
 * } catch (UIDNotSupportException unsex) {};
 *
 * String id = uuid.getNextUID();
 * </pre>
 *
 *@author    Martin.Mars (martin.mars@openo.org)
 *@created   2002��5��19��
 *@version   2.0
 *@since     1.2
 */
public abstract class UIDFactory {
	/** Global Unified Identifier */
	public final static String UID_GUID = "GUID";
	/** United Unified Identifier */
	public final static String UID_UUID = "UUID";

	/** Current Epoch millis SEED */
	protected final static long EPOCH = System.currentTimeMillis();
	/** JVM Hashcode */
	protected final static long JVMHASH = Math.abs( ( new Object() ).hashCode() );
	/** Epoch has millisecond */
	protected final static long MACHINEID = getMachineID();
	/** Random by seed */
	protected final static Random m_random = new Random( EPOCH );
	/** MD5 Instance */
	private static MessageDigest md5;
	/** MD5 flag */
	private boolean isMd5 = false;

	/**
	 * Get Default UIDFactory.
	 *
	 *@return   UIDFactory UID manager object
	 */
	public static UIDFactory getDefault() {
		return UUID.getInstance();
	}

	/**
	 * Get Specified UIDFactory.
	 *
	 *@param uidfactory                         Description of the Parameter
	 *@return                                   UIDFactory
	 *@exception UIDNotSupportException         Description of the Exception
	 *@throws java.lang.ClassNotFoundException
	 */
	public static UIDFactory getInstance( String uidfactory )
		throws UIDNotSupportException {
		if ( uidfactory.equalsIgnoreCase( UID_UUID ) )
			return UUID.getInstance();
		if ( uidfactory.equalsIgnoreCase( UID_GUID ) ) {
			return GUID.getInstance();
		}
		throw new UIDNotSupportException( uidfactory + " Not Found!" );
	}

	/**
	 * Get next UID.
	 *
	 *@return   String Storagable UID
	 */
	public abstract String getNextUID();

	/**
	 * Get current UID.
	 *
	 *@return   String Storagable UID
	 */
	public abstract String getUID();

	/**
	 * Is MD5 switch ON.
	 *
	 *@return   ON is true.
	 */
	public boolean isMD5() {
		return isMd5;
	}

	/**
	 * Set MD5 output.
	 *
	 *@param flag  MD5 switch
	 */
	public void setMD5( boolean flag ) {
		isMd5 = flag;
	}

	/**
	 * Set current UID.
	 *
	 *@param uid            Object uid
	 *@exception Exception  Description of the Exception
	 */
	public abstract void setUID( String uid )
		throws Exception;

	/**
	 * Return Printable ID String.
	 *
	 *@return   String
	 */
	public abstract String toPrintableString();

	/**
	 * Convert bytes to MD5 bytes.
	 *
	 *@param bytes  Description of the Parameter
	 *@return
	 */
	protected static byte[] toMD5( byte[] bytes ) {
		return md5.digest( bytes );
	}

	/**
	 * Gets the machineID attribute of the GUID class
	 *
	 *@return   The machineID value
	 */
	private static long getMachineID() {
		long i = 0;

		try {
			InetAddress inetaddress = InetAddress.getLocalHost();
			byte abyte0[] = inetaddress.getAddress();

			i = toInt( abyte0 );
		} catch ( Exception ex ) {
			ex.printStackTrace();
		}
		return i;
	}

	/**
	 * Convert bytes to int utils.
	 *
	 *@param abyte0  Object bytes array
	 *@return        Result int
	 */
	private static int toInt( byte abyte0[] ) {
		int i = abyte0[0] << 24 & 0xff000000 | abyte0[1] << 16 & 0xff0000 | abyte0[2] << 8 & 0xff00 | abyte0[3] & 0xff;

		return i;
	}

	/* Initialize MD5 factory  */
	static {
		try {
			md5 = MessageDigest.getInstance( "MD5" );
		} catch ( java.security.NoSuchAlgorithmException ex ) {
			System.out.println( "->" + ex );
		}
	}

}

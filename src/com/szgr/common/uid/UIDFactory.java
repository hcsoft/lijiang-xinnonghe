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
 *@created   2002年5月19日
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

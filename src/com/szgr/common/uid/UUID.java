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

/**
 * United Unified Identifier class.
 *
 *@author    Martin.Mars (martin.mars@openo.org)
 *@created   2002年5月19日
 *@version   3.0
 */
public class UUID extends UIDFactory {
	/** Length bits */
	protected final static int BITS8 = 8;
	/** Length byte */
	protected final static int BYTELEN = 16;
	/** High order mask */
	protected final static int HIMASK = 240;
	/** Low order 8bits mask */
	protected final static int LO8BITMASK = 255;
	/** Low order mask */
	protected final static int LOMASK = 15;
	/** Upper limit Short */
	protected final static long MAX_INT = 32767;
	/** Upper limit Integer */
	protected final static long MAX_LONG = 2147483647;
	/** Epoch has millisecond */

	/** High order tag */
	protected long m_hiTag;
	/** Low order tag */
	protected long m_loTag;
	/** UUID Cache */
	protected String m_uuid = null;


	/**
	 * Construct overpass user data.
	 *
	 *@param highTag  High order tag
	 *@param loTag    Low order tag
	 */
	protected UUID( long highTag, long loTag ) {
		m_hiTag = highTag;
		m_loTag = loTag;
		m_uuid = this.toString( this.toByteArray() );
	}


	/** Construct default. */
	protected UUID() {
		next();
		m_uuid = this.toString( this.toByteArray() );
	}


	/**
	 * Return high order byte.
	 *
	 *@param b  Object byte
	 *@return   Result byte
	 */
	private final static byte hiNibble( byte b ) {
		return ( byte ) ( b >> 4 & 0xf );
	}


	/**
	 * Return low order byte.
	 *
	 *@param b  Object byte
	 *@return   Result byte
	 */
	private final static byte loNibble( byte b ) {
		return ( byte ) ( b & 0xf );
	}


	/**
	 * Set high order byte.
	 *
	 *@param dest  Object byte
	 *@param b     Source byte
	 *@return      Result byte
	 */
	private final static byte setHiNibble( byte dest, int b ) {
		dest &= 0xf;
		dest |= ( byte ) b << 4;
		return dest;
	}


	/**
	 * Set low order byte.
	 *
	 *@param dest  Object byte
	 *@param b     Source byte
	 *@return      Result byte
	 */
	private final static byte setLoNibble( byte dest, int b ) {
		dest &= 0xf0;
		dest |= ( byte ) b & 0xf;
		return dest;
	}


	/**
	 * Equals UUID.
	 *
	 *@param obj  Object UUID
	 *@return     Ture if equal
	 */
	public boolean equals( Object obj ) {
		try {
			UUID uuid = ( UUID ) obj;
			boolean flag = uuid.m_hiTag == m_hiTag && uuid.m_loTag == m_loTag;

			return flag;
		} catch ( ClassCastException cce ) {
			return false;
		}
	}


	/**
	 * Get back next new uid.
	 *
	 *@return   java.lang.String
	 */
	public String getNextUID() {
		next();
		return m_uuid;
	}


	/**
	 * Get back current uid.
	 *
	 *@return   java.lang.String
	 */
	public String getUID() {
		return m_uuid;
	}


	/**
	 * Set current UID.
	 *
	 *@param uidStr         The new uID value
	 *@exception Exception  Bad string format
	 */
	public void setUID( String uidStr )
		throws Exception {

		long loTag = 0L;
		long hiTag = 0L;
		int len = uidStr.length();

		if ( 32 != len )
			throw new Exception( "bad string format" );

		int i = 0;
		int idx = 0;

		for ( ; i < 2; i++ ) {
			loTag = 0L;
			for ( int j = 0; j < len / 2; j++ ) {
				String s = uidStr.substring( idx++, idx );
				int val = Integer.parseInt( s, 16 );

				loTag <<= 4;
				loTag |= val;
			}

			if ( i == 0 )
				hiTag = loTag;

		}
		m_hiTag = hiTag;
		m_loTag = loTag;
		m_uuid = this.toString( this.toByteArray() );
	}


	/**
	 * Get printable String.
	 *
	 *@return   java.lang.String
	 */
	public String toPrintableString() {
		byte bytes[] = toByteArray();

		if ( 16 != bytes.length )
			return "** Bad UUID Format/Value **";

		StringBuffer buf = new StringBuffer();
		int i;

		for ( i = 0; i < 4; i++ ) {
			buf.append( Integer.toHexString( hiNibble( bytes[i] ) ) );
			buf.append( Integer.toHexString( loNibble( bytes[i] ) ) );
		}

		while ( i < 10 ) {
			buf.append( '-' );

			int j = 0;

			while ( j < 2 ) {
				buf.append( Integer.toHexString( hiNibble( bytes[i] ) ) );
				buf.append( Integer.toHexString( loNibble( bytes[i++] ) ) );
				j++;
			}
		}
		buf.append( '-' );
		for ( ; i < 16; i++ ) {
			buf.append( Integer.toHexString( hiNibble( bytes[i] ) ) );
			buf.append( Integer.toHexString( loNibble( bytes[i] ) ) );
		}

		return buf.toString();
	}


	/**
	 * Return UID String.
	 *
	 *@return   UID String
	 */
	public String toString() {
		return m_uuid;
	}


	/**
	 * Get new UUID instance.
	 *
	 *@return   UUID
	 */
	protected static UIDFactory getInstance() {
		return new UUID();
	}

	/**
	 * Overpass a bytes array generator UID String.
	 *
	 *@param bytes  Object bytes array
	 *@return       UID String
	 */
	protected static String toString( byte bytes[] ) {
		if ( 16 != bytes.length ) {
			return "** Bad UUID Format/Value **";
		}

		StringBuffer buf = new StringBuffer();

		for ( int i = 0; i < 16; i++ ) {
			buf.append( Integer.toHexString( hiNibble( bytes[i] ) ) );
			buf.append( Integer.toHexString( loNibble( bytes[i] ) ) );
		}

		return buf.toString();
	}

	/** Generator & get back a UUID & cache String. */
	protected void next() {
		m_hiTag =  System.currentTimeMillis() + ( JVMHASH * 4294967296L ) ^ MACHINEID;
		m_loTag = EPOCH + Math.abs( m_random.nextLong() ) ;
		m_uuid = this.toString( this.toByteArray() );
	}

	/**
	 * Overpass high order tag & low order tag
	 * convert to array bytes.
	 *
	 *@return   Array bytes
	 */
	protected byte[] toByteArray() {
		byte bytes[] = new byte[16];
		int idx = 15;
		long val = m_loTag;

		for ( int i = 0; i < 8; i++ ) {
			bytes[idx--] = ( byte ) ( int ) ( val & ( long ) 255 );
			val >>= 8;
		}

		val = m_hiTag;
		for ( int i = 0; i < 8; i++ ) {
			bytes[idx--] = ( byte ) ( int ) ( val & ( long ) 255 );
			val >>= 8;
		}
		if (! this.isMD5())
			return bytes;
		else
			return toMD5(bytes);
	}

}

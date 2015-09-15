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
 * Global Unified Identifier class.
 *
 * @author    Martin.Mars (martin.mars@openo.org)
 * @created   2002年5月19日
 * @version   2.0
 */
public final class GUID
	extends UUID {

	/** JVM Hashcode */
	private long m_count = 0;

	/** Constructor for the GUID object */
	private GUID() {
		next();
	}

	/**
	 * Get new UUID instance.
	 *
	 * @return   UUIDd
	 */
	protected static UIDFactory getInstance() {
		return new GUID();
	}


	/** Generator & get back a UUID & cache String. */
	protected void next() {

		m_hiTag = EPOCH + ( JVMHASH * 4294967296L ) ^ MACHINEID;
		m_loTag = EPOCH * MAX_LONG + ( ++m_count );
		m_uuid = toString( toByteArray() );
	}

}

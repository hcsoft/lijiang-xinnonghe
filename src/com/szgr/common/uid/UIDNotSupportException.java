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

/**
 * Concrete UID genaretor class not found exception.
 *
 *@author    Martin.Mars (martin.mars@openo.org)
 *@created   2002��5��20��
 *@version   1.0
 */
public class UIDNotSupportException extends ClassNotFoundException {

	/**
	 *Constructor for the UIDNotSupportException object
	 *
	 *@param s  Description of the Parameter
	 */
	public UIDNotSupportException( String s ) {
		super( s, null );
		//  Disallow initCause
	}

}

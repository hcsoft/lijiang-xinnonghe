package com.szgr.util;

import org.apache.log4j.Logger;

import org.springframework.util.Assert;

import com.szgr.commonbus.IDeptManagerInfo;
import com.szgr.commonbus.TempTaxpayerDeptManagerInfo;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.core.ApplicationContextUtils;
import com.szgr.framework.core.ApplicationException;
import com.szgr.framework.core.database.proc.ProcSingleValue;
import com.tdgs.vo.RegTaxregistmainVO;

public class TaxPayerService {
	private static final Logger log = Logger.getLogger(TaxPayerService.class);
	
	private static IDeptManagerInfo deptManagerInfo = new TempTaxpayerDeptManagerInfo();
	
	public static  OrgInfo getOrgInfo(final String taxpayerid){
		OrgInfo result = null;
		if(isTempTaxpayer(taxpayerid)){
			String userorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
			String taxorgcode = userorgcode.substring(0,6)+"0000";
			String taxorgsupcode = taxorgcode.substring(0,4)+"000000";
			String taxdeptcode = deptManagerInfo.getTaxdeptcode();
			String taxmanagercode = deptManagerInfo.getTaxmanagercode();
			result =  new OrgInfo(taxorgsupcode,taxorgcode,taxdeptcode,taxmanagercode);
		}else{
			RegTaxregistmainVO regTaxVo = ApplicationContextUtils.getHibernateTemplate().get(RegTaxregistmainVO.class,taxpayerid);
			if(regTaxVo == null){
				throw new ApplicationException("����taxpayerid=["+taxpayerid+"]��ȡע����Ϣʧ�ܣ�");
			}
			result = new OrgInfo(regTaxVo.getTaxorgsupcode(), regTaxVo.getTaxorgcode(),
					regTaxVo.getTaxdeptcode(), regTaxVo.getTaxmanagercode());
		}
		String optorgcode = null;
		String optempcode = null;
		try{
			optorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
			optempcode = SystemUserAccessor.getInstance().getTaxempcode();
		}catch(NullPointerException ex){
			
		}
		result.setOptorgcode(optorgcode);
		result.setOptempcode(optempcode);
		return result;
	}
	public static boolean isTempTaxpayer(String taxpayerid){
		 Assert.notNull(taxpayerid, "taxpayerid is not null!");
		 return taxpayerid.startsWith("T");
	}
	public static String getTemporaryTaxpayerid(){
		String orgcode = null;
		try{
			orgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		}catch(NullPointerException ex){
            throw new ApplicationException("��ǰ�Ƿ��޵�½�û���", ex);			
		}
		orgcode = orgcode.substring(0,6)+"0000";
		return getTemporaryTaxpayerid(orgcode);
	}
	public static String getTemporaryTaxpayerid(final String taxorgcode) {
		log.info("taxorgcode =========== "+taxorgcode);
		ProcSingleValue proc = new ProcSingleValue(ProcConstants.SP_TEMPTAXPAYER,new Object[]{taxorgcode},true);
		Object result = proc.getSingleValue();
		if(result == null){
			throw new ApplicationException("���ݻ��ش���["+taxorgcode+"]��ȡ��ʱ���������ʧ�ܣ�");
		}
		log.info("��ȡ����ʱ���������Ϊ=========="+result);
		return result.toString();
    }

}

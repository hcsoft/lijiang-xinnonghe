package com.szgr.xnh.manager;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.pagination.PageUtil;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

@Controller
@RequestMapping("/Manager")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class ManagerServlet {
	private static final String ORG_FORMAT = "000000000000"; 

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getorglist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getOrgList(CodTaxorgcodeBvo req) {
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String sql = "select taxorgcode,taxorgname,parentId,valid from COD_TAXORGCODE  where  1=1  ";//查询出除已审核状态的数据
//		if (req.getUser_id() != null
//				&& !"".equals(req.getUser_id())) {
//			sql = sql + " and getUser_id='" + req.getUser_id() + "'";
//		}
		if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(8, 10))){//村、街道
			sql = sql + " and  taxorgcode ='"+taxorgcode+"')";
		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(6, 8))){//乡镇
			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or taxorgcode ='"+taxorgcode+"')";
		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(4, 6))){//县级机关
			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"')  or taxorgcode ='"+taxorgcode+"')";
		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(2, 4))){//州市级机关
			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"')) or taxorgcode ='"+taxorgcode+"')";
		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(0, 2))){//省
			
		}
		sql = sql +" order by taxorgcode";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("taxorgcode", Hibernate.STRING);
		attrMap.put("taxorgname", Hibernate.STRING);
		attrMap.put("parentId", Hibernate.STRING);
		attrMap.put("valid", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, CodTaxorgcodeBvo.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);a
		return jSONObject;
	}

	@RequestMapping(value = "/saveorg")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public void saveOrg(CodTaxorgcodeVO req) throws Exception{
		Session session = hibernateTemplate.getSessionFactory().getCurrentSession();
		String taxorgcode="";
		if(req.getTaxorgcode() !=null && !"".equals(req.getTaxorgcode())){//修改
			taxorgcode = req.getTaxorgcode();
		}else{
			String hql = "from CodTaxorgcodeVO where parentId ='"+req.getParentId()+"' order by taxorgcode desc ";
			List list = session.createQuery(hql).list();
			BigDecimal a = null;
			if(list != null && list.size()>0){
				CodTaxorgcodeVO maxvo = (CodTaxorgcodeVO) list.get(0);
				a = new BigDecimal(maxvo.getTaxorgcode());
				BigDecimal b = a.add(new BigDecimal(1));
				DecimalFormat df = new DecimalFormat(ORG_FORMAT);
				taxorgcode = df.format(b);
			}else{
				if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(6, 8))){//乡镇
					taxorgcode =  req.getParentId().substring(0, 8)+"0101";
				}else if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(4, 6))){//县级机关
					taxorgcode =  req.getParentId().substring(0, 6)+"010001";
				}else if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(2, 4))){//州市级机关
					taxorgcode =  req.getParentId().substring(0, 4)+"01000001";
				}
			}
		}
		CodTaxorgcodeVO vo = new CodTaxorgcodeVO();
		req.setTaxorgcode(taxorgcode);
		req.setTaxorgshortname(req.getTaxorgname());
		req.setRootnode("");
		req.setOrgclass("");
		req.setOrgtype("");
		session.saveOrUpdate(req);
		
	}
	
	@RequestMapping(value = "/getorg")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public CodTaxorgcodeVO getOrg(@RequestParam("taxorgcode") String taxorgcode) {
		CodTaxorgcodeVO vo = (CodTaxorgcodeVO) hibernateTemplate
				.getSessionFactory().getCurrentSession()
				.get(CodTaxorgcodeVO.class, taxorgcode);
		return vo;
	}
	
	@RequestMapping(value = "/delorg")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String Delorg(@RequestParam("taxorgcode") String taxorgcode) {
		String hql = "delete from CodTaxorgcodeVO where taxorgcode ='"+taxorgcode+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		return "1";
	}
}

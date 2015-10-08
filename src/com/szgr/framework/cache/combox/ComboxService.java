package com.szgr.framework.cache.combox;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import org.hibernate.Session;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.bean.Tree;
import com.szgr.framework.cache.service.CacheService;
import com.szgr.framework.core.ApplicationContextUtils;
import com.szgr.framework.core.CurrentUserInfo;
import com.szgr.framework.core.DefaultRowMapper;
import com.szgr.util.StringUtils;
import com.szgr.vo.DistrictVO;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

@Controller
@RequestMapping("/ComboxService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class ComboxService {

	@Autowired
	HibernateTemplate hibernateTemplate;
	
	@RequestMapping(value = "/getComboxs")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONArray getFuncMenuTops(@RequestParam("codetablename")
	String codetablename) {
//		System.out.println("-----------" + voName);
//		System.out.println("-----------" + code);
//		System.out.println("-----------" + name);

		List<OptionObject> cacheList = CacheService.getCachelist(codetablename);
		// System.out.println("=================" + cache.get(voName));
		// System.out.println("=================" +
		// cache.get(voName).getObjectValue());

		JSONArray arrays = new JSONArray();
		if (cacheList != null && cacheList.size() > 0) {
			for (int i = 0; i < cacheList.size(); i++) {
				OptionObject optionObject = cacheList.get(i);
				ComboBox bo = new ComboBox();
				bo.setKey(optionObject.getKey());
				bo.setValue(optionObject.getValue());
				bo.setKeyvalue(optionObject.getKeyvalue());
				arrays.add(bo);
			}
		}
		// String jsonString = JSONValue.toJSONString(l1);
		// System.out.println("-----------" + arrays);
		return arrays;
	}
	@RequestMapping(value = "/getComboxsFromTable")
	@ResponseBody
	public List<OptionObject> getCodeTableList(@RequestParam("codetablename") String codetablename,
			@RequestParam("key") String key,@RequestParam("value") String value,@RequestParam("where") String where){
		String sql = " select "+key+" as 'key',"+value+" as 'value' from "+ codetablename+" where 1=1 "+where;
		List<OptionObject> result =  ApplicationContextUtils.getJdbcTemplate().query(sql,new DefaultRowMapper(OptionObject.class));
		return result;
	}
	/**
	 * 获取当前用户的县级机关、市级机关、省级机关
	 * @param codetablename
	 * @return
	 */
	@RequestMapping(value = "/getLoginDeptInfo")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONArray getLoginDeptInfo() {
        JSONArray result = new JSONArray();
        List<OptionObject> list = CurrentUserInfo.getInstance().getOrgInfo();
        result.addAll(list);
        return result;
	}
	
	
	private static final String COD_TAXCODE = "COD_TAXCODE";
	private static final String COD_TAXORGCODE = "COD_TAXORGCODE";
	/**
	 * 获取税种的下拉框，目前支持三种税，土地使用税，10,12,20,直接获取税种、税目一次性把数据取出来
	 * @param taxcode为空，取所有的税种,多个税种以,号隔开
	 * @return
	 */
	@RequestMapping(value = "/gettaxcomboxs")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getTaxCodeVales(@RequestParam("taxcode") String taxcode,
			@RequestParam("gettaxcode") boolean gettaxcode){
		
		JSONObject result = new JSONObject();
		
		List<OptionObject> cacheList = CacheService.getCachelist(COD_TAXCODE);
		List<OptionObject> cacheList2 = CacheService.getCachelist(COD_TAXORGCODE);
		
		HashMap<OptionObject,JSONArray> map = new LinkedHashMap<OptionObject, JSONArray>();
		
		HashMap<String,OptionObject> taxMap = new HashMap<String, OptionObject>();
		
		for(int i = 0;i < cacheList.size();i++){
			OptionObject oo = cacheList.get(i);
			String value = oo.getKey();
			if(!StringUtils.notEmpty(value)){
				continue;
			}
			String code = value.substring(0,2);
			if(value.equals(code)){ //税种
				if(!taxMap.containsKey(code)){
					map.put(oo, new JSONArray());
					taxMap.put(code,oo);
				}
			}else{ //税目
				if(gettaxcode){
					if(!taxMap.containsKey(code)){
						map.put(oo, new JSONArray());
						taxMap.put(code,oo);
					}
					OptionObject optObj = taxMap.get(code);
				    JSONArray array = map.get(optObj);
				    array.add(oo);
				}
			}
		}
		List<String> taxcodeList = new ArrayList<String>();
		if(StringUtils.notEmpty(taxcode)){
			String[] taxcodes = taxcode.split(",");
			for(String tc : taxcodes){
				taxcodeList.add(tc);
			}
		}
		JSONArray keyArray = new JSONArray();
		JSONArray valueArray = new JSONArray();
		
		if(taxcodeList.size() > 0){
			for(int i = 0 ;i < taxcodeList.size();i++){
				String key = taxcodeList.get(i);
				OptionObject partKey  = taxMap.get(key);
				if(partKey != null){
					keyArray.add(partKey);
					valueArray.add(map.get(partKey));
				}
			}
		}else{
			for(OptionObject key : map.keySet()){
				keyArray.add(key);
				valueArray.add(map.get(key));
			}
		}
		result.put("key",keyArray);
		result.put("value",valueArray);
		return result;
	}
	
	@RequestMapping(value = "/gettaxorgtree")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public List<Tree> getTaxorgTree(){
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String authflag = SystemUserAccessor.getInstance().getAuthflag();
		String hql = "from CodTaxorgcodeVO where 1=1 ";
		if("01".equals(authflag)){
			List ls =this.getChildorglist(taxorgcode);
			String taxorgcodes ="";
			for (Iterator iterator = ls.iterator(); iterator.hasNext();) {
				CodTaxorgcodeVO orgvo = (CodTaxorgcodeVO) iterator.next();
				taxorgcodes = taxorgcodes+"'"+orgvo.getTaxorgcode()+"',";
			}
			taxorgcodes = taxorgcodes.substring(0, taxorgcodes.length()-1);
			System.out.println("taxorgcodes="+taxorgcodes);
			hql = hql + " and taxorgcode in ("+taxorgcodes+")";
		}else{
			hql = hql + " and taxorgcode ='"+taxorgcode+"'";
		}
//		JSONObject result = new JSONObject();
		
//		if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(8, 10))){//村、街道
//			hql = hql + " and  taxorgcode ='"+taxorgcode+"'";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(6, 8))){//乡镇机关
//			hql = hql + " and (taxorgcode  in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(4, 6))){//县级机关
//			hql = hql + " and (taxorgcode  in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"')  or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(2, 4))){//州市级机关
//			hql = hql + " and (taxorgcode  in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"')) or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(0, 2))){//省
//			
//		}
		hql = hql + "order by taxorgcode";
		
		Session session =  ApplicationContextUtils.getHibernateTemplate().getSessionFactory().getCurrentSession();
		List list2 = session.createQuery(hql).list();
		List<Tree> list = new ArrayList<Tree>();
		if(list2 != null && list2.size()>0){
			for (int i = 0; i < list2.size(); i++) {
				Tree tree = new Tree();
				CodTaxorgcodeVO vo = (CodTaxorgcodeVO) list2.get(i);
				tree.setId(vo.getTaxorgcode());
				tree.setText(vo.getTaxorgname());
				tree.setPid(vo.getParentId());
//				try {
//					BeanUtils.copyProperties(tree, list2.get(i));
//				} catch (IllegalAccessException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				} catch (InvocationTargetException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
				list.add(tree);
			}
		}else{
			return null;
		}
		Tree root = new Tree();
		Tree node = new Tree();
		List<Tree> treelist = new ArrayList<Tree>();// 拼凑好的json格式的数据
        List<Tree> parentnodes = new ArrayList<Tree>();// parentnodes存放所有的父节点
        if(list != null && list.size()>0){
        	root  = (Tree) list.get(0);
        	for (int i = 1; i < list.size(); i++) {
                node = (Tree) list.get(i);
                if(node.getPid().equals(root.getId())){
                    //为tree root 增加子节点
                    parentnodes.add(node) ;
                    root.getChildren().add(node) ;
                }else{//获取root子节点的孩子节点
                    getChildrenNodes(parentnodes, node);
                    parentnodes.add(node) ;
                }
            }    
        }
        treelist.add(root) ;
        return treelist ;
	}
	
	
	@RequestMapping(value = "/getdistricttree")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public List<Tree> getDistrictTree(@RequestParam("id") String id){
		Session session =  ApplicationContextUtils.getHibernateTemplate().getSessionFactory().getCurrentSession();
//		DistrictVO vo = (DistrictVO) session.get(DistrictVO.class, id);
		String hql = "from DistrictVO where 1=1 ";
		if(id != null && !"".equals(id)){
			hql = hql + " and id ='"+id+"' or ParentID = '"+id+"' or ParentID in (select id from DistrictVO where ParentID = '"+id+"') or ParentID in (select id from DistrictVO where ParentID in (select id from DistrictVO where ParentID = '"+id+"'))";
		}
		
		
		hql = hql + "order by id";
		
		
		List list2 = session.createQuery(hql).list();
		List<Tree> list = new ArrayList<Tree>();
		if(list2 != null && list2.size()>0){
			for (int i = 0; i < list2.size(); i++) {
				Tree tree = new Tree();
				DistrictVO vo = (DistrictVO) list2.get(i);
				tree.setId(vo.getID());
				tree.setText(vo.getName());
				tree.setPid(vo.getParentID());
//				try {
//					BeanUtils.copyProperties(tree, list2.get(i));
//				} catch (IllegalAccessException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				} catch (InvocationTargetException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
				list.add(tree);
			}
		}else{
			return null;
		}
		Tree root = new Tree();
		Tree node = new Tree();
		List<Tree> treelist = new ArrayList<Tree>();// 拼凑好的json格式的数据
        List<Tree> parentnodes = new ArrayList<Tree>();// parentnodes存放所有的父节点
        if(list != null && list.size()>0){
        	root  = (Tree) list.get(0);
        	for (int i = 1; i < list.size(); i++) {
                node = (Tree) list.get(i);
                if(node.getPid().equals(root.getId())){
                    //为tree root 增加子节点
                    parentnodes.add(node) ;
                    root.getChildren().add(node) ;
                }else{//获取root子节点的孩子节点
                    getChildrenNodes(parentnodes, node);
                    parentnodes.add(node) ;
                }
            }    
        }
        treelist.add(root) ;
        return treelist ;
	}
	
	 private static void getChildrenNodes(List<Tree> parentnodes, Tree node) {
	        //循环遍历所有父节点和node进行匹配，确定父子关系
	        for (int i = parentnodes.size() - 1; i >= 0; i--) {
	            
	        	Tree pnode = parentnodes.get(i);
	            //如果是父子关系，为父节点增加子节点，退出for循环
	            if (pnode.getId().equals(node.getPid())) {
	                pnode.getChildren().add(node) ;
	                return ;
	            } else {
	                //如果不是父子关系，删除父节点栈里当前的节点，
	                //继续此次循环，直到确定父子关系或不存在退出for循环
	                parentnodes.remove(i) ;
	            }
	        }
	    }
	 private List getChildorglist(String taxorgcode){
		Session session =  ApplicationContextUtils.getHibernateTemplate().getSessionFactory().getCurrentSession();
		String hql = "from CodTaxorgcodeVO where 1=1 and valid='01' ";
		hql = hql  + " and (taxorgcode  in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"')) or taxorgcode ='"+taxorgcode+"')";
		List ls = session.createQuery(hql).list();
		return ls;
	}
}

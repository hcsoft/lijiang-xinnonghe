package com.szgr.framework.authority.datarights;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.Session;

import com.thtf.ynds.vo.CodTaxorgcodeVO;
import com.thtf.ynds.vo.SamDataauthconfigVO;

public class DataRightsBI {
  private static final Log log = LogFactory.getLog(DataRightsBI.class);

  private DataRightsBI() {
  }




  /**
   * 装载用户的默认权限
   * @param usertaxorgcode String
   * @param organizationlevel String
   * @return List
   */
  public static List loadDefaultDataRight(String usertaxorgcode,
                                          String organizationlevel) {
    List rl = new ArrayList();
    String selectright = DataRightsUtil.getDefaultSelectRights(usertaxorgcode,
        organizationlevel);
    String dataright = DataRightsUtil.getDefaultRights(usertaxorgcode,
        organizationlevel);
    try {
      Field[] f = Class.forName(
          "com.szgr.framework.authority.datarights.DataRightTypeConstants").
          getDeclaredFields();
      for (int a = 0; a < f.length; a++) {
        String fieldname = f[a].getName();
        if (fieldname.indexOf("_SELECT") >= 0) {
          RightEntity re = new RightEntity();
          re.setLabel(fieldname);
          re.setRighttype(f[a].get(f[a]).toString());
          re.setSqlstring(selectright);
          rl.add(re);
        }
        else if (fieldname.indexOf("_MG") >= 0) {
          RightEntity re = new RightEntity();
          re.setLabel(fieldname);
          re.setRighttype(f[a].get(f[a]).toString());
          re.setSqlstring(dataright);
          rl.add(re);
        }
      }
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    return rl;

  }

  /**
   * 根据用户所在的机关以及用户代码从数据库查询用户的权限配置信息
   * @param hbtSession Session
   * @param taxorgcode String
   * @param taxempcode String
   */
  public static List loadDataRightsFromDB(Session hbtSession,
                                   CodTaxorgcodeVO taxorgcodevo,
                                   String taxempcode) {
    String taxorgcode = taxorgcodevo.getTaxorgcode();
    //初始化UserRights对象
    UserRights userRights = DataRightsUtil.initialUserRights(taxorgcode,
        taxorgcodevo.getOrgclass(), taxempcode, taxorgcodevo.getOrgtype());
    log.debug(userRights.toString());
//    ------------------------------
//    userRights:
//    usertaxorgcode:5323260008
//    taxorgsupcode:5323000000
//    taxorgcode:5323260000
//    taxdeptcode#null#
//    taxlevyorgcode:#null#
//    taxmanagercode:5323260008001
//    ------------------------------
    List defaulRrigthsList = loadDefaultDataRight(taxorgcode,
        taxorgcodevo.getOrgclass());
    //查询该用户配置的用户sql
    List samDataauthconfigVOList = loadSamDataauthconfigVOList(hbtSession,
        taxorgcode, taxempcode);

    if (samDataauthconfigVOList.size() > 0) {
      List configrightslist = parseAuthValueToSqlString(samDataauthconfigVOList,
          userRights);

      return combineRightList(defaulRrigthsList, configrightslist);
    }
    else {
      return defaulRrigthsList;
    }

  }

  private static List combineRightList(List defaultlist, List dblist) {
    List reslist = new ArrayList();
    for (int a = 0; a < defaultlist.size(); a++) {
      RightEntity temp = (RightEntity) defaultlist.get(a);
      if (!checkRightVoIsExistInList(temp, dblist)) {
        reslist.add(temp);
      }
    }
    reslist.addAll(dblist);

    return reslist;
  }

  /**
   * 从数据库查询用户的数据权限
   * @param hbtSession Session
   * @param taxorgcode String
   * @param taxempcode String
   * @return List
   */
  private static List loadSamDataauthconfigVOList(Session hbtSession,
                                           String taxorgcode, String taxempcode) {
    String hql1 =
        "from SamDataauthconfigVO where valid ='01' and authusercode =?";
    //查询用户所在机关的数据权限
    Query query = hbtSession.createQuery(hql1).setString(0, taxorgcode);
    List res1 = query.list();
    //查询用户配置的数据权限
    query.setString(0, taxempcode);
    List res2 = query.list();
    List res3 = new ArrayList();
    res3.addAll(res2);
    for (int a = 0; a < res1.size(); a++) {
      SamDataauthconfigVO voa = (SamDataauthconfigVO) res1.get(a);
      if (!checkVoIsExistInList(voa, res2)) {
        res3.add(voa);
      }
    }

    return res3;

  }

  /**
   * 将用户默认权限列表和从数据库装载的数据权限列表合并
   * @param samDataauthconfigVOList List
   * @param userRights UserRights
   * @return String
   */
  private  static List parseAuthValueToSqlString(List samDataauthconfigVOList,
                                         UserRights userRights) {
    List reslsit = new ArrayList();
    List rightEntityList = convertDbVotoBiVo(samDataauthconfigVOList);
    for (int a = 0; a < rightEntityList.size(); a++) {
      RightEntity temp = (RightEntity) rightEntityList.get(a);
      String righttype = temp.getRighttype();
      righttype = righttype.toLowerCase();
      if (righttype.indexOf("m") > 0) {
        temp.setSqlstring(DataRightsUtil.replaceWildCard(temp.getSqlstring(),
            userRights));
      }
      else if (righttype.indexOf("s") > 0) {
        temp.setSqlstring(DataRightsUtil.replaceSelectWildCard(temp.
            getSqlstring(), userRights.getUsertaxorgcode()));
      }
      reslsit.add(temp);
      //temp.setSqlstring();
    }
    return reslsit;
  }

  /**
   * 将SamDataauthconfigVO列表转换为RightEntity列表
   * @param list List
   * @return List
   */
  private static List convertDbVotoBiVo(List list) {
    List reslist = new ArrayList();
    for (int a = 0; a < list.size(); a++) {
      SamDataauthconfigVO voa = (SamDataauthconfigVO) list.get(a);
      RightEntity temp = new RightEntity();
      temp.setLabel(voa.getAuthremark());
      temp.setRighttype(voa.getAuthtype());
      temp.setSqlstring(voa.getAuthvalue());
      reslist.add(temp);
    }

    return reslist;
  }

  /**
   * 检查对象vo是否在list列表中存在
   * @param vo SamDataauthconfigVO
   * @param list List
   * @return boolean
   */
  private static boolean checkVoIsExistInList(SamDataauthconfigVO vo, List list) {

    for (int i = 0; i < list.size(); i++) {
      SamDataauthconfigVO vob = (SamDataauthconfigVO) list.get(i);
      if (vo.getAuthtype().equals(vob.getAuthtype())) {
        return true;
      }
    }
    return false;
  }

  /**
   * 检查对象vo是否在list列表中存在
   * @param vo RightEntity
   * @param list List
   * @return boolean
   */
  private static boolean checkRightVoIsExistInList(RightEntity vo, List list) {

    for (int i = 0; i < list.size(); i++) {
      RightEntity vob = (RightEntity) list.get(i);
      if (vo.getRighttype().equals(vob.getRighttype())) {
        return true;
      }
    }
    return false;
  }



}

package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.Integer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:District </p>
* <p>Description: District,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-09-09 15:00:54.679
*/

public class DistrictVO implements Serializable, Cloneable {
    //Fields
    //ID
    private java.lang.String ID;
    //Name
    private java.lang.String Name;
    //ParentID
    private java.lang.String ParentID;
    //Description
    private java.lang.String Description;
    //Level
    private java.lang.Integer Level;
    //IsDetail
    private java.lang.Integer IsDetail;
    //Name_Png
    private java.lang.String Name_Png;
    //ParentName
    private java.lang.String ParentName;
    //OrgID
    private java.lang.Integer OrgID;
    
    private int muteFlag;
    
	//contructors
    public DistrictVO() {}

    public DistrictVO(java.lang.String ID) {
        this.ID = ID;
    }

	//methods
    public java.lang.String getID() {
        return this.ID;
    }

    public void setID(java.lang.String ID) {
        this.ID = ID;
    }

    public java.lang.String getName() {
        return this.Name;
    }

    public void setName(java.lang.String Name) {
        this.Name = Name;
    }

    public java.lang.String getParentID() {
        return this.ParentID;
    }

    public void setParentID(java.lang.String ParentID) {
        this.ParentID = ParentID;
    }

    public java.lang.String getDescription() {
        return this.Description;
    }

    public void setDescription(java.lang.String Description) {
        this.Description = Description;
    }

    public java.lang.Integer getLevel() {
        return this.Level;
    }

    public void setLevel(java.lang.Integer Level) {
        this.Level = Level;
    }

    public java.lang.Integer getIsDetail() {
        return this.IsDetail;
    }

    public void setIsDetail(java.lang.Integer IsDetail) {
        this.IsDetail = IsDetail;
    }

    public java.lang.String getName_Png() {
        return this.Name_Png;
    }

    public void setName_Png(java.lang.String Name_Png) {
        this.Name_Png = Name_Png;
    }

    public java.lang.String getParentName() {
        return this.ParentName;
    }

    public void setParentName(java.lang.String ParentName) {
        this.ParentName = ParentName;
    }

    public java.lang.Integer getOrgID() {
        return this.OrgID;
    }

    public void setOrgID(java.lang.Integer OrgID) {
        this.OrgID = OrgID;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[Name:").append(Name).append("]");
        sb.append("[ParentID:").append(ParentID).append("]");
        sb.append("[Description:").append(Description).append("]");
        sb.append("[Level:").append(Level).append("]");
        sb.append("[IsDetail:").append(IsDetail).append("]");
        sb.append("[Name_Png:").append(Name_Png).append("]");
        sb.append("[ParentName:").append(ParentName).append("]");
        sb.append("[OrgID:").append(OrgID).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (ID == null ? 0 : ID.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof DistrictVO))
            return false;
        DistrictVO eq = (DistrictVO)vo;
        return ID == null ? eq.getID() == null : ID.equals(eq.getID());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
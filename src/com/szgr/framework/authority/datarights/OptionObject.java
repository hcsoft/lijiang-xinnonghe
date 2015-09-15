package com.szgr.framework.authority.datarights;

public class OptionObject {
	private String key;
	private String value;
	private Object object;

	public OptionObject(){
		
	}
	public OptionObject(String key, String value) {
		this.key = key;
		this.value = value;
	}

	public OptionObject(String key, String value, Object obj) {
		this.key = key;
		this.value = value;
		this.object = obj;
	}

	public String getKey() {
		return this.key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return this.value;
	}

	public String getKeyvalue() {
		if (!("".equals(this.key))) {
			if (this.key == this.value) {
				return this.value;
			}
			return this.key + "-" + this.value;
		}

		return "";
	}

	public void setValue(String value) {
		this.value = value;
	}

	public Object getObject() {
		return this.object;
	}

	public void setObject(Object object) {
		this.object = object;
	}

	public int hashCode() {
		int result = 1;
		result = 31 * result + ((this.key == null) ? 0 : this.key.hashCode());
		return result;
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (super.getClass() != obj.getClass())
			return false;
		OptionObject other = (OptionObject) obj;
		if (this.key == null)
			if (other.key != null)
				return false;
			else if (!(this.key.equals(other.key)))
				return false;
		return true;
	}
}

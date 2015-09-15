package com.szgr.framework.interfaces.stringbased;

import com.szgr.framework.interfaces.stringbased.json.JsonSerilizer;

public class SerializerUtil {

	public static IStringSerilizer getSerilizer() {

		return new JsonSerilizer();
	}

	public static IStringSerilizer getSerilizerJson() {
		
		return new JsonSerilizer();
		
	}

}

package com.szgr.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public  abstract class MathUtils {

	private static DecimalFormat df = new DecimalFormat("##############.00");
	
	private static DecimalFormat NUMBER_FORMAT = new DecimalFormat("##############.00000000");
	
	public static BigDecimal getBigDecimal(double value){
		BigDecimal bd = new BigDecimal(df.format(value));
		return bd;
	}
	public static BigDecimal getBigDecimal(BigDecimal bd){
		return getBigDecimal(bd.doubleValue());
	}
	
	public static BigDecimal getMapBigDecimal(BigDecimal bd){
		String tempValue = NUMBER_FORMAT.format(bd.doubleValue());
		return new BigDecimal(tempValue);
	}
}

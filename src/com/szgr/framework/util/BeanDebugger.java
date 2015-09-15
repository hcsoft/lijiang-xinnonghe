package com.szgr.framework.util;

import java.beans.PropertyDescriptor;
import java.util.Vector;


public class BeanDebugger {

	public static void printBeanInfo(Object bean) {
		java.beans.PropertyDescriptor[] descriptors = getAvailablePropertyDescriptors(bean);

		for (int i = 0; descriptors != null && i < descriptors.length; i++) {
			java.lang.reflect.Method readMethod = descriptors[i]
					.getReadMethod();

			try {
				Object value = readMethod.invoke(bean, null);
				System.out.println(descriptors[i].getName() + "("
						+ descriptors[i].getPropertyType().getName() + ") = "
						+ value);
			} catch (Exception e) {
				// TODO auto generated try-catch
				e.printStackTrace();
			}
		}
	}


	public static java.beans.PropertyDescriptor[] getAvailablePropertyDescriptors(
			Object bean) {
		try {
			// 从 Bean 中解析属性信息并查找相关的 write 方法
			java.beans.BeanInfo info = java.beans.Introspector.getBeanInfo(bean
					.getClass());
			if (info != null) {
				java.beans.PropertyDescriptor pd[] = info
						.getPropertyDescriptors();
				Vector columns = new Vector();

				for (int i = 0; i < pd.length; i++) {
					String fieldName = pd[i].getName();

					if (fieldName != null && !fieldName.equals("class")) {
						columns.add(pd[i]);
					}
				}

				java.beans.PropertyDescriptor[] arrays = new java.beans.PropertyDescriptor[columns
						.size()];

				for (int j = 0; j < columns.size(); j++) {
					arrays[j] = (PropertyDescriptor) columns.get(j);
				}

				return arrays;
			}
		} catch (Exception ex) {
			System.out.println(ex);
			return null;
		}
		return null;
	}

}
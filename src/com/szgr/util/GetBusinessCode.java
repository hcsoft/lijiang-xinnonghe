package com.szgr.util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;

import com.szgr.framework.core.ApplicationContextUtils;

public class GetBusinessCode {
	/**
	 * 根据businesscode 获取businessnumber
	 * @param businessscode COD_BUSINESS中的代码
	 * @return
	 */
	public static String getbusinesscode(final String businessscode) {
		JdbcTemplate jt =  ApplicationContextUtils.getJdbcTemplate();
		String result = jt.execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection con)
					throws SQLException {
				String procName = "{call P_CREATEBUSINESSCODE (?)}";
				CallableStatement stm =  con.prepareCall(procName);
				stm.setString(1, businessscode);
				return stm;
			}
		},new CallableStatementCallback<String>() {
			public String doInCallableStatement(CallableStatement cs)
					throws SQLException, DataAccessException {
				ResultSet rs = cs.executeQuery();
				String str = null;
				
				if(rs.next()){			
					str = rs.getString(1).trim();
				}
				return str;
			}
		});
		return result;
    }

}

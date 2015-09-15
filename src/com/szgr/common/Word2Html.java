package com.szgr.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Word2Html {
	
	public static void main(String[] arg) {
		try {
			String path = "d:\\";

			String name = "doc";
			String filename = path + name + "." + name;
			String targetname = path + name + ".html"; // word excel 为 html ppt
														// 为 jpg

			Process ps = Runtime.getRuntime().exec(
					"wscript " + "E:\\workspaces\\jnds-tdgs\\2.系统源码\\jnds-tdgs\\src\\print.vbs " + filename + " "
							+ targetname);
			ps.waitFor();
			BufferedReader br = new BufferedReader(new InputStreamReader(ps
					.getInputStream()));
			StringBuffer sb = new StringBuffer();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line).append("\n");
			}
			System.out.println(sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

package com.szgr.framework.interfaces;

/**
 * 服务请求接口
 *
 * @param <ReqBean> 请求Bean
 * @param <RetBean> 返回Bean
 */
public interface IService<ReqBean, RetBean> {
	/**
	 * 访问服务
	 * @param url 服务地址
	 * @param t 请求参数
	 * @return 请求结果
	 * @throws Exception
	 */
	public RetBean access(String url, ReqBean t) throws Exception;
}

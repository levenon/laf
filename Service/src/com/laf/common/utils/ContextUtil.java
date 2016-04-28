package com.laf.common.utils;

import org.springframework.context.ApplicationContext;

/**
 * spring容器获取工具
 * @author tangbiao
 *
 */
public class ContextUtil {
	private static ApplicationContext context;

	public static ApplicationContext getContext() {
		return context;
	}

	public static Object getBean(String beanId) throws Exception {
		Object bean = context.getBean(beanId);
		if (bean == null)
			return null;
		return bean;
	}

	public static void setContext(ApplicationContext ctx) {
		context = ctx;
	}
}

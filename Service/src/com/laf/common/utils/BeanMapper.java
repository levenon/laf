package com.laf.common.utils;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.dozer.DozerBeanMapper;

import com.google.common.collect.Lists;

/**
 * 对象之间相互转换
 * @author tangbiao
 *
 */
@SuppressWarnings({"rawtypes", "unchecked"})
public class BeanMapper {
	private static DozerBeanMapper dozer = new DozerBeanMapper();

	public static <T> T map(Object source, Class<T> destinationClass) {
		return dozer.map(source, destinationClass);
	}

	public static <T> List<T> mapList(Collection sourceList,
			Class<T> destinationClass) {
		List destinationList = Lists.newArrayList();
		for (Iterator i$ = sourceList.iterator(); i$.hasNext();) {
			Object sourceObject = i$.next();
			Object destinationObject = dozer
					.map(sourceObject, destinationClass);
			destinationList.add(destinationObject);
		}
		return destinationList;
	}

	public static void copy(Object source, Object destinationObject) {
		dozer.map(source, destinationObject);
	}
}
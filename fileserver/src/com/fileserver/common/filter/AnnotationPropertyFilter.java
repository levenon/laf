package com.fileserver.common.filter;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import net.sf.json.util.PropertyFilter;

public class AnnotationPropertyFilter implements PropertyFilter {

	public boolean apply(Object object, String name, Object value) {
		// 通过读取注解来决定是否序列化
		try {
			// 获取类上的注解
			JSONPropertyFilter clazzAnnotation = object.getClass().getAnnotation(JSONPropertyFilter.class);
			// 如果类上有注解,并且值为true，表示需要过滤
			if (clazzAnnotation != null && clazzAnnotation.value()) {
				// 不要这个字段 返回true
				return true;
			}
			// 获取字段上的注解
			Field field = object.getClass().getDeclaredField(name);
			JSONPropertyFilter fieldAnnotation = field.getAnnotation(JSONPropertyFilter.class);
			// 如果字段上注解了，并且值为true，表示需要过滤
			if (null != fieldAnnotation && fieldAnnotation.value()) {
				// 不要这个字段 返回true
				return true;
			}
			// 通过属性描述器 获取属性get方法的注解
			PropertyDescriptor pd = new PropertyDescriptor(field.getName(), object.getClass());
			Method getMethod = pd.getReadMethod();
			if (null != getMethod) {
				JSONPropertyFilter methodAnnotation = getMethod.getAnnotation(JSONPropertyFilter.class);
				// 如果get方法上注解了，并且值为true，表示需要过滤
				if (null != methodAnnotation && methodAnnotation.value()) {
					// 不要这个字段 返回true
					return true;
				}
			}
		} catch (NoSuchFieldException e) {
			return false;
		} catch (SecurityException e) {
			return false;
		} catch (IntrospectionException e) {
			return false;
		}
		return false;
	}
}

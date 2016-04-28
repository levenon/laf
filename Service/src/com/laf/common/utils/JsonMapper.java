package com.laf.common.utils;

import java.io.IOException;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.fasterxml.jackson.module.jaxb.JaxbAnnotationModule;

/**
 * json转换
 * @author tangbiao
 *
 */
public class JsonMapper {
	private static final Logger logger = LoggerFactory.getLogger(JsonMapper.class);
	private ObjectMapper mapper;

	public JsonMapper() {
		this(null);
	}

	public JsonMapper(JsonInclude.Include include) {
		this.mapper = new ObjectMapper();

		if (include != null) {
			this.mapper.setSerializationInclusion(include);
		}

		this.mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
	}

	public static JsonMapper nonEmptyMapper() {
		return new JsonMapper(JsonInclude.Include.NON_EMPTY);
	}

	public static JsonMapper nonDefaultMapper() {
		return new JsonMapper(JsonInclude.Include.NON_DEFAULT);
	}

	public String toJson(Object object) {
		try {
			return this.mapper.writeValueAsString(object);
		} catch (IOException e) {
			logger.warn("write to json string error:" + object, e);
		}
		return null;
	}

	public <T> T fromJson(String jsonString, Class<T> clazz) {
		if (StringUtils.isEmpty(jsonString)) {
			return null;
		}
		try {
			return this.mapper.readValue(jsonString, clazz);
		} catch (IOException e) {
			logger.warn("parse json string error:" + jsonString, e);
		}
		return null;
	}

	public <T> T fromJson(String jsonString, JavaType javaType) {
		if (StringUtils.isEmpty(jsonString)) {
			return null;
		}
		try {
			return this.mapper.readValue(jsonString, javaType);
		} catch (IOException e) {
			logger.warn("parse json string error:" + jsonString, e);
		}
		return null;
	}

	public JavaType createCollectionType(Class<?> collectionClass,
			Class<?>[] elementClasses) {
		return this.mapper.getTypeFactory().constructParametricType(
				collectionClass, elementClasses);
	}

	public <T> T update(String jsonString, T object) {
		try {
			return this.mapper.readerForUpdating(object).readValue(jsonString);
		} catch (JsonProcessingException e) {
			logger.warn("update json string:" + jsonString + " to object:"
					+ object + " error.", e);
		} catch (IOException e) {
			logger.warn("update json string:" + jsonString + " to object:"
					+ object + " error.", e);
		}
		return null;
	}

	public String toJsonP(String functionName, Object object) {
		return toJson(new JSONPObject(functionName, object));
	}

	public void enableEnumUseToString() {
		this.mapper.enable(SerializationFeature.WRITE_ENUMS_USING_TO_STRING);
		this.mapper.enable(DeserializationFeature.READ_ENUMS_USING_TO_STRING);
	}

	public void enableJaxbAnnotation() {
		JaxbAnnotationModule module = new JaxbAnnotationModule();
		this.mapper.registerModule(module);
	}

	public ObjectMapper getMapper() {
		return this.mapper;
	}
}

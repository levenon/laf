package com.fileserver.common.utils;

import java.io.IOException;
import java.util.Map;

import net.sf.json.JSONObject;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

@SuppressWarnings("unchecked")
public class JsonUtil {
	public static Map<String, Object> readJson2Map(JSONObject json) {

	    try {
	    	ObjectMapper mapper = new ObjectMapper();
	    	
	        Map<String, Object> map = mapper.readValue(json.toString(), Map.class);
	        
	        return map;

	    } catch (JsonParseException e) {

	        e.printStackTrace();

	    } catch (JsonMappingException e) {

	        e.printStackTrace();

	    } catch (IOException e) {

	        e.printStackTrace();

	    }

	    return null;
	}
}

package com.laf.service.common;

import java.util.Date;

import org.springframework.stereotype.Service;

import com.laf.entity.RequestLog;
import com.laf.service.BaseService;

@Service
public class RequestLogService extends BaseService {

	public RequestLog requestLogById(Integer id) {

		Object object = findById(RequestLog.class, id);
		if (object != null && object instanceof RequestLog) {
			return (RequestLog)object;
		}
		return null;
	}
	
	public RequestLog addRequestLog(String method, String version, String params, Date time, String code, String device) {
		
		RequestLog requestLog = new RequestLog();
		requestLog.setMethod(method);
		requestLog.setVersion(version);
		requestLog.setParams(params);
		requestLog.setTime(time);
		requestLog.setCode(code);
		requestLog.setDevice(device);
		
		save(requestLog);
		
		return requestLog;
	}
	
	public void removeRequestLog(Integer id) {

		RequestLog requestLog = new RequestLog();
		requestLog.setId(id);

		delete(requestLog);
	}
	
	public RequestLog updateRequestLog(Integer id, String method, String version, String params,
			Date time, String code, String device) {

		RequestLog requestLog = requestLogById(id);
		
		if (requestLog != null) {

			requestLog.setMethod(method);
			requestLog.setVersion(version);
			requestLog.setParams(params);
			requestLog.setTime(time);
			requestLog.setCode(code);
			requestLog.setDevice(device);
			
			update(requestLog);
		}
		return requestLog;
	}
}

package com.laf.service.M9;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM9 extends Method9_1_0 {

	public IService  matchVersion(String version){
		
		IService service = super.matchVersion(version);
		
		if(service == null){
			service = this;
		}
		return service;
	}
}

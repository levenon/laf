package com.laf.service.M18;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM18 extends Method18_1_0 {

	public IService  matchVersion(String version){
		
		IService service = super.matchVersion(version);
		
		if(service == null){
			service = this;
		}
		return service;
	}
}
